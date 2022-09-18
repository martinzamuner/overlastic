# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

class ActionView::TestCase
  def request
    OpenStruct.new(headers: { "Overlay-Name" => "overlay32" })
  end
end
