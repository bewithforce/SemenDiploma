class Api::DialogsController < ApplicationController
    def all
        token = cookies[:auth_token]
        user = User.find_by_token(token)
        dialogs = []
        UsersToDialog.where(user_id: user.id).each do |dialog_id|
            dialog = JSON.parse Dialog.find_by_id(dialog_id).to_json(:only => [:id])
            another_user_id = UsersToDialog.where(dialog_id: dialog_id).reject { |c| c.user_id == user.id }[0]
            another_user = User.find_by_id(another_user_id)
            dialog[:another_user_id] = another_user.id
            dialog[:another_user_name] = another_user.name
            dialog[:another_user_surname] = another_user.surname
            photo = Photo.find_by_id(another_user.photo_id)
            dialog[:another_user_photo] = photo.photo
            dialog[:last_message] =
              dialogs.push(dialog)
        end
        render json: dialogs, status: 200
    end

    def add
        dialog = Dialog.create
        render json: { dialog_id: dialog.id }, status: 200
    end

    def remove
        #dialog_id =
    end
end
