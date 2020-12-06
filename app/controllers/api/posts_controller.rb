class Api::PostsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show_user
        user_id = params[:id]
        user = User.find_by_id(user_id)
        if user == nil
            render json: {}, status: 403
            return
        end
        posts = Post.where(owner_id: user.id)
        answer = []
        posts.each do |post|
            post_json = post.to_json(:only => [:author_id, :owner_id, :text, :created_at])
=begin
            if post.photo_id != 0
                photo = Photo.find_by_id(post.photo_id)
                post_json[:photo] = photo.photo
            end
=end
            answer.push(post_json)
        end

        render :json => answer, status: 200
    end

    def index
        post_id = params[:id]
        post = Post.find_by_id(post_id)
        if post == nil
            render json: {}, status: 403
            return
        end
=begin
        if post.photo_id != 0
            photo = Photo.find(post.photo_id)
            answer = JSON.parse post.to_json(:only => [:author_id, :owner_id, :text, :created_at])
            answer[:photo] = photo.photo
            render :json => answer, status: 200
        else
            render :json => post.to_json(:only => [:author_id, :owner_id, :text]), status: 200
        end
=end
        render :json => post.to_json(:only => [:id, :author_id, :text]), status: 200
    end

    def add
        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end
=begin
        photo_id = 1
        if params[:photo] != nil
            file = params[:photo]
            content = File.binread(file)
            encoded = Base64.encode64(content)
            photo_id = Photo.create(photo: encoded).id
        end
=end
        Post.create(
          author_id: user.id,
          owner_id: params[:id],
          # photo_id: photo_id,
          text: params[:text]
        )
        render json: {}, status: 200
    end

    def delete
        post_id = params[:id]
        post = Post.find_by_id(post_id)
        if post == nil
            render json: {}, status: 403
            return
        end

        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end

        if post.owner_id != user.id
            render json: {}, status: 403
            return
        end

        post.delete
        render json: {}, status: 200
    end
end
