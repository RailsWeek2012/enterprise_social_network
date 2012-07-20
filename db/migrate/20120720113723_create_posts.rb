class CreatePosts < ActiveRecord::Migration
  def change
    drop_table :posts
    create_table :posts do |t|
      t.string :message
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
