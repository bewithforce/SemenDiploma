class Api::CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
        news_id = params[:id]
        news = News.find_by_id(news_id)
        if news == nil
            render json: {}, status: 403
            return
        end

        comments = Comment.where(news_id: news_id)

        answer = []
        comments.each do |comment|
            record = JSON.parse comment.to_json(:only => [:id, :news_id, :author_id, :text])
            record[:time] = comment.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
            answer.push(record)
        end
        render :json => answer, status: 200
    end

    def add
        news_id = params[:id]
        news = Post.find_by_id(news_id)
        if news == nil
            render json: {}, status: 403
            return
        end

        token = cookies[:auth_token]
        user = User.find_by_token(token)
        if user == nil
            render json: {}, status: 403
            return
        end

        if params[:text] == nil
            render json: {}, status: 403
            return
        end

        comment = Comment.create(author_id: user.id, news_id: news_id, text: params[:post])
        answer = JSON.parse comment.to_json(:only => [:id, :news_id, :author_id, :text])
        answer[:time] = comment.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
        render :json => answer, status: 200
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
