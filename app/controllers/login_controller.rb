
class LoginController < ApplicationController

  def new
    session[:referrer] = params[:referrer]
  end
  
  #This method protected by webauth as configured in apache
  #We should only get here after a user has succesfully authenticated
  def webauth
    redirect_to session[:referrer]
  end
end