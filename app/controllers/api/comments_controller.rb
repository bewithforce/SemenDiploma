class Api::CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
        post_id = params[:id]
        post = Post.find_by_id(post_id)
        if post == nil
            render json: {}, status: 403
            return
        end

        comments = Comment.where(post_id: post_id)

        answer = []
        comments.each do |comment|
            answer.push(comment.to_json(:only => [:id, :author_id, :text, :created_at]))
        end
        render :json => answer, status: 200
    end

    def add
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

        if params[:text] == nil
            render json: {}, status: 403
            return
        end

        Comment.create(author_id: user.id, post_id: post_id, text: params[:post])
        render json: {}, status: 200
    end

    def delete
        comment_id = params[:id]
        comment = Comment.find_by_id(comment_id)
        if comment == nil
            render json: {}, status: 403
            return
        end

        cookie = cookies[:auth_token]
        user = User.find_by_token(cookie)
        if user == nil
            render json: {}, status: 403
            return
        end

        if comment.author_id != user.id
            render json: {}, status: 403
            return
        end
        comment.delete
    end
end
