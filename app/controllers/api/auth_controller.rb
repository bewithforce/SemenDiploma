require 'securerandom'

class Api::AuthController < ApplicationController
    def login
        email = params['email']
        password = params['password']
        flag = User.where(["email=:email and password=:password", {email: email, password: password}]).length == 0 ? false : true
        if flag
            token = SecureRandom.hex
            cookies[:auth_token] = token
            render json: {}, status: 200
        else
            render json: {}, status: 403
        end
    end

    def me
        cookie = cookies[:auth_token]
        flag = User.where(["token=?", cookie]).length == 0 ? false : true
        if flag
            render json: {}, status: 200
        else
            render json: {}, status: 403
        end
    end

    def register
        email = params['email']
        password = params['password']
        token = SecureRandom.hex
        regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        if (email =~ regex) != 0
            render json: {}, status: 403
        else
            cookies[:auth_token] = token
            User.create(email: email, password: password, token: token)
            render json: {}, status: 200
        end
    end

    def logout

    end
end
