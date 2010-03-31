class EemsController < ApplicationController
  before_filter :require_fedora
  before_filter :require_solr
  
  #GET /eems/{:id}
  def show
    @eem = Eem.find(params[:id])
    @parts = @eem.parts
    render :layout => "eems_show"
  end
  
  #GET /eems/new
  #render the page to create a new Eem
  def new   
  end
  
  #POST /eems
  #Handles submit from /eems/new
  #Assume we receive the standard Rails hash of all the form params
  def create
    eem = Eem.from_params(params[:eem])
    eem.save
    
    cf = ContentFile.new
    cf.url = params[:contentUrl]
    filename = params[:contentUrl].split(/\?/).first.split(/\//).last
    FileUtils.mkdir(File.join(SULAIR::WORKSPACE_DIR, eem.pid)) unless (File.exists?(File.join(SULAIR::WORKSPACE_DIR, eem.pid)))
    cf.filepath = File.join(SULAIR::WORKSPACE_DIR, eem.pid, filename)
    cf.save
    
    part = Part.from_params(:url => params[:contentUrl], :content_file_id => cf.id)
    part.add_relationship(:is_part_of, eem)
    part.save
    cf.part_pid = part.pid
    cf.save
    
    job = Dor::DownloadJob.new(cf.id)
    Delayed::Job.enqueue(job)
    
    resp = {
      'eem_pid' => eem.pid,
      'part_pid' => part.pid,
      'content_file_id' => cf.id
    }
    
    render :json => resp.to_json
  end
  
  # Taken from Salt project
  # Uses the update_indexed_attributes method provided by ActiveFedora::Base
  # This should behave pretty much like the ActiveRecord update_indexed_attributes method
  # For more information, see the ActiveFedora docs.
  # 
  # Examples
  # put :update, :id=>"_PID_", "document"=>{"subject"=>{"-1"=>"My Topic"}}
  # Appends a new "subject" value of "My Topic" to any appropriate datasreams in the _PID_ document.
  # put :update, :id=>"_PID_", "document"=>{"medium"=>{"1"=>"Paper Document", "2"=>"Image"}}
  # Sets the 1st and 2nd "medium" values on any appropriate datasreams in the _PID_ document, overwriting any existing values.
  def update
    @eem = Eem.find(params[:id])
    attrs = unescape_keys(params[:eem])
    logger.debug("attributes submitted: #{attrs.inspect}")
    @eem.update_indexed_attributes(attrs)
    @eem.save
    response = attrs.keys.map{|x| escape_keys({x=>attrs[x].values})}
    logger.debug("returning #{response.inspect}")
    respond_to do |want| 
      want.js {
        render :json=> response.pop
      }
    end
  end
end