class CreateImportTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :import_tournaments do |t|

    	t.string :name_admin
    	t.datetime :finish_at
    	t.datetime :start_at
    	t.integer :import_status_id
	    t.timestamps
    end
  end
end
