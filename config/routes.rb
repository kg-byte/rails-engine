Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/v1/merchants/find', to: 'api/v1/search_merchants#show'
  get 'api/v1/merchants/find_all', to: 'api/v1/search_merchants#index'
  
  get 'api/v1/items/find', to: 'api/v1/search_items#show'
  get 'api/v1/items/find_all', to: 'api/v1/search_items#index'
  get 'api/v1/items/:id/merchant', to: 'api/v1/item_merchant#show'
 
  namespace :api do 
    namespace :v1 do 
      namespace :revenue do 
        resources :merchants, only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] 
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end


  get 'api/v2/merchants/find', to: 'api/v2/search_merchants#show'
  get 'api/v2/merchants/find_all', to: 'api/v2/search_merchants#index'
  get 'api/v2/items/find', to: 'api/v2/search_items#show'
  get 'api/v2/items/find_all', to: 'api/v2/search_items#index'
  get 'api/v2/items/:id/merchant', to: 'api/v2/item_merchant#show'
  namespace :api do 
    namespace :v2 do 
      post '/api_keys', to: 'api_keys#create'
      delete '/api_keys', to: 'api_keys#destroy'
      get '/api_keys', to: 'api_keys#index'
      resources :items, only: [:index, :show, :create, :update, :destroy] 
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end

end
