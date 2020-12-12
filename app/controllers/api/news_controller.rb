require 'json'

class Api::NewsController < ApplicationController
    def show
        id = params[:id]
        answer = get_news_by_id(id)
        if answer == nil
            render json: {}, status: 403
            return
        end
        render json: answer, status: 200
    end

    def all
        news = News.all
        if news == nil
            render json: {}, status: 403
            return
        end

        answer = []
        news.each do |record|
            photo = Photo.find_by_id(record.photo_id).photo
            record_json = JSON.parse record.to_json(:only => [:id, :tag, :title, :summary, :text])
            record_json[:time] = record.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
            record_json[:photo] = photo
            answer.push(record_json)
        end
        render json: answer, status: 200
    end

    def get_news_by_id(id)
        news = News.find_by_id(id)
        if news == nil
            return nil
        end
        photo = Photo.find_by_id(news.photo_id).photo
        answer = JSON.parse news.to_json(:only => [:id, :tag, :title, :summary, :text])
        answer[:time] = news.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
        answer[:photo] = photo
        answer
    end
end
