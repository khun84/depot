Rails.application.routes.draw do
  # overwrite the url path name for sessions
  # change to use self defined registration controller
  devise_for :users, skip: :registrations, path: '',
             path_names: {sign_in: 'login',
                          sign_out: 'logout',
                          sign_up:'register',
             },
             controllers: {registrations: 'registrations'}

  # set the prefix of the path so that we can rename the path helper method
  ## BECAREFUL, USE :user insteand :users
  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :login
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', as: :logout
    # create user has the same path name as
    get 'register', to: 'registrations#new', as: :register
    post 'register', to: 'registrations#create'
    post '/', to: 'store#index'

  end

  # for current user
  get 'users/profile', to: 'users#show_current_user', as: :current_user
  get 'users/edit', to: 'users#edit', as: :edit_current_user
  patch 'users/profile', to: 'users#update', as: :update_current_user
  # for future admin access
  get 'users/:id', to: 'users#show', as: :user
  get 'users', to: 'users#index', as: :users

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: :store_index, via: :all
  end

  resources :products do
    get :who_bought, on: :member
  end

  # serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
