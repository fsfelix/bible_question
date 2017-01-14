class QuestionsController < ApplicationController
    before_action :find_question, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
    before_action :authenticate_user!, except: [:index, :show, :tagged]
    before_action :search_init

    def index
        parse_params()
        @search = Question.search(params[:q])
        @questions = @search.result.order("created_at DESC").uniq
        #@questions = Question.all.order("created_at DESC")
        @users     = User.all
    end

    def show
      # @answers = Answer.where(question_id: @question)
      parse_params()
      @search = Question.search(params[:q])

      @answers = Answer.where(question_id: @question).order(:cached_weighted_score).reverse
    end

    def new
        @questions = @search.result.order("created_at DESC").uniq
        @question = current_user.questions.build
    end

    def create
        @question = current_user.questions.build(question_params)
        if @question.save
            redirect_to @question
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        if @question.update(question_params)
            redirect_to @question
        else
            render 'edit'
        end
    end

    def destroy
        @question.destroy
        redirect_to root_path
    end

    def upvote
        @question.upvote_by current_user
        redirect_to :back
    end

    def downvote
        @question.downvote_by current_user
        redirect_to :back
    end

    def tagged
      @users = User.all
      if params[:tag].present?
        @questions = Question.tagged_with(params[:tag]).order("created_at DESC")
      else
        @questions = Question.all.order("created_at DESC")
      end
    end

    private

    def find_question
        @question = Question.find(params[:id])
    end

    def question_params
        params.require(:question).permit(:title, :description, :tag_list)
    end

    def search_init
      @search = Question.search(params[:q])
    end

    def parse_params
        if params[:q] != nil
            params[:q][:combinator] = 'or'
            params[:q][:groupings] = []
            custom_words = params[:q].delete('description_or_title_or_tags_name_cont_any')
            custom_words.split(' ').each_with_index do |word, index|
                params[:q][:groupings][index] = {description_or_title_or_tags_name_cont_any: word}
            end
        end
    end

end
