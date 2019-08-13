class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :scores, default: 0
      t.integer :won_matches, default: 0
      t.integer :lost_matches, default: 0
      t.integer :draw_matches, default: 0
      
      t.timestamps
    end
  end
end
