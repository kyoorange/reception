Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tags, only: [ :index, :show, :create, :update, :destroy ] do
        get "occupy", to: "tags#current_occupy" # 特定のタグの占有情報
      end

      # occupy_statusエンドポイントを追加
      get "tags/occupy_status", to: "tags#occupy_status"

      # 電話番号検索
      resources :registrants, only: [ :index, :show, :create, :update, :destroy ] do
        get "phone/:phone", on: :collection, action: :find_by_phone
      end

      resources :occupies, only: [ :index, :create, :update, :destroy ]
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  root "registrants#home"
  ActiveAdmin.routes(self)

  resources :registrants, only: [ :show ]
  resources :messages, only: [ :index, :create, :new, :show ]

  # その他のルーティング
  get "memo" => "registrants#memo"
  get "message" => "messages#index"
  get "analytics" => "registrants#analytics"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "registrants/transfer" => "registrants#transfer"
end
