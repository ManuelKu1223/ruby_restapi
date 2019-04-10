Rails.application.routes.draw do
  resources :posts

  root 'posts#splash'

  resources :demo, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
