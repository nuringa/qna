class ApplicationController < ActionController::Base
  before_action :set_gon_params

  private
  def set_gon_params
    gon.params = params.permit(:id)
    gon.user_id = current_user&.id
  end
end
