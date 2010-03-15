require 'vendor/plugins/blacklight/app/controllers/application_controller.rb'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

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

    #underscores are escaped w/ + signs, which are unescaped by rails to spaces
    def unescape_keys(attrs)
      h=Hash.new
      attrs.each do |k,v|
        h[k.gsub(/ /, '_')]=v

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
