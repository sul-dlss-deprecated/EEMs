
class PartsController < ApplicationController
  before_filter :require_fedora
  before_filter :require_solr
  before_filter :user_required
  before_filter :authorized_user
  
  # Handles POST to /eems/:eems_id/parts
  def create
    @eem = Eem.find(params[:eem_id])
    
    content_dir = File.join(Sulair::WORKSPACE_DIR, @eem.pid)
    FileUtils.mkdir(content_dir) unless (File.exists?(content_dir))
    
    # The file was uploaded with the POST
    if(!params[:content_upload].nil?) 
      content_file = params[:content_upload]
      part = Part.from_params()
      part.add_relationship(:is_part_of, @eem)
      part.save
      
      filename = Part.normalize_filename(content_file.original_filename)
      File.open(File.join(content_dir,filename), "wb") { |f| f.write(content_file.read) }
      
      part.create_content_datastream(filename)
      part.download_done
      
      log = @eem.datastreams['actionLog']
      @user = EemsUser.find(session[:user_id])
      log.log("PDF uploaded by #{@user.display_name}")
      log.save
      
      #render_creation_response(@eem.pid, part.pid)
      res = 'eem_pid=' + @eem.pid
      render :text => res.to_s, :content_type => 'text/plain'
    else
        # There was no content uploaded, throw an error
    end
    
  end
  
  
end