require "overlastic/engine"
require "overlastic/configuration"

module Overlastic
  extend ActiveSupport::Autoload

  class << self
    def configuration
      @configuration ||= Overlastic::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
