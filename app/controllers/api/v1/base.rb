module API::V1
  class Base < Grape::API
  	mount API::V1::Tournaments
  	mount API::V1::Players
  end
end