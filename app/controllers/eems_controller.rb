class EemsController < ApplicationController
  before_filter :require_fedora
  before_filter :require_solr
  
  #GET /eems/{:id}
  def show
    @eem = Eem.find(params[:id])
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
    
    redirect_to :action => 'show', :id => eem.pid
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