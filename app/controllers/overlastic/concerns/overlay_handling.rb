module Overlastic::Concerns::OverlayHandling
  extend ActiveSupport::Concern

  included do
    before_action :add_overlay_variant

    private

    def add_overlay_variant
      request.variant = :overlay if helpers.current_overlay_name.present?
    end

    def close_overlay(key = :last, **options)
      overlay_name = helpers.overlay_name_from(key) || :overlay1

      # In case a Turbo Stream is appended which renders new overlay links, they should be generated
      # relative to the foremost overlay still open after closing the requested overlays.
      request.headers["Overlay-Name"] = :"overlay#{helpers.overlay_number_from(overlay_name) - 1}"

      options.filter { |key, _| key.in? self.class._flash_types }.each { |key, value| flash.now[key] = value }

      if block_given?
        render overlay: overlay_name, html: helpers.overlastic_tag(id: overlay_name), append_turbo_stream: yield
      else
        render overlay: overlay_name, html: helpers.overlastic_tag(id: overlay_name)
      end
    end

    def render(*args, **options, &block)
      # Force render of overlays without an initiator
      request.headers["Overlay-Target"] ||= options.delete(:overlay_target)
      request.headers["Overlay-Type"] ||= options.delete(:overlay_type)
      request.headers["Overlay-Args"] ||= Base64.urlsafe_encode64(options.delete(:overlay_args).to_json) if options.key?(:overlay_args)

      # If renderable content other than HTML is passed we should avoid returning a stream
      avoid_stream = _renderers.excluding(:html).intersection(options.keys).present?

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

      if overlay.present?
        request.headers["Overlay-Name"] = overlay_name
      end

      if overlastic_enabled
        if overlay
          options[:layout] = false

          if block_given? || options[:html]
            stream_response = turbo_stream.replace_overlay(overlay_name, html: render_to_string(*args, **options, &block))
          else
            stream_response = turbo_stream.replace_overlay(overlay_name, html: helpers.render_overlay { render_to_string(*args, **options, &block) })
          end
        elsif request.variant.overlay?
          if initiator || error || target != "_top"
            options[:layout] = false

            stream_response = turbo_stream.replace_overlay(overlay_name, html: helpers.render_overlay { render_to_string(*args, **options, &block) })
          else
            request.headers["Overlay-Name"] = nil
            request.variant.delete :overlay
          end
        end
      end

      if stream_response && !avoid_stream
        super turbo_stream: [
          stream_response,
          *options[:append_turbo_stream],
          *(instance_eval(&Overlastic.configuration.append_turbo_stream) if Overlastic.configuration.append_turbo_stream)
        ]
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
          request.variant.delete :overlay
          flash.merge! response_options.filter { |key, _| key.in? self.class._flash_types }

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
