class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.bigint :owner_id
      t.bigint :author_id
      t.text :text
      # t.bigint :photo_id

      t.timestamps
    end
  end
end
