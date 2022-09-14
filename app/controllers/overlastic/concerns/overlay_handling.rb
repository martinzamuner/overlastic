module Overlastic::Concerns::OverlayHandling
  extend ActiveSupport::Concern

  included do
    before_action :add_overlay_variant

    private

    def add_overlay_variant
      request.variant = :overlay if helpers.current_overlay_name.present?
    end

    def close_overlay(name = :last)
      name =
        case name
        when :all
          :overlay1
        when :last
          helpers.current_overlay_name
        else
          name
        end

      render close_overlay: name
    end

    def render(*args, &block)
      if request.variant.overlay?
        options = args.last || {}

        # Rendering with an error status should render inside the overlay
        error = Rack::Utils.status_code(options[:status]).in? 400..499

        # Initiator requests always render inside an overlay
        initiator = request.headers["Overlay-Initiator"]

        # By default, navigation inside the overlay will break out of it (_top)
        target = request.headers["Overlay-Target"]

        # Name of the overlay to be closed
        close_overlay = options[:close_overlay]

        if close_overlay
          super turbo_stream: turbo_stream.replace(close_overlay, html: helpers.overlastic_tag(id: close_overlay))
        elsif initiator || error || target != "_top"
          super turbo_stream: turbo_stream.replace(helpers.current_overlay_name, html: helpers.render_overlay { render_to_string(*args, &block) })
        else
          request.headers["Turbo-Frame"] = nil
          response.headers["Overlay-Visit"] = "1"

          super
        end
      else
        super
      end
    end
  end
end
