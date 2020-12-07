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

        cookies["auth_token"] = {
          value: token,
          secure: true,
          same_site: "None"
        }
        photo = Photo.find_by_id(user.photo_id)
        answer = JSON.parse user.to_json(:only => [:id, :email, :about, :birthday, :chess_level, :current_city, :current_country, :fide_rating, :hobbies, :name, :surname, :online, :study_place])
        answer[:photo] = photo.photo
        render :json => answer, status: 200
    end

    def me
        cookies.each do |cookie|
            puts cookie
        end
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
        else
            photo = Photo.find_by_id(user.photo_id)
            answer = JSON.parse user.to_json(:only => [:id, :email, :about, :birthday, :chess_level, :current_city, :current_country, :fide_rating, :hobbies, :name, :surname, :online, :study_place])
            answer[:photo] = photo.photo
            render :json => answer, status: 200
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
              about: "Chess coach",
              birthday: "June 16, 1997",
              chess_level: "1st rank",
              current_city: "Minsk",
              current_country: 'Belarus',
              fide_rating: 2000,
              hobbies: "Chess",
              name: "User",
              surname: "User",
              study_place: "BSUIR",
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
