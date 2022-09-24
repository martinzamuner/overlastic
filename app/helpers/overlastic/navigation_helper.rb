module Overlastic::NavigationHelper
  def link_to_overlay(name = nil, options = nil, html_options = nil, &block)
    method_type = __callee__.to_s.delete_prefix("link_to_")
    method_type = nil if method_type == "overlay"

    if block_given?
      options ||= {}
      options = options.stringify_keys
      options["data"] ||= {}

      options["data"][:turbo_stream] = true

      overlay_name = options.delete("overlay")
      options["data"][:overlay_name] = overlay_name_from(overlay_name || overlay_name_from_overlastic_action(Overlastic.configuration.default_action))

      type = options.delete("overlay_type") || method_type
      options["data"][:overlay_type] = type if type.present?

      target = options.delete("overlay_target")
      options["data"][:overlay_target] = target if target.present?

      args = options.delete("overlay_args")
      options["data"][:overlay_args] = args.to_json if args.present?

      options["target"] = :_blank

      link_to(name, options, &block)
    else
      html_options ||= {}
      html_options = html_options.stringify_keys
      html_options["data"] ||= {}

      html_options["data"][:turbo_stream] = true

      overlay_name = html_options.delete("overlay")
      html_options["data"][:overlay_name] = overlay_name_from(overlay_name || overlay_name_from_overlastic_action(Overlastic.configuration.default_action))

      type = html_options.delete("overlay_type") || method_type
      html_options["data"][:overlay_type] = type if type.present?

      target = html_options.delete("overlay_target")
      html_options["data"][:overlay_target] = target if target.present?

      args = html_options.delete("overlay_args")
      html_options["data"][:overlay_args] = args.to_json if args.present?

      html_options["target"] = :_blank

      link_to(name, options, html_options, &block)
    end
  end

  Overlastic.configuration.overlay_types.each do |overlay_type|
    alias_method :"link_to_#{overlay_type}", :link_to_overlay
  end

  private

  def overlay_name_from_overlastic_action(action)
    case action
    when :stack
      overlay_name_from :next
    when :replace_last
      overlay_name_from :current
    when :replace_all
      overlay_name_from :first
    end
  end
end
