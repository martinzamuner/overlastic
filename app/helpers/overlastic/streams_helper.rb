module Overlastic::StreamsHelper
  def replace_overlay(target, content = nil, **rendering, &block)
    action :replaceOverlay, target, content, **rendering, &block
  end
end

Turbo::Streams::TagBuilder.prepend(Overlastic::StreamsHelper)
