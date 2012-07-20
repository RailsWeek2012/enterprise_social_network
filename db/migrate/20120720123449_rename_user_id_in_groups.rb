class RenameUserIdInGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.rename :user_id, :leader_id
    end
  end
end
