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
require 'lyber_core'
require 'cgi'
require 'eem_model'

class Part < EemModel::Part
  include DorBase
    
  def initialize(attrs={})
    setup(attrs)
  end
  
  def self.from_params(params={})
    p = Part.new
    props = p.datastreams['properties']
    props.url_values = [params[:url]] unless(params[:content_file_id].nil?)
    props.content_file_id_values = [params[:content_file_id].to_s] unless(params[:content_file_id].nil?)
    props.done_values = ['false']
    p
  end
  
  def create_content_datastream(filename)
    return if(datastreams.has_key?('content'))
    
    props_ds = datastreams['properties']
    props_ds.filename_values = [filename]
    props_ds.save
    mime_type = MIME::Types.type_for(filename).to_s
    url = Sulair::WORKSPACE_URL + '/' + parent_pid + '/' + filename
    
    #TODO what if more than one content file? add_content_datastream?
    attrs = {:dsID => 'content', :dsLocation => url, 
      :mimeType => mime_type, :dsLabel => 'Content File: ' + filename, :checksumType => 'MD5', :versionable => 'false' }
    ds = ActiveFedora::Datastream.new(attrs)
    ds.control_group = 'E'
    add_datastream(ds)
    ds.save
  end
  
  def parent_pid
    if(!parents(:response_format => :id_array).empty?)
      parents(:response_format => :id_array)[0]
    end
  end
  
  def download_done
    props_ds = datastreams['properties']
    props_ds.done_values= ['true']
    props_ds.download_date_values = (Time.now).strftime("%Y-%m-%dT%H:%M%z")
    props_ds.save
  end
  
  def log_download_complete(display_name)
    e = Eem.find(parent_pid)
    action_log = e.datastreams['actionLog']
    action_log.log("PDF uploaded by #{display_name}")
    action_log.save
  end
  
  def Part.normalize_filename(filename)
    URI::decode(filename)
  end
  
end
