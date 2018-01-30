Rails.application.routes.draw do

  
  resource :sessions do
	collection {post :login_attempt }
  end
  root :to => 'sessions#login'
  get "signup", :to => "users#new"
  get "login", :to => "sessions#login"
  get "logout", :to => "sessions#logout"
  get "home", :to => "welcome#index"
  get "profile", :to => 'users#show'
  get "setting", :to => "users#edit"
  resources :users

  get 'welcome/index'
  get 'welcome/hidden'
  get 'welcome/search_all'
  get 'welcome/denied', as: 'denied'
  get '/parts/live_search', to: 'parts#live_search', as: 'search'
  get '/pcbs/live_search', to: 'pcbs#live_search', as: 'lookup'
  get '/parts/add_qte', to: 'parts#add_qte', as: 'add_qte'
  get '/parts/del_qte', to: 'parts#del_qte', as: 'del_qte'
  get '/pcbs/add_all', to: 'pcbs#add_all', as: 'add_all'
  get '/shopping_lists/upd_all', to: 'shopping_lists#upd_all', as: 'upd_all'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :parts do
	  collection {post :import }
	  collection {post :move_location }
	  collection {post :move_manufacturer }
	  collection {post :move_package }
	  collection {post :move_type }
	  collection {post :add_qte }
	  collection {post :set_qte }
	  collection {post :del_qte }
	  collection {post :add_qte_s }
	  collection {post :del_qte_s }
  end
  resources :locations do
	collection {post :import }
  end
  resources :packages do
	collection {post :import }
  end
  resources :manufacturers do
	collection {post :import }
  end
  resources :types do
	collection {post :import }
  end
  
  # Movies DB
  resources :movies do
	collection {post :import }
	collection {get :call_api }
  end
  resources :mformats do
	collection {post :import }
  end
  resources :mlanguages do
	collection {post :import }
  end
  resources :msubtitles do
	collection {post :import }
  end
  resources :mtypes do
	collection {post :import }
  end
  resources :myears do
	collection {post :import }
  end
  resources :qualities do
	collection {post :import }
  end
  resources :threeds do
	collection {post :import }
  end
  resources :genres
  
  # BOOKS
  resources :books, :authors, :publishers do
	collection {post :import }
  end
  
  # PCB  
  resources :pcbs do
	  collection {post :import }
	  end

  # PROJECT  
  resources :projects do
	  collection {post :import }
	  end
  
  resources :shopping_lists
end
