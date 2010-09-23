
class LoginController < ApplicationController

  def new
    # Automatically redirect requrests to the /login/webauth path if the referrer == '/'
    # This means the request came from the home page, and we do not want to render the login/new.erb vie
    if(params[:referrer] == '/')
      redirect_to "/login/webauth/?referrer=/"
    end
  end
  
  #This method protected by webauth as configured in apache
  #We should only get here after a user has succesfully authenticated
  def webauth
    Rails.logger.info("Session user_id is: " << session[:user_id])
    redirect_to params[:referrer]
  end
end
