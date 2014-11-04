require "net/http"
require "json"
require "uri"

module RiakCSHelper
  module CreateUser
    USER_RESOURCE_PATH = "riak-cs/user"

    def self.create_riakcs_user(name, email, fqdn, port)
      Chef::Log.info "Creating RiakCS user..."
      uri = URI.parse("http://#{fqdn}:#{port}/#{USER_RESOURCE_PATH}")
      request = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
      request.body  = {
        "email" => email,
        "name"  => name
      }.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      response = http.start do |h|
        h.request(request)
      end
      json = JSON.parse(response.body)

      [ json["key_id"], json["key_secret"] ]

    rescue => e
      Chef::Log.warn "Error occurred trying to create admin user: #{e.inspect}"
      raise e
    end

  end
end
