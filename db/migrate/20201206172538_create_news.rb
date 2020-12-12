class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.bigint :photo_id
      t.text :text
      t.text :tags
      t.text :title
      t.text :summary

      t.timestamps
    end
  end
end
