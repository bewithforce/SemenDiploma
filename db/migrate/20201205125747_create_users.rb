class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password, limit: 64
      t.string :name
      t.text :token
      t.bigint :photo_id
      t.date :birthday
      t.string :current_city
      t.string :study_place
      t.string :chess_level
      t.integer :fide_rating
      t.text :about
      t.text :hobbies
      t.boolean :online

      t.timestamps
    end
  end
end
