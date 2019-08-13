class Tournament < ApplicationRecord
	validates :group,:player_1,:player_2,:match_time,:venue,:score, presence: true
	validates :match_code, uniqueness: true
	def self.filter(args={})
	  tournaments = all
    tournaments = tournaments.where("LOWER(tournaments.match_code) iLIKE :key", key: "%#{args[:match_code]}%") if args[:match_code].present?
    tournaments = tournaments.where("LOWER(tournaments.player_1) iLIKE :key", key: "%#{args[:player_name]}%").or(tournaments.where("LOWER(tournaments.player_2) iLIKE :key", key: "%#{args[:player_name]}%")) if args[:player_name].present?
    tournaments
	end
end
