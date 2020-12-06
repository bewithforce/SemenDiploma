Rails.application.routes.draw do
  namespace :api do
    get 'dialog/show'
  end
  namespace :api do
    get 'messages/show'
    get 'messages/add'
  end
  namespace :api do
    get 'news/show'
  end
  namespace :api do
    get 'comments/show'
    get 'comments/add'
    get 'comments/delete'
  end
    get 'main/index'
    namespace :api do
        post 'auth/login'
        get 'auth/me'
        get 'auth/register'
        delete 'auth/logout'

        get 'profile/edit'
        get 'profile/all'
        get 'profile/:id/photo' => 'profile#photo'
        get 'profile/friends' => 'profile#friends'
        post 'profile/:id/subscribe' => 'profile#subscribe'
        post 'profile/:id/unsubscribe' => 'profile#unsubscribe'
        get 'profile/:id' => 'profile#show'

        # get 'photo/:id'

        get 'post/all/:id' => 'posts#show_user'
        get 'post/:id' => 'posts#index'
        post 'post/:id/add' => 'posts#add'
        delete 'post/:id' => 'posts#delete'

        get 'comments/:id' => 'comments#show'
        post 'comments/:id/add' => 'comments#add'
        delete 'comments/:id/delete' => 'comments#delete'

        # get 'messages'
        # get 'messages/:id'
        # post 'messages/:id'
    end
    root 'main#index'
    get '/*path' => 'main#index'
end
