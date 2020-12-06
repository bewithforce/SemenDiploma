class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers, id: false do |t|
      t.bigint :user_id
      t.bigint :following_id

      t.timestamps
    end
  end
end
