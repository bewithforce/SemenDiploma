class Api::DialogsController < ApplicationController
    def all
        token = cookies[:auth_token]
        user = User.find_by_token(token)
        dialogs = []
        UsersToDialog.where(user_id: user.id).each do |dialog_id|
            #dialog = Dialog.find_by_id(dialog_id).to_json(:only => [:id])
            UsersToDialog.where(dialog_id:dialog_id)
            dialogs.push(dialog)
        end

    end
end
