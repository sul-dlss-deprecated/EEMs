require "active_fedora"
require "lyber_core"
require 'dor/action_log_datastream'
require 'eem_model'


class Eem < EemModel::Eem
  include EemModel::EemAccession
  include DorBase
  
  
    
  has_metadata :name => 'actionLog', :type => Dor::ActionLogDatastream do |m|
    #nada
  end
    
  def initialize(attrs={})
    super(attrs)
  end
  
  #TODO this differs from Etd, but I'm not sure why we would need to declare Eem.new outside of this method
  def self.from_params(params_hash)
      e = Eem.new
      e.set_properties(params_hash)
      id_xml = e.generate_initial_identity_metadata_xml
      attrs = { :dsID => 'identityMetadata', :mimeType => 'application/xml', :dsLabel => 'Identity Metadata'}
      datastream = ActiveFedora::Datastream.new(attrs)
      datastream.content = id_xml
      datastream.control_group = 'X'
      datastream.versionable = false
      e.add_datastream(datastream)
      e.save
      e
  end
  
  def set_properties(params_hash)
    props = datastreams['eemsProperties']
    
    params_hash.each_pair do |field, value|
      case field
      when 'creatorType'
        if(value =~ /person/)
          props.creatorPerson_values = [params_hash['creatorName']]
        else
          props.creatorOrg_values = [params_hash['creatorName']]
        end
      when 'creatorName'
        #skip
      else
        eval("props.#{field.to_s}_values = [#{value.inspect}]")
      end
    end
    
    set_dc_and_fedora_metadata(props)
  end
  
  def set_dc_and_fedora_metadata(props_ds)
    title = props_ds.title_values.first
		if(title)
      self.label = 'EEMs: ' + title.gsub(/[\s\v\b]+/, " ")
    end    
  end
  

  
  
end


  
# Nokogiri monkey-patch for usage with webrat
# http://github.com/pengwynn/linkedin/issues/#issue/4
##class Nokogiri::XML::Element
  ##def has_key?(key)
    ##self.keys.include?(key)
  ##end
##end
