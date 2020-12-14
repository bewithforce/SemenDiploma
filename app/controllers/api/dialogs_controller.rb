class Api::DialogsController < ApplicationController
    def all
        token = cookies[:auth_token]
        user = User.find_by_token(token)
        dialogs = []
        UsersToDialog.where(user_id: user.id).each do |dialog_id|
            last_message = Message.find_by_dialog_id(dialog_id)
            if last_message != nil
                dialog = JSON.parse Dialog.find_by_id(dialog_id).to_json(:only => [:id])
                another_user_id = UsersToDialog.where(dialog_id: dialog_id).reject { |c| c.user_id == user.id }[0]
                another_user = User.find_by_id(another_user_id)
                dialog[:another_user_id] = another_user.id
                dialog[:another_user_name] = another_user.name
                dialog[:another_user_surname] = another_user.surname
                photo = Photo.find_by_id(another_user.photo_id)
                dialog[:another_user_photo] = photo.photo
                dialog[:last_message] = last_message
                dialogs.push(dialog)
            end
        end
        render json: dialogs, status: 200
    end
end
