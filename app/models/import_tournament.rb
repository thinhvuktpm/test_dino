class ImportTournament < ApplicationRecord
IMPORT_STATUSES = { running: 'Running', success: 'Success', fail: 'Fail' }.freeze

  enum import_status_id: {running: 0, success: 1, fail: 2}

  scope :running_scope, -> { order(import_status_id: :asc, finish_at: :desc) }

  validates :name_admin,:start_at,:import_status_id, presence: true
end
