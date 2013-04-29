class ApplicationController < ActionController::Base
  protect_from_forgery


  def get_order(params)
    unless params[:directed_by].blank? || params[:sort_by].blank? || params[:directed_by] == "none"
      "#{params[:sort_by]} #{params[:directed_by].upcase}"
    else
      nil
    end
  end

protected

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    else
      "application"
    end
  end

  def path_to_url(path)
    request.protocol + request.host_with_port + path
  end

  def authenticate_user_or_admin!
    unless user_signed_in? || admin_signed_in?
      flash[:alert] = I18n.t("devise.failure.unauthenticated")
      redirect_to new_user_session_path
    end
  end

end
