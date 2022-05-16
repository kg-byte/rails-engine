Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      resources :merchants, only: [:index, :show]
    end
  end

  get 'api/v1/merchants/:merchant_id/items', to: 'api/v1/merchant_items#index'
end
