class AddStatusToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :status, :integer, default: 0
  end
end
