Wp102dv401::Application.routes.draw do

  get "instagram/index"

  get "instagram/new"

  get "javascripts/maps"

  # Footer sidorna
  get "/om-kartr" => "pages#about", as: :pages_about
  get "/anvandarvillkor" => "pages#terms", as: :pages_terms
  get "/sekretess" => "pages#privacy", as: :pages_privacy
  get "/hjalp" => "pages#help", as: :pages_help


  get "/api" => "pages#api", as: :pages_api

  ## API routes
  match "javascripts/maps.:format" => "javascripts#maps"
  match "/api/v1/:api_key.:format" => "maps#embed", as: :embed

  # Tell Devise in which controller we will implement Omniauth callbacks
  devise_for :users, controllers: {
    omniauth_callbacks: "authentications",
    registrations: "registrations"
  }

  devise_scope :user do
    # Session routes
    delete "/logga-ut" => "devise/sessions#destroy", as: :destroy_user_session
    # Confirm routes
    get "/ny-bekraftelse" => "devise/confirmations#new", as: :new_user_confirmation
    # Password routes
    get "/nytt-losenord" => "devise/passwords#new", as: :new_user_password
    # Registration routes
    get "/registrering" => "registrations#new", as: :new_user_registration
    get "/redigera-profil" => "registrations#edit", as: :edit_user_registration

    # Routes for provider authentication
    get "/users/auth/:provider" => "authentications#passthru"
  end
  get "/search" => "maps#search", as: :maps_search

  get "/searches/search"
  get "/kartor/resultat/:query" => "searches#result", as: :search_result
  get "/searches/autocomplete"

  scope(path_names: { new: "ny", edit: "redigera" }) do

    resources :home, only: [ :index ], path: "hem"

    resources :dashboard, only: [ :index ], path: "startsida"

    # Denna profiles har inga egna routes utan pekar bara på profile_maps_paths
    resources :profiles, only: [], path: '' do
      get "show_maps", path: "kartlista"

      # Alla kartans routes uton "index" går genom profile.
      resources :maps, except: [ :index ], path: "kartor" do

        # För url:ens skull går "new"- och "edit"- routes genom profile_maps
        resources :marks, only: [ :new, :edit, :create ], path: "markeringar"
      end
    end

    # profiles-routes
    resources :profiles, only: [ :index ], path: "profiler"
    resources :profiles, only: [ :show ], path: "profil"

    resources :maps, only: [ :index ], path: "kartor" do
      post "toggle"

      resources :marks, path: "markeringar"

      # tillåter bara att man skapar dessa genom maps. Alla andra routes går direkt
      resources :status_updates, only: [ :create ], path: "skapa-uppdatering"
      resources :map_comments, only: [ :create ], path: "skapa-kommentar"
    end

    # PUT/DELETE /kart-kommentarer/:id
    resources :map_comments, only: [ :update, :destroy ], path: "kart-kommentarer" do
      post "toggle_like"
    end

    # PUT/DELETE /status-uppdateringar/:id
    resources :status_updates, only: [ :update, :destroy ], path: "status-uppdateringar" do
      post "toggle_like"

      # Tillåter bara att skapa statuskommentarer genom statusuppdateringen.
      resources :status_comments, only: [ :create ], path: "kommentarer"
    end

    # PUT/DELETE /status-kommentarer/:id
    resources :status_comments, only: [ :update, :destroy ], path: "status-kommentarer" do
      post "toggle_like"
    end

    # PUT/DELETE /markeringar/:id
    resources :marks, only: [ :update, :destroy ], path: "markeringar"

  end


  ### TEST MED INSTAGRAM
  #get "/instagram" => "instagram#index"
  #get "/instagram/activate" => "instagram#activate"
  #get "/instagram/auth" => "instagram#auth"
  #get "/instagram/callback" => "instagram#callback"

  root to: "home#index"


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
