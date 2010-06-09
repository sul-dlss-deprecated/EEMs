require 'vendor/plugins/blacklight/app/controllers/application_controller.rb'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :set_current_user
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
  def set_current_user
    unless Rails.env =~ /production/ 
      if params[:wau]
        logger.warn("Setting WEBAUTH_USER in dev mode!")
        request.env['WEBAUTH_USER']=params[:wau]
      end
    end
    session[:user_id]=request.env['WEBAUTH_USER'] unless request.env['WEBAUTH_USER'].blank?
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
  
end
