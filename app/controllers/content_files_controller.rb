class ContentFilesController < ApplicationController
  before_filter :find_model
  
  def show
    pdone = {'percent_done' => @cf.percent_done.to_s}   
    render :json => pdone.to_json
  end

  private
  def find_model
    @cf = ContentFile.find(params[:id]) if params[:id]
  end
end