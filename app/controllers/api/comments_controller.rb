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
            answer.push(comment_to_json(comment))
        end

        answer.sort do |a, b|
            Date.parse(a[:time]) <=> Date.parse(b[:time])
        end
        render :json => answer, status: 200
    end

    def add
        news_id = params[:id]
        news = News.find_by_id(news_id)
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

        comment = Comment.create(author_id: user.id, news_id: news_id, text: params[:text])
        answer = comment_to_json(comment)

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

    def comment_to_json(comment)
        answer = JSON.parse comment.to_json(:only => [:id, :news_id, :author_id, :text])
        answer[:time] = comment.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
        author = User.find_by_id(comment.author_id)
        answer[:name] = author.name
        answer[:surname] = author.surname

        photo = Photo.find_by_id(author.photo_id)
        answer[:photo] = photo.photo
        answer
    end
end
