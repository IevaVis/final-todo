class AddAvatarsToTodos < ActiveRecord::Migration[5.1]
  def change
    add_column :todos, :avatars, :json
  end
end
