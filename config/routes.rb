Rails.application.routes.draw do
  namespace :api do
    get 'auth/auth'
  end
    namespace :api do
        get 'auth' => 'auth#auth'
    end
end
