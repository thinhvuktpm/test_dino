class API::V1::Players < Grape::API
  include API::V1::Default
  resource :players do
  	desc "info player"
  	get :infor_player do
  		player = Player.find_by(name: params[:player_name])
  		if player.nil?
  			{errors: "not found"}
  		else
  			{player: player}
  		end
  	end
  end
end