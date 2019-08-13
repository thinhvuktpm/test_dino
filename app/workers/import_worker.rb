class ImportWorker
  include Sidekiq::Worker

  def perform(name_admin)
  	import_tourmament_services.write_log_import(name_admin)
    import_tourmament_services.import(name_admin)
  rescue => ex
  	write_log_import(name_admin, "fail")  
  end

  private

  def import_tourmament_services
    @import_tourmament_services ||= ImportTournamentServices.new
  end
end