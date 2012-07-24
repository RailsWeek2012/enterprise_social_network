class AddCompanyIdToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :company_id, :integer
  end
end
