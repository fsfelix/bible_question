class QuestionsController < ApplicationController
    before_action :find_question, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
    before_action :authenticate_user!, except: [:index, :show, :tagged]

    def index
        @search = Question.search(params[:q])
        @questions = @search.result
        #@questions = Question.all.order("created_at DESC")
        @users     = User.all
    end

    def show
      # @answers = Answer.where(question_id: @question)
      @answers = Answer.where(question_id: @question).order(:cached_weighted_score).reverse
    end

    def new
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

end
