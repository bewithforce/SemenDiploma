Rails.application.routes.draw do
    mount ActionCable.server => '/cable'

    namespace :api do
        post 'auth/login'
        get 'auth/me'
        get 'auth/register'
        delete 'auth/logout'

        get 'profile/edit' => 'profile#edit'
        post 'profile/edit' => 'profile#settings'
        post 'profile/password' => 'profile#edit_password'
        get 'profile/all'
        get 'profile/friends' => 'profile#friends'
        get 'profile/friends/:id' => 'profile#friends'
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
        #
        #
        #

        get 'news/all' => 'news#all'
        get 'news/:id' => 'news#show'
    end
    root 'main#index'
    get '/*path' => 'main#index'
end
