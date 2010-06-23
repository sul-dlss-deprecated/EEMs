class LogController < ApplicationController
  before_filter :require_fedora
  before_filter :require_solr

  def create
    eem = Eem.find(params[:eems_id])
    log = eem.datastreams['actionLog']
    log.log(params[:entry])
    log.save
    
    render :text => 'logged'
  end
end