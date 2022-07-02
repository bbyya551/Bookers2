class RemoveUserFromRooms < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :user, :reference
  end
end
