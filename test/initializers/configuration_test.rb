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

  test "defines stack as the default overlay target" do
    assert_equal :_top, Overlastic.configuration.default_target
  end

  test "configuring new overlay types removes view path setters and defines new ones" do
    assert_equal "overlastic/inline/dialog", Overlastic.configuration.dialog_overlay_view_path
    assert_raise(Exception) { Overlastic.configuration.test_overlay_view_path }

    Overlastic.configure do |config|
      config.overlay_types = %i[pane test]
    end

    assert_raise(Exception) { Overlastic.configuration.dialog_overlay_view_path }
    assert_equal "overlastic/inline/test", Overlastic.configuration.test_overlay_view_path

    restore_configuration
  end

  test "configuring append_turbo_stream saves the passed block and returns it later" do
    Overlastic.configure do |config|
      config.append_turbo_stream do
        :test
      end
    end

    assert_equal Overlastic.configuration.append_turbo_stream.call, :test

    restore_configuration
  end

  private

  def restore_configuration
    Overlastic.remove_instance_variable :@configuration
    load "test/dummy/config/initializers/overlastic.rb"
  end
end
