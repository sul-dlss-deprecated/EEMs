require 'active_fedora'
require 'rexml/document'
require 'nokogiri'

module Dor
  class ActionLogDatastream < ActiveFedora::Datastream
    attr_accessor :entries
    
    def initialize(attrs=nil)
      super
      self.label = "Action Log"
      self.dsid = "actionLog"
      self.control_group = 'X'
      self.versionable = false
      @entries = []
    end
    
    def save
      self.blob = self.to_xml
      super
    end

    def log(action, comment = nil)
      entry = {:timestamp => Time.new, :action => action}
      entry[:comment] = comment unless(comment.nil?)
      @entries << entry
    end

    def each_entry(&block)
      @entries.each do |entry|
        block.call(entry[:timestamp], entry[:action], entry[:comment])
      end
    end
    
    ########################################################################
    # Fedora datastream marshalling
    
    def self.from_xml(tmpl, el)
      entries = []
      el.elements.each("./foxml:datastreamVersion[last()]/foxml:xmlContent/actionLog/entry") do |node|
        entry = {:timestamp => Time.parse(node.attributes["timestamp"]), 
                 :action => node.elements["action"].text}
        entry[:comment] = node.elements["comment"].text if(node.elements["comment"])
        entries << entry
      end
      
      #TODO maybe sort by timestamp?
      tmpl.entries = entries
      tmpl
    end
    
    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.actionLog {
          self.each_entry do |ts, action, comment|
            xml.entry(:timestamp => ts.xmlschema) {
              xml.action action
              xml.comment comment unless(comment.nil?)
            }
          end
        }
      end
      builder.to_xml
    end
    
    
  end
end