Rails.application.routes.draw do
  root 'pages#home'
  resources :professors, :except => [:destroy, :edit, :update] do
    collection do
      post :add_course
      get ':id/courses/:course_id', action: :display_reviews_of_subject, as: 'reviews'
    end
  end
  resources :courses, :except => [:destroy] do
    collection do
      post :add_professor
    end
  end
  resources :reviews, :only => [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
