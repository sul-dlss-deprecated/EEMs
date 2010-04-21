
class LoginController < ApplicationController

  def new
  end
  
  #This method protected by webauth as configured in apache
  #We should only get here after a user has succesfully authenticated
  def webauth
    Rails.logger.info("Session user_id is: " << session[:user_id])
    redirect_to params[:referrer]
  end
end
