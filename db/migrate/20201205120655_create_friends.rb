class CreateFriends < ActiveRecord::Migration[6.0]
    def change
        create_table :friends, id: false do |t|
            t.bigint :user1_id
            t.bigint :user2_id

            t.timestamps
        end
    end
end
