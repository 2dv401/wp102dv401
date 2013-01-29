Wp102dv401::Application.routes.draw do

  get "/om-kartr" => "pages#about", :as => :pages_about
  get "/anvandarvillkor" => "pages#terms", :as => :pages_terms
  get "/sekretess" => "pages#privacy", :as => :pages_privacy
  get "/hjalp" => "pages#help", :as => :pages_help

  get "dashboard/index"

  get "home/index"

  # Tell Devise in which controller we will implement Omniauth callbacks
  devise_for :users, :controllers => { :omniauth_callbacks => "authentications" }

  devise_scope :user do
    # Session routes
    get "/login" => "devise/sessions#new", :as => :new_user_session
    post "/login" => "devise/sessions#create", :as => :user_session
    delete "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
    # Confirm routes
    get "/confirmation" => "devise/confirmations#new", :as => :new_user_confirmation
    post "/confirmation" => "devise/confirmations#create", :as => :user_confirmation
    # Password routes
    get "/password" => "devise/passwords#new", :as => :new_user_password
    post "/password" => "devise/passwords#create", :as => :user_password
    get "/password/edit" => "devise/passwords#edit", :as => :edit_user_password
    # Registration routes
    get "/register" => "devise/registrations#new", :as => :new_user_registration
    post "/register" => "devise/registrations#create", :as => :user_registration
    get "/user/edit" => "devise/registrations#edit", :as => :edit_user_registration
    get "/register/cancel" => "devise/registrations#cancel", :as => :cancel_user_registration
    # Routes for provider authentication
    get "/users/auth/:provider" => "authentications#passthru"
  end

  resources :dashboard
  resources :profiles do
    resources :maps
  end
  
  resources :maps do
    post 'toggle'
    resources :marks
    resources :status_updates do
      post 'toggle_like'
    end
    resources :map_comments do
      post 'toggle_like'
    end
  end

  resources :status_updates do
    resources :status_comments do
      post 'toggle_like'
    end
  end

  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
