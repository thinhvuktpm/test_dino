module API::V1::Default extend ActiveSupport::Concern
  included do
    # config api
    prefix "api"
    version "v1", using: :path
    default_format :json
    format :json
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end
    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.message, status: 422)
    end
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!(e, 400)
    end
  end

end
