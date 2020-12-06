Rails.application.routes.draw do
    get 'main/index'
    namespace :api do
        post 'auth/login'
        get 'auth/me'
        get 'auth/register'
        delete 'auth/logout'

        get 'profile/edit'
        get 'profile/:id/photo' => 'profile#photo'
        get 'profile/friends' => 'profile#friends'
        post 'profile/:id/subscribe' => 'profile#subscribe'
        post 'profile/:id/unsubscribe' => 'profile#unsubscribe'
        get 'profile/:id' => 'profile#show'

        # get 'photo/:id'

        get 'post/all/:id' => 'posts#show_user'
        get 'post/:id' => 'posts#index'
        post 'post/:id/add' => 'posts#add'

        # get 'comments/:id'
        # post 'comments/:id'

        # get 'messages'
        # get 'messages/:id'
        # post 'messages/:id'
    end
    root 'main#index'
    get '/*path' => 'main#index'
end
