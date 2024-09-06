Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/login', to: 'login#login'
  post '/forgot_password', to: 'login#forgot_password'
  resource :users, only: %i[create] do
    delete :self_destroy
  end
  get '/cep/search/:cep', to: 'cep#search'
  resources :contacts, only: %i[create update show destroy] do
    collection do
      get :search
    end
  end
end
