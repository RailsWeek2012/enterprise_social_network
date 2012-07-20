class GroupsUsers < ActiveRecord::Migration
  def up
    create_table :groups_users, :id => false do |t|
      t.references :group, :user
    end

    add_index :groups_users, [:group_id, :user_id]
  end

  def down
  end
end
