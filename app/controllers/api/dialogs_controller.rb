class Api::DialogsController < ApplicationController
    def all
        token = cookies[:auth_token]
        user = User.find_by_token(token)
    end
end
