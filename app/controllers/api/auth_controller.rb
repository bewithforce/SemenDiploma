require 'securerandom'
require 'json'

class Api::AuthController < ApplicationController
    skip_before_action :verify_authenticity_token

    def login
        email = params['email']
        password = params['password']
        user = User.find_by_email(email)
        if user == nil or user.password != password
            render json: {}, status: 403
            return
        end

        token = SecureRandom.hex
        user.token = token
        user.online = true
        user.save

        cookies[:auth_token] = token
        photo = Photo.find_by_id(user.photo_id)
        answer = JSON.parse user.to_json(:only => [:about, :birthday, :chess_level, :current_city, :current_country, :fide_rating, :hobbies, :name, :surname, :online, :study_place])
        answer[:photo] = photo.photo
        render :json => answer, status: 200
    end

    def me
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
        else
            render json: {}, status: 200
        end
    end

    def register
        email = params['email']
        password = params['password']
        # token = SecureRandom.hex
        regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        if (email =~ regex) != 0
            render json: {}, status: 403
        else
            # cookies[:auth_token] = token
            User.create(
              about: "",
              birthday: Date.new(1997, 6, 11),
              chess_level: "",
              current_city: "",
              fide_rating: 0,
              hobbies: "",
              name: "",
              photo_id: 0,
              study_place: "",
              email: email,
              password: password,
              online: false #,
            # token: token
            )
            render json: {}, status: 200
        end
    end

    def logout
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user != nil
            user.token = ""
            user.online = false
            user.save
        end
        render json: {}, status: 200
    end
end
