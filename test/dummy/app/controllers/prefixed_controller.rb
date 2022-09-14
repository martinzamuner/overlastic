class PrefixedController < ApplicationController
  before_action { prepend_view_path "#{Rails.root}/app/views/#{controller_prefix}" }

  helper_method :controller_prefix

  private

  def controller_prefix
    request.path.split("/").second.to_sym
  end
end
