# Part
#   properties
#     :url
#     :done
#     :content_file_id
#     :size?
#
#   -:done initialized to false
#   
#   content Datastream
#     -points to workspace/eems-druid/content.pdf (we can create this even if the job isn't done)


class Part < ActiveFedora::Base
  
  has_relationship "parents", :is_part_of #relationship between content file and parent Eem
  
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
  
  def create_content_datastream
    return if(datastreams.has_key?('content'))
    
    props_ds = datastreams['properties']
    filename = props_ds.url_values.first.split(/\?/).first.split(/\//).last
    mime_type = MIME::Types.type_for(filename).to_s
    
    url = SULAIR::WORKSPACE_URL + '/' + parent_pid + '/' + filename
    
    #TODO what if more than one content file? add_content_datastream?
    attrs = {:dsID => 'content', :dsLocation => url, 
      :mimeType => mime_type, :dsLabel => 'Content File: ' + filename, :checksumType => 'MD5', :versionable => 'false' }
    ds = ActiveFedora::Datastream.new(attrs)
    ds.control_group = 'E'
    add_datastream(ds)
  end
  
  def parent_pid
    if(!parents(:response_format => :id_array).empty?)
      parents(:response_format => :id_array)[0]
    end
  end
  
  def download_done
    props_ds = datastreams['properties']
    props_ds.done_values= ['true']
    props_ds.save
  end
end