require "test_helper"

class Overlastic::ConfigurationTest < ActiveSupport::TestCase
  test "defines dialog & pane as default overlay types" do
    assert_equal %i[dialog pane], Overlastic.configuration.overlay_types
  end

  test "defines dialog as the default overlay type" do
    assert_equal :dialog, Overlastic.configuration.default_overlay
  end

  test "defines stack as the default overlay action" do
    assert_equal :stack, Overlastic.configuration.default_action
  end

  test "configuring new overlay types removes view path setters and defines new ones" do
    save_configuration

    assert_equal "shared/overlays/dialog", Overlastic.configuration.dialog_overlay_view_path
    assert_raise(Exception) { Overlastic.configuration.test_overlay_view_path }

    Overlastic.configure do |config|
      config.overlay_types = %i[pane test]
    end

    assert_raise(Exception) { Overlastic.configuration.dialog_overlay_view_path }
    assert_equal "shared/overlays/test", Overlastic.configuration.test_overlay_view_path

    restore_configuration
  end

  private

  def save_configuration
    @previous_config = Overlastic.configuration.overlay_types
  end

  def restore_configuration
    Overlastic.configure do |config|
      config.overlay_types = @previous_config
    end
  end
end
