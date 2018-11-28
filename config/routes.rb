Rails.application.routes.draw do
  root 'top#index'
  devise_scope :user do
    #プロフィール編集画面＆更新
    get 'profile_edit', to: 'users/registrations#profile_edit', as: 'profile_edit'
    patch 'profile_update', to: 'users/registrations#profile_update', as: 'profile_update'
  end

  resources :top  do
    get "searchcondition",on: :collection
    get "search" ,on: :collection
  end

  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]

  #get 'top/index'
  #get 'top/:id' => "top#show"
  resources :mypage,only:[:show]
  #get 'mypage/show'
  devise_for :users,module: :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
