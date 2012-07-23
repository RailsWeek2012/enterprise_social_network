class AddParentIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_id, :integer
  end
end
