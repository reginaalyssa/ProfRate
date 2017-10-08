Rails.application.routes.draw do
  root 'pages#home'
  resources :professors, :except => [:destroy, :edit, :update] do
    collection do
      post :add_course
    end
  end
  resources :courses, :except => [:destroy] do
    collection do
      post :add_professor
    end
  end
  resources :reviews, :only => [:new, :create] do
    collection do
      get ':professor_id/:course_id', action: :show, as: 'show'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
