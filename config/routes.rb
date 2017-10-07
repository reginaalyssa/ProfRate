Rails.application.routes.draw do
  resources :professors do
    collection do
      post :add_course
    end
  end
  resources :courses do
    collection do
      post :add_professor
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
