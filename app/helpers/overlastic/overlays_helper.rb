module Overlastic::OverlaysHelper
  def overlastic_tag(id: :overlay1)
    if block_given?
      type = request.headers["Overlay-Type"]
      target = request.headers["Overlay-Target"] || Overlastic.configuration.default_target
      args = request.headers["Overlay-Args"]

      tag.overlastic id: current_overlay_name || id, src: request.url, data: { overlay_type: type, overlay_target: target, overlay_args: args } do
        yield

        concat tag.overlastic(id: overlay_name_from(:next), data: { overlay_target: Overlastic.configuration.default_target })
      end
    else
      tag.overlastic id: id, data: { overlay_target: Overlastic.configuration.default_target }
    end
  end

  def current_overlay_name
    request.headers["Overlay-Name"]&.to_sym
  end

  def overlay_number_from(name)
    name.to_s.scan(/\d+/)&.first.to_i
  end

  def overlay_name_from(key)
    current_number = overlay_number_from current_overlay_name

    case key
    when :first, :all
      :overlay1
    when :last, :current
      current_overlay_name
    when :previous
      :"overlay#{current_number - 1}"
    when :next
      :"overlay#{current_number + 1}"
    else
      key
    end
  end

  def valid_overlay_name?(name)
    overlay_number_from(name).positive?
  end

  def render_overlay(locals = {}, &block)
    string = capture(&block)
    type = request.headers["Overlay-Type"] || Overlastic.configuration.default_overlay
    args_header = request.headers["Overlay-Args"]
    overlay_args = JSON.parse(Base64.urlsafe_decode64(request.headers["Overlay-Args"])) if args_header.present?
    locals.merge! overlay_args.to_h.symbolize_keys

    overlastic_tag do
      concat render(Overlastic.configuration.public_send(:"#{type}_overlay_view_path"), locals) { string }
    end
  end
end
