class DashboardController < ApplicationController
  def index; end

  def help
    render overlay: :first, overlay_type: params[:overlay_type] || :dialog
  end
end
