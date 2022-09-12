# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

class ActionView::TestCase
  include Turbo::FramesHelper

  def request
    OpenStruct.new(headers: { "Turbo-Frame" => "overlay32" })
  end
end
