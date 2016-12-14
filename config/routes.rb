Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    member do
      get "like", to: "questions#upvote"
      get "dislike", to: "questions#downvote"
    end
    resources :answers
  end
  root 'questions#index'
end
