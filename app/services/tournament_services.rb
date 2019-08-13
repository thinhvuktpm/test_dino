class TournamentServices
	def import(params)
		import_log = ImportTournament.find_by(import_status_id: ImportTournament.import_status_ids[:running])
		if import_log.nil?
			ImportWorker.perform_async(params[:admin])
			return {status: "system is running" }
		else
			return {status: "The system is importing another file, please come back later!" }
		end
	end
	class << self
    def import(params)
      new.import(params)
    end
	end
end