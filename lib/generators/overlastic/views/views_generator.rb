class Overlastic::ViewsGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../app/views/overlastic", __dir__)

  class_option :css, enum: %w[inline tailwind], default: "inline", desc: "Indicate the desired CSS style"

  def self.default_generator_root
    __dir__
  end

  def copy_view_files
    copy_file "#{options[:css]}/_dialog.html.erb", "app/views/overlays/_dialog.html.erb"
    copy_file "#{options[:css]}/_pane.html.erb", "app/views/overlays/_pane.html.erb"

    create_file "config/initializers/overlastic.rb", <<~RUBY
      Overlastic.configure do |config|
        config.dialog_overlay_view_path = "overlays/dialog"
        config.pane_overlay_view_path = "overlays/pane"
      end
    RUBY
  end
end
