module ApplicationCable
    class Connection < ActionCable::Connection::Base

        def connect
        end

        private

        def find_verified_user
            if (verified_user = User.find_by_token(cookies[:auth_token]))
                verified_user
            else
                reject_unauthorized_connection
            end
        end
    end
end
