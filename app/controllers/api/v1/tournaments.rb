class API::V1::Tournaments < Grape::API
  include API::V1::Default
  resource :tournaments do
    desc 'import data'
    post :import do
      TournamentServices.import(params)
    end

    desc "get list tournaments"
    get	:search do
    	tournaments = Tournament.filter(params)
    	return {tournaments: tournaments}
    end
  end
end