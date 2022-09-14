module Overlastic::OverlaysHelper
  def overlastic_tag
    if block_given?
      type = request.headers["Overlay-Type"]
      target = request.headers["Overlay-Target"] || Overlastic.configuration.default_target
      args = request.headers["Overlay-Args"]

      turbo_frame_tag current_overlay_name, data: { overlay_type: type, overlay_target: target, overlay_args: args } do
        yield

        concat turbo_frame_tag(next_overlay_name, data: { overlay_target: Overlastic.configuration.default_target })
      end
    else
      turbo_frame_tag :overlay1, data: { overlay_target: Overlastic.configuration.default_target }
    end
  end

  def current_overlay_name
    return unless request.headers["Turbo-Frame"].to_s.starts_with?("overlay")

    request.headers["Turbo-Frame"].to_sym
  end

  def next_overlay_name
    current_number = current_overlay_name.to_s.scan(/\d+/)&.first.to_i

    "overlay#{current_number + 1}".to_sym
  end

  def render_overlay(locals = {}, &block)
    string = capture(&block)
    type = request.headers["Overlay-Type"] || Overlastic.configuration.default_overlay
    args_header = request.headers["Overlay-Args"]
    overlay_args = JSON.parse(request.headers["Overlay-Args"]) if args_header.present?
    locals.merge! overlay_args.to_h.symbolize_keys

    render(Overlastic.configuration.public_send(:"#{type}_overlay_view_path"), locals) { string }
  end
end
