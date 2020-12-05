class CreateDialogs < ActiveRecord::Migration[6.0]
  def change
    create_table :dialogs do |t|

      t.timestamps
    end
  end
end
