class AddIdToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :id, :integer, primary_key: true
  end
end
