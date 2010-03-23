

require 'fedora/base'
require 'fedora/repository'
require 'net/http'
require 'net/https'

class Fedora::Datastream < Fedora::BaseObject
  def versionable
    @attributes[:versionable]
  end
  
  def versionable=(new_val)
    @attributes[:versionable]=new_val
  end
  
end

module ActiveFedora
  class Base
    def delete
      Fedora::Repository.instance.delete(@inner_object)
      SolrService.instance.conn.delete(self.pid) if ENABLE_SOLR_UPDATES
    end
  end
  
  class MetadataDatastream < Datastream

    #constructor, calls up to ActiveFedora::Datastream's constructor
    def initialize(attrs=nil)
      super
      @fields={}
      self.versionable = false
    end
    
  end
    
end

module Fedora
  class Connection
    def http
      http             = Net::HTTP.new(@site.host, @site.port)
      if(@site.is_a?(URI::HTTPS))
        http.use_ssl     = true
        http.cert = OpenSSL::X509::Certificate.new( File.read(CERT_FILE) )
        http.key = OpenSSL::PKey::RSA.new( File.read(KEY_FILE), KEY_PASS )
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http
    end
  end
end

#Patch after upgrade to Rails 2.3.2
#See http://groups.google.com/group/rack-devel/browse_thread/thread/4bce411e5a389856
module Mime
  class Type
    def split(*args)
      to_s.split(*args)
    end
  end
end
