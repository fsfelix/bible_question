class AnswersController < ApplicationController
    before_action :authenticate_user!

    def create
        @question = Question.find(params[:question_id])
        @answer = Answer.create(params[:answer].permit(:content))
        @answer.user_id = current_user.id
        @answer.question_id = @question.id

        if @answer.save
            redirect_to question_path(@question)
        else
            render 'new'
        end
    end

end
