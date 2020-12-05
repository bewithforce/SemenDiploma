class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.bigint :dialog_id
      t.bigint :user_id
      t.text :text

      t.timestamps
    end
  end
end
