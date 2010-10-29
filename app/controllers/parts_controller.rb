
class PartsController < ApplicationController
  include ContentUpload
  
  before_filter :require_fedora
  before_filter :require_solr
  before_filter :user_required
  before_filter :authorized_user
  
  # Handles POST to /eems/:eems_id/parts
  def create
    @eem = Eem.find(params[:eem_id])
    @log = @eem.datastreams['actionLog']
    @user = EemsUser.load_from_session(session)
    
    create_content_dir
    
    # The file was uploaded with the POST
    if(!params[:content_upload].nil?) 
      create_part_from_upload_and_log
      
      #render_creation_response(@eem.pid, part.pid)
      res = 'eem_pid=' + @eem.pid
      render :text => res.to_s, :content_type => 'text/plain'
    else
        # TODO There was no content uploaded, throw an error
    end
    
  end
  
  
end