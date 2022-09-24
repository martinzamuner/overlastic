require "rails/engine"
require "turbo-rails"

module Overlastic
  class Engine < Rails::Engine
    isolate_namespace Overlastic

    config.eager_load_namespaces << Overlastic
    config.autoload_once_paths = %W(
      #{root}/app/controllers
      #{root}/app/controllers/concerns
      #{root}/app/helpers
    )

    initializer "overlastic.assets" do
      if Rails.application.config.respond_to?(:assets)
        Rails.application.config.assets.precompile += %w[overlastic.min.js]
      end
    end

    initializer "overlastic.helpers", before: :load_config_initializers do
      ActiveSupport.on_load(:action_controller_base) do
        include Overlastic::Concerns::OverlayHandling

        helper Overlastic::Engine.helpers
      end
    end
  end
end
