require 'vendor/plugins/blacklight/app/controllers/application_controller.rb'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :set_current_user
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
  
  # Creates an EemsUser and saves the user in the session
  # The user is created from the following environment variables set by the mod_webauthldap Apache module:
  # - <b>WEBAUTH_USER</b> - Sunetid id of the user
  # - <b>WEBAUTH_LDAP_DISPLAYNAME</b> - Display name
  #
  # == 'wau' Paramater to simulate WebAuth
  # When running in development mode without apache or webauth, you can set the necessary environment variables by
  # appending ?wau=somesunetid to your url string like http://localhost:3000/?wau=wmene
  #
  # == Using an Apache instance with WebAuth but no LDAP access
  # The lyberapps-dev environment uses the plain mod_webauth Apache module, without LDAP access.
  # When running in the 'ladev' environment, this filter will set the EemsUser.display_name to the sunetid of the authenticated user.
  # It will also set the WEBAUTH_LDAPPRIVGROUP environment variable so that the #authorized_user filter will pass
  def set_current_user
    unless Rails.env =~ /production/ 
      if params[:wau]
        logger.warn("Setting WEBAUTH_USER in dev mode!")
        request.env['WEBAUTH_USER']=params[:wau]
        request.env['WEBAUTH_LDAP_DISPLAYNAME']=params[:wau]
        request.env['WEBAUTH_LDAPPRIVGROUP'] = Sulair::AUTHORIZED_EEMS_PRIVGROUP
      end
    end
    unless request.env['WEBAUTH_USER'].blank?
      if(Rails.env =~ /ladev/)
        user_display_name = request.env['WEBAUTH_USER']
        request.env['WEBAUTH_LDAPPRIVGROUP'] = Sulair::AUTHORIZED_EEMS_PRIVGROUP
      else
        user_display_name = request.env['WEBAUTH_LDAP_DISPLAYNAME']
      end
      user = EemsUser.new(user_display_name, request.env['WEBAUTH_USER'])
      user.save_to_session(session)
    end
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private
    def require_fedora
      Fedora::Repository.register(FEDORA_URL,  session[:user])
      return true
    end
    def require_solr
      ActiveFedora::SolrService.register(SOLR_URL)
    end

    # underscores are escaped w/ + signs, which are unescaped by rails to spaces
    # html tags are escaped by converting < and > to &lt; and &gt;
    def unescape_keys(attrs)
      h=Hash.new
      attrs.each do |k,v|
        v = v.gsub(/</, '&lt;')
        v = v.gsub(/>/, '&gt;')
        h[k.gsub(/ /, '_')] = v
      end
      h
    end
    
    def escape_keys(attrs)
      h=Hash.new
      attrs.each do |k,v|
        h[k.gsub(/_/, '+')]=v
      end
      h
    end
    
    # if session[:user_id] was not set by the :set_current_user filter
    # then redirect to the /login path
    def user_required
      unless(EemsUser.user_webauthed?(session))
        ref = params[:referrer]
        ref = '/' unless(ref)
        redirect_to '/login' + '?referrer=' + ref
        return false
      end
      true
    end

    # The WEBAUTH_LDAPPRIVGROUP environment variable is set if the user is a member of the
    # privgroup specified by the WebauthLdapPrivgroup Apache directive
    def authorized_user
      if(request.env['WEBAUTH_LDAPPRIVGROUP'] =~ /#{Sulair::AUTHORIZED_EEMS_PRIVGROUP}/ )
        return true
      else
        render :status => 401, :partial => "eems/_error/not_authorized"        
        return false
      end
    end
  
end
