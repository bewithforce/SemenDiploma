class ChatChannel < ApplicationCable::Channel

    def subscribed
        sender = User.find_by_id(params[:sender_id])
        receiver = User.find_by_id(params[:receiver_id])

        user_to_dialog = UsersToDialog.where(user_id: sender.id).reject do |x|
            another = UsersToDialog.where(dialog_id: x.dialog_id)
            another.reject { |c| c.user_id == sender.id }
            another.find_by_user_id(receiver.id) == nil
        end[0]

        dialog = Dialog.find_by_id(user_to_dialog.dialog_id)

        if dialog == nil
            dialog = Dialog.create
            UsersToDialog.create(user_id: sender.id, dialog_id: dialog.id)
            UsersToDialog.create(user_id: receiver.id, dialog_id: dialog.id)
        end

        messages = Message.where(dialog_id: dialog.id)
        answer = []
        if messages != nil
            messages.each do |x|
                answer.push(msg_to_transmit(x))
            end
        end

        result = { dialog_id: dialog.id, msg_history: answer }
        stream_from("dialog #{dialog.id}")
        transmit(result)
        #ActionCable.server.broadcast "dialog #{dialog.id}", json: result
    end

    def speak(data)
        message = Message.create(user_id: data["sender_id"], dialog_id: data["dialog_id"], text: data["text"])
        answer = msg_to_transmit(message)
        ActionCable.server.broadcast "dialog #{message.dialog_id}", json: answer
    end

    def unsubscribed

    end

    private

    def msg_to_transmit(msg)
        answer = JSON.parse msg.to_json(:only => [:user_id, :dialog_id, :text])
        user = User.find_by_id(msg.user_id)
        photo = Photo.find_by_id(user.photo_id)
        answer[:name] = user.name
        answer[:surname] = user.surname
        answer[:time] = msg.created_at.localtime.strftime('%a, %d %b %Y %k:%M')
        #answer[:photo] = photo.photo
        answer
    end
end
