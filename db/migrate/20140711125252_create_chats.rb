class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.text :reply
      t.integer :user_id_fk, :references => "user"
      t.integer :message_id_fk, :references => "message"

      t.timestamps
    end
  end
end
