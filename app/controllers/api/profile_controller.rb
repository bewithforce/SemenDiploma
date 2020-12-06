require 'base64'

class Api::ProfileController < ApplicationController
    skip_before_action :verify_authenticity_token

    def edit
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end

        if params[:email] != nil
            user.email = params[:email]
        end

        if params[:password] != nil
            user.email = params[:email]
        end

        if params[:name] != nil
            user.name = params[:name]
        end

        if params[:photo] != nil
            file = params[:photo]
            content = File.binread(file)
            encoded = Base64.encode64(content)
            photo_id = Photo.create(photo: encoded).id
            user.photo_id = photo_id
        end

        if params[:birthday] != nil
            user.birthday = params[:birthday]
        end

        if params[:current_city] != nil
            user.current_city = params[:current_city]
        end

        if params[:study_place] != nil
            user.study_place = params[:study_place]
        end

        if params[:chess_level] != nil
            user.chess_level = params[:chess_level]
        end

        if params[:fide_rating] != nil
            user.fide_rating = params[:fide_rating]
        end

        if params[:about] != nil
            user.about = params[:about]
        end

        if params[:hobbies] != nil
            user.hobbies = params[:hobbies]
        end

        user.save
        render json: {}, status: 200
    end

    def photo
        user_id = params[:id]
        user = User.find(user_id)
        if user == nil
            render json: {}, status: 403
        else
            photo = Photo.find(user.photo_id)
            render json: { "photo": photo }, status: 200
        end
    end

    def friends
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end
        user_id = user.id
        friends_records = Friend.where ["user1_id = :user1_id or user2_id = :user1_id", { user1_id: user_id, user2_id: user_id }]
        friends_id = []
        friends_records.each { |x|
            x.user1_id == user_id ? friends_id.push({ user_id: x.user2_id }) : friends_id.push({ user_id: x.user1_id })
        }
        render :json => friends_records.to_json, status: 200
    end

    def subscribe
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end
        target_id = params[:id]
        target = User.find_by_id(target_id)
        if target == nil
            render json: {}, status: 403
            return
        end
        Follower.create(user_id: user.id, following_id: target_id)
        render json: {}, status: 200
    end

    def unsubscribe
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end
        target_id = params[:id]
        following = Follower.where ["user_id = ?", user.id]
        if following == nil
            render json: {}, status: 403
            return
        end
        following.where(following_id: target_id).delete_all
        render json: {}, status: 200
        end

    def show
        user_id = params[:id]
        user = User.find(user_id)
        if user == nil
            render json: {}, status: 403
            return
        end

        photo = Photo.find(user.photo_id)
        answer = JSON.parse user.to_json(:only => [:about, :birthday, :chess_level, :current_city, :fide_rating, :hobbies, :name, :online, :photo_id, :study_place])
        answer = answer.except("photo_id")
        answer[:photo] = photo.photo
        render :json => answer, status: 200
    end
end
