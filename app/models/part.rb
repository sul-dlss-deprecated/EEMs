# Part
#   properties
#     :url
#     :done
#     :content_file_id
#     :size?
#   
#   content Datastream -no fedora checksum?
#     -points to workspace/eems-druid/content.pdf (we can create this even if the job isn't done)


class Part < ActiveFedora::Base
  has_metadata :name => 'properties', :type => ActiveFedora::MetadataDatastream do |m|
    m.field "url", :string
    m.field "done", :string
    m.field "content_file_id", :string
  end
  
  def initialize(attrs={})
    super(attrs)
  end
  
  def self.from_params(params)
    p = Part.new
    props = p.datastreams['properties']
    props.url_values = [params[:url]]
    props.content_file_id_values = [params[:content_file_id].to_s]
    props.done_values = ['false']
    p
  end
  
  
end