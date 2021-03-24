Rails.application.routes.draw do

  root 'home#index'

  resources :promotions do
    post 'generate_coupons', on: :member
  end
  resources :coupons, only: [] do
    post 'disable', on: :member
  end
  resources :product_categories
end
