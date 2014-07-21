class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :user_id
      t.string :shop_name
      t.string :message

      t.timestamps
    end
  end
end
