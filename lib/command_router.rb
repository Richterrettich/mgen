require 'commands/resource'
require "commands/service"
require 'thor'

module CommandRouter
  include Util

  class Main < Thor

    register(Service, 'service', 'service [service_name]', 'Creates a new microservice.')
    register(Resource, 'resource', 'resource [resource_name]', 'Creates a new resource')

  end

end
