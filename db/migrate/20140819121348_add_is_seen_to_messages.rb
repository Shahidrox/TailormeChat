class AddIsSeenToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_seen, :integer, :default => 0
  end
end
