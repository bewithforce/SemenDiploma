Rails.application.routes.draw do
    get 'main/index'
    namespace :api do
        post 'auth/login'
        get 'auth/me'
        get 'auth/register'
        get 'auth/logout'

        # get 'profile/edit'
        # get 'profile/:id'
        # get 'profile/:id/friends'
        # post 'profile/:id/subscribe'
        # post 'profile/:id/unsubscribe'

        # get 'photo/:id'

        # get 'post/all/:id'
        # get 'post/:id'
        # post 'post/:id'

        # get 'comments/:id'
        # post 'comments/:id'

        # get 'messages'
        # get 'messages/:id'
        # post 'messages/:id'
    end
    root 'main#index'
    get '/*path' => 'main#index'
end
