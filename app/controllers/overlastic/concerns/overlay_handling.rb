module Overlastic::Concerns::OverlayHandling
  extend ActiveSupport::Concern

  included do
    before_action :add_overlay_variant

    private

    def add_overlay_variant
      request.variant = :overlay if helpers.current_overlay_name.present?
    end

    def render(*args, &block)
      if request.variant.overlay?
        super html: helpers.render_overlay { render_to_string(*args, &block) }
      else
        super
      end
    end
  end
end
