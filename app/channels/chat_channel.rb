class ChatChannel < ApplicationCable::Channel

    def subscribed
        sender = User.find_by_id(params[:sender_id])
        receiver = User.find_by_id(params[:receiver_id])

        dialog = UsersToDialog.where(user_id: sender.id).reject do |x|
            another = UsersToDialog.where(dialog_id: x.dialog_id)
            another.reject { |c| c.user_id == sender.id }
            another.find_by_user_id(receiver.id)
        end[0]

        if dialog == nil
            dialog = Dialog.create
            UsersToDialog.create(user_id: sender.id, dialog_id: dialog.id)
            UsersToDialog.create(user_id: receiver.id, dialog_id: dialog.id)
        end

        messages = Message.where(dialog_id: dialog.id)
        answer = []
        if messages != nil
            messages.each do |x|
                answer.push JSON.parse x.to_json(:only => [:user_id, :dialog_id, :text])
            end
        end
        stream_from("dialog #{dialog}")
        ActionCable.server.broadcast "dialog #{dialog}", json: answer
    end

    def speak(data)
        message = Message.create(user_id: data["sender_id"], dialog_id: data["dialog_id"], text: data["text"])
        answer = JSON.parse message.to_json(:only => [:user_id, :dialog_id, :text])
        ActionCable.server.broadcast "dialog #{message.dialog_id}", json: answer
    end
end
