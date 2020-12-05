class Api::AuthController < ApplicationController
    def login

    end

    def me
        cookie = cookies[]
        flag = false
        user = User.select { |t|
            begin
                if t.last_cookie == cookie
                    flag = true
                end
            end
        }
        if flag
            render response_code: 200
        else
            render response_code: 403
        end
    end

    def register
        email = params['email']
        regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        if !email =~ regex

        end
    end

    def logout

    end
end
