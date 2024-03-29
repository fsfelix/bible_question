Rails.application.routes.draw do
  get 'tags', to: "tags#index"
  devise_for :users
  resources :questions do
    member do
      get "like", to: "questions#upvote"
      get "dislike", to: "questions#downvote"
    end
    resources :answers do
      member do
        get "like", to: "answers#upvote"
        get "dislike", to: "answers#downvote"
      end
    end
  end
  root 'questions#index'
  match 'tagged' => 'questions#tagged', :via => [:get], :as => 'tagged'
end
