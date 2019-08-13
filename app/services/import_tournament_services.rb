require 'net/ftp'
require 'csv'
class ImportTournamentServices

  def write_log_import(name_admin, import_status_id = nil)
    import_log = ImportTournament.find_by(import_status_id: ImportTournament.import_status_ids[:running])
    if import_log.nil?
      ImportTournament.create(name_admin: name_admin, start_at: Time.current, import_status_id: ImportTournament.import_status_ids[:running])
    else
      import_log.update_attributes(finish_at: Time.current, import_status_id: import_status_id)
    end
  end

  def import (name_admin)
    @admin = name_admin
    download_file_data_ftp
    d = Dir.new(@folder_path)
    csvs = d.entries.select {|e| /^.+\.csv$/.match(e)}
    errors = {}
    csvs.each do |f|
      line_errors = []
      path = "#{@folder_path}/#{f}"
      CSV.foreach(File.join(path), headers: true) do |row|
        tournament = row.to_hash if row.to_hash["match code"]
        next if tournament.nil?
        check_record = check_tournament(tournament)
        unless check_record
          line_errors.push($.)
        end
        next unless check_record
        Tournament.find_or_initialize_by( match_code: "#{f.delete('.csv')} #{tournament["match code"]}").
                      update_attributes!( group: tournament["group"],
                                          player_1: tournament["player 1"],
                                          player_2: tournament["player 2"],
                                          match_time: "#{tournament["time"]} #{tournament["date"]}".to_datetime,
                                          venue: tournament["venue"],
                                          score: tournament["score"])
      end
      errors.merge!(:"#{f}" => line_errors)
    end
    if errors.each_value.any?{|f| !f.blank?}
      write_log_import(name_admin, "fail")  
    else
      write_log_import(name_admin, "success")
    end
    PlayerService.create_player
  end

  def check_tournament(tournament)
    record = Tournament.new
    record.assign_attributes(group: tournament["group"],
                              player_1: tournament["player 1"],
                              player_2: tournament["player 2"],
                              match_time: "#{tournament["time"]} #{tournament["date"]}".to_datetime,
                              venue: tournament["venue"],
                              score: tournament["score"])
    record.valid?
  end
  def download_file_data_ftp
    ftp_config = get_config_yaml("config/import/ftp/settings.yml")
    download_conf = ftp_config[:download]
    ftp_conf = ftp_config[:download][:ftp]
    ftp = Net::FTP.new(
      ftp_conf[:host],
      ftp_conf[:username],
      ftp_conf[:password]
    )
    ftp.binary = true
    ftp.passive = true
    ftp.chdir(ftp_conf[:dir])
    files = ftp.nlst("*.csv")
    exclude = /\.old|temp/ 
    files = files.reject{ |e| exclude.match e }
    @folder_path = Rails.root + "public/system/data_import_#{Time.now.to_i}"
    FileUtils.mkdir_p(@folder_path)
    files.each do |name|
      begin
        path = @folder_path + "#{name.squish.downcase.tr(" ","_")}"
        File.new(path, "w")
        ftp.getbinaryfile(name, path)
      rescue Net::FTPPermError
        write_log_import(@admin, "fail")  
        next
      end
    end
  ensure
    ftp.close if ftp.present?
  end

  def get_config_yaml(path)
    file = File.join(Rails.root, path)
    YAML.load_file(file).deep_symbolize_keys
  end
end