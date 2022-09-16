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

        # Force visit to the desired redirection location
        redirect = options[:redirect]

        # Name of the overlay to be closed
        close_overlay = options[:close_overlay]

        if redirect
          response.headers["Overlay-Visit"] = redirect

          super turbo_stream: turbo_stream.replace(helpers.current_overlay_name, html: helpers.overlastic_tag(id: close_overlay))
        elsif close_overlay
          super turbo_stream: turbo_stream.replace(close_overlay, html: helpers.overlastic_tag(id: close_overlay))
        elsif initiator || error || target != "_top"
          super turbo_stream: turbo_stream.replace(helpers.current_overlay_name, html: helpers.render_overlay { render_to_string(*args, &block) })
        else
          request.headers["Turbo-Frame"] = nil
          response.headers["Overlay-Visit"] = request.fullpath

          super
        end
      else
        super
      end
    end

    # Based on https://github.com/hotwired/turbo-rails/pull/367
    # by seanpdoyle
    def redirect_to(options = {}, response_options = {})
      location = url_for(options)
      overlay = response_options.delete(:overlay)
      overlay_name =
        case overlay
        when :current
          helpers.current_overlay_name
        when :previous
          current_number = helpers.current_overlay_name.to_s.scan(/\d+/)&.first.to_i

          "overlay#{current_number - 1}"
        else
          overlay
        end

      if request.variant.overlay?
        if overlay_name.present?
          unless helpers.valid_overlay_name? overlay_name
            return render redirect: location
          end

          request.variant.delete(:overlay)
          flash.merge! response_options.fetch(:flash, {})

          case Rack::Utils.status_code(response_options.fetch(:status, :created))
          when 300..399 then response_options[:status] = :created
          end

          render "overlastic/streams/redirect", response_options.with_defaults(
            locals: { location: location, overlay: overlay_name }
          )
        else
          super
        end
      else
        super
      end
    end
  end
end
