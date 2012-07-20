class DropTableGroups < ActiveRecord::Migration
  def up
    drop_table :groups
  end

  def down
  end
end
