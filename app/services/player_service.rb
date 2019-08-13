class PlayerService
	
	def seach_player
		
	end

	def create_player
		name_player = Tournament.pluck(:player_1) + Tournament.pluck(:player_2)
		name_player.uniq.each{|name| Player.find_or_initialize_by(name: name).save}
		update_scores
	end

	def update_scores
		list_player_draw_matches = Hash[Player.pluck(:name).map{|key| [key,0]}]
		list_player_lost_matches = Hash[Player.pluck(:name).map{|key| [key,0]}]
		list_player_won_matches = Hash[Player.pluck(:name).map{|key| [key,0]}]
		list_player_scores = Hash[Player.pluck(:name).map{|key| [key,0]}]
		Tournament.select(:player_1, :player_2, :score).each do |f|
			if f.score.include?(f.player_2) || f.score.include?(f.player_1)
				if f.score.include? f.player_2
					list_player_scores["#{f.player_1}"] = list_player_scores["#{f.player_1}"] + 3
					list_player_won_matches["#{f.player_1}"] = list_player_won_matches["#{f.player_1}"] +1
					list_player_lost_matches["#{f.player_2}"] = list_player_lost_matches["#{f.player_2}"] +1
				else
					list_player_scores["#{f.player_2}"] = list_player_scores["#{f.player_2}"] + 3
					list_player_won_matches["#{f.player_2}"] = list_player_won_matches["#{f.player_2}"] +1
					list_player_lost_matches["#{f.player_1}"] = list_player_lost_matches["#{f.player_1}"] +1
				end
			else
				if instance_eval(f.score).zero?
					list_player_scores["#{f.player_1}"] = list_player_scores["#{f.player_1}"] + 1
					list_player_scores["#{f.player_2}"] = list_player_scores["#{f.player_2}"] + 1
					list_player_draw_matches["#{f.player_1}"] = list_player_draw_matches["#{f.player_1}"] +1
					list_player_draw_matches["#{f.player_2}"] = list_player_draw_matches["#{f.player_2}"] +1
				elsif instance_eval(f.score) > 0
					list_player_scores["#{f.player_1}"] = list_player_scores["#{f.player_1}"] + 3
					list_player_won_matches["#{f.player_1}"] = list_player_won_matches["#{f.player_1}"] +1
					list_player_lost_matches["#{f.player_2}"] = list_player_lost_matches["#{f.player_2}"] +1
				else
					list_player_scores["#{f.player_2}"] = list_player_scores["#{f.player_2}"] + 3
					list_player_won_matches["#{f.player_2}"] = list_player_won_matches["#{f.player_2}"] +1
					list_player_lost_matches["#{f.player_1}"] = list_player_lost_matches["#{f.player_1}"] +1
				end
			end
		end
		list_player_scores.each do |key,value| 
			Player.find_by(name: key).update_attributes!(scores: value,
																			won_matches:list_player_won_matches[key],
																			lost_matches:list_player_lost_matches[key],
																			draw_matches: list_player_draw_matches[key])
		end
	end

	class << self
    def create_player
      new.create_player
    end
	end
end