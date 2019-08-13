class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
    	t.string :group
    	t.string :match_code	
    	t.string :player_1
    	t.string :player_2
    	t.datetime :match_time
    	t.string :venue
    	t.string :score
      t.timestamps
    end
    add_index :tournaments, :match_code
  end
end
