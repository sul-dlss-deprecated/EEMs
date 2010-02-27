require "active_fedora"

class Eem < ActiveFedora::Base
  
  has_relationship "parts", :is_part_of, :inbound => true #content files
  
  has_metadata :name => 'eemsProperties', :type => ActiveFedora::MetadataDatastream do |m|
    m.field "contentdoc", :string, :xml_node => 'document', :element_attrs => {:type => 'content', :order => '1'}
    m.field "copyrightdoc", :string, :element_attrs => {:order => '1'}
    m.field "copyrightdate", :string, :multiple => false #mutiple doesn't do anything
    m.field "copyrightstatus", :string
    m.field "creator", :string
    m.field "document", :string, :element_attrs => {:order => '1'} #can I change attribute values?
    m.field "language", :string
    m.field "notify", :string
    m.field "paymentaccount", :string
    m.field "paymentammount", :string
    m.field "paymentunit", :string
    m.field "selectorname", :string
    m.field "selectorsunetid", :string
    m.field "sourcetitle", :string
    m.field "sourceurl", :string
    m.field "submitted", :string
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
      eval("props.#{field.to_s}_values = [#{value.inspect}]")
    end
  end
  
  
end