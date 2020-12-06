class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.bigint :photo_id
      t.text :text

      t.timestamps
    end
  end
end
