module Overlastic::Concerns::OverlayHandling
  extend ActiveSupport::Concern

  included do
    before_action :add_overlay_variant

    private

    def add_overlay_variant
      request.variant = :overlay if helpers.current_overlay_name.present?
    end

    def close_overlay(key = :last)
      overlay_name = helpers.overlay_name_from key

      render overlay: overlay_name, html: helpers.overlastic_tag(id: helpers.current_overlay_name)
    end

    def render(*args, &block)
      options = args.last || {}

      # Force render of overlays without an initiator
      request.headers["Overlay-Target"] ||= options.delete(:overlay_target)
      request.headers["Overlay-Type"] ||= options.delete(:overlay_type)
      request.headers["Overlay-Args"] ||= options.delete(:overlay_args)&.to_json

      # Force visit to the desired redirection location
      response.headers["Overlay-Visit"] ||= options.delete(:redirect)

      # Rendering with an error status should render inside the overlay
      error = Rack::Utils.status_code(options[:status]).in? 400..499

      # No enhancements should be made unless the client is using Turbo
      overlastic_enabled = request.headers["Overlay-Enabled"]

      # Initiator requests always render inside an overlay
      initiator = request.headers["Overlay-Initiator"]

      # By default, navigation inside the overlay will break out of it (_top)
      target = request.headers["Overlay-Target"]

      # Name of the overlay to be used
      overlay = options.delete :overlay
      overlay_name = helpers.overlay_name_from(overlay || helpers.current_overlay_name)

      if overlay && overlastic_enabled
        options[:layout] = false

        if block_given? || options[:html]
          super turbo_stream: turbo_stream.replace(overlay_name, html: render_to_string(*args, &block))
        else
          super turbo_stream: turbo_stream.replace(overlay_name, html: helpers.render_overlay { render_to_string(*args, &block) })
        end
      elsif request.variant.overlay?
        if initiator || error || target != "_top"
          super turbo_stream: turbo_stream.replace(overlay_name, html: helpers.render_overlay { render_to_string(*args, &block) })
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
      location = url_for options
      overlay = response_options.delete :overlay
      overlay_name = helpers.overlay_name_from overlay

      if request.variant.overlay?
        if overlay_name.present?
          unless helpers.valid_overlay_name? overlay_name
            return render overlay: helpers.current_overlay_name, redirect: location, html: helpers.overlastic_tag(id: helpers.current_overlay_name)
          end

          request.variant.delete :overlay
          flash.merge! response_options.fetch :flash, {}

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
