class AddPositionToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :position, :integer, default: 0
  end
end
