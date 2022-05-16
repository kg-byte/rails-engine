Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :merchants, only: [:index, :show]
    end
  end

  get 'api/v1/merchants/:merchant_id/items', to: 'api/v1/merchant_items#index'
  get 'api/v1/items/:id/merchant', to: 'api/v1/item_merchant#show'
end
