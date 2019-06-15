Rails.application.routes.draw do
  root 'top#index'#トップページ
  devise_for :users,module: :users
  devise_scope :user do
    #プロフィール編集画面へ
    get 'profile_edit', to: 'users/registrations#profile_edit', as: 'profile_edit'
    #プロフィール更新画面へ
    patch 'profile_update', to: 'users/registrations#profile_update', as: 'profile_update'
  end

  resources :top  do
    get "searchcondition",on: :collection
    get "search" ,on: :collection
    get "about" ,on: :collection
    get "privacy_policy" ,on: :collection
    get "inquiry",on: :collection
  end

  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
  resources :mypage,only:[:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
