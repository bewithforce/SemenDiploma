class CreateUsersToDialogs < ActiveRecord::Migration[6.0]
  def change
    create_table :users_to_dialogs, id:false do |t|
      t.bigint :user_id
      t.bigint :dialog_id

      t.timestamps
    end
  end
end
