class AddPrimaryToGroupsUsers < ActiveRecord::Migration
  def change
    remove_column :groups_users, :id
    add_column :groups_users, :id, :primary_key
  end
end
