require "active_fedora"
require "lyber_core"

class Eem < Dor::Base
  
  has_relationship "parts", :is_part_of, :inbound => true #content files
  
  has_metadata :name => 'eemsProperties', :type => ActiveFedora::MetadataDatastream do |m|
    m.field "copyrightStatusDate", :string, :multiple => false #mutiple doesn't do anything
    m.field "copyrightStatus", :string
    m.field "creatorOrg", :string
    m.field "creatorPerson", :string
    m.field "language", :string
    m.field "note", :string
    m.field "notify", :string
    m.field "paymentStatus", :string
    m.field "paymentFund", :string
    m.field "selectorName", :string
    m.field "selectorSunetid", :string
    m.field "title", :string
    m.field "sourceUrl", :string
    m.field "printedVersionSubmitted", :string
    m.field "requestDate", :string
    m.field "status", :string
    m.field "statusDateTime", :string
  end
  
  def initialize(attrs={})
    super(attrs)
  end
  
  #TODO this differs from Etd, but I'm not sure why we would need to declare Eem.new outside of this method
  def self.from_params(params_hash)
      e = Eem.new
      e.set_properties(params_hash)
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
  end
  
  
end