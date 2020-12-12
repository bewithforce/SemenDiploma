require 'base64'

class Api::ProfileController < ApplicationController
    skip_before_action :verify_authenticity_token

    def edit
        token = cookies[:auth_token]
        user = User.find_by_token(token)
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
            encoded = Base64.encode64(content).to_s
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

    def all
        token = cookies[:auth_token]
        self_id = User.find_by_token(token).id

        users = User.all

        answer = []
        users.each do |user|
            user
            photo = Photo.find_by_id(user.photo_id)
            user_json = JSON.parse user.to_json(:only => [:id, :email, :about, :birthday, :chess_level, :current_city, :current_country, :fide_rating, :hobbies, :name, :surname, :online, :study_place])
            user_json[:isFollowed] = is_following(self_id, user.id)
            user_json[:photo] = photo.photo
            answer.push(user_json)
        end

        render :json => answer, status: 200
    end

    def friends
        token = cookies[:auth_token]
        user = User.find_by_token(token)
        if user == nil
            render json: {}, status: 403
            return
        end

        answer = []
        friends_records = Follower.where(user_id: user.id)
        friends_records.each do |x|
            friend = get_user_by_id(x.following_id, user.id)
            if friend != nil
                answer.push(friend)
            end
        end
        render :json => answer.to_json, status: 200
    end

    def subscribe
        token = cookies[:auth_token]
        user = User.find_by_token(token)
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

        unless is_following(user.id, target_id)
            Follower.create(user_id: user.id, following_id: target_id)
        end
        render json: {}, status: 200
    end

    def unsubscribe
        token = cookies[:auth_token]
        user = User.find_by_token(token)
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
        token = cookies[:auth_token]
        user = User.find_by_token(token)

        user_id = params[:id]
        answer = get_user_by_id(user_id, user.id)
        if answer == nil
            render :json => {}, status: 403
            return
        end
        render :json => answer, status: 200
    end

    def settings
        token = cookies[:auth_token]
        user = User.find_by_token(token)

        if user == nil
            render json: {}, status: 403
            return
        end
        render :json => user, status: 200
    end

    def get_user_by_id(id, self_id)
        user = User.find_by_id(id)
        if user == nil
            return nil
        end
        photo = Photo.find_by_id(user.photo_id)
        answer = JSON.parse user.to_json(:only => [:email, :id, :about, :birthday, :chess_level, :current_city, :current_country, :fide_rating, :hobbies, :name, :surname, :online, :study_place])
        if id == self_id
            answer[:isFollowed] = false
        else
            answer[:isFollowed] = is_following(self_id, id)
        end
        answer[:photo] = photo.photo
        answer
    end

    def is_following(my_id, aim_id)
        flag = Follower.where(user_id: my_id)
        if flag == nil
            return false
        end
        # flag.where(following_id: my_id)
        flag = flag.find_by_following_id(aim_id)
        flag == nil ? false : true
    end
end
