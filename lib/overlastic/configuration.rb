module Overlastic
  class Configuration
    attr_accessor :overlay_types, :default_overlay, :default_action, :default_target

    def initialize
      self.overlay_types = %i[dialog pane]
      self.default_overlay = :dialog
      self.default_action = :stack
      self.default_target = :_top
    end

    def overlay_types=(types)
      overlay_types&.each do |overlay_type|
        undef :"#{overlay_type}_overlay_view_path"
        undef :"#{overlay_type}_overlay_view_path="
      end

      @overlay_types = types

      overlay_types.each do |overlay_type|
        self.class.attr_accessor :"#{overlay_type}_overlay_view_path"

        public_send :"#{overlay_type}_overlay_view_path=", "overlastic/inline/#{overlay_type}"
      end
    end
  end
end
