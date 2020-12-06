class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.bigint :post_id
      t.bigint :author_id
      t.text :text

      t.timestamps
    end
  end
end
