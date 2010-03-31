class ContentFilesController < ApplicationController
  before_filter :find_model
  
  def show
    pdone = {'percent_done' => @cf.percent_done.to_s}   
    render :json => pdone.to_json
    #render :text => @cf.percent_done.to_s
  end

  private
  def find_model
    ContentFile.uncached do
      @cf = ContentFile.find(params[:id]) if params[:id]
    end
  end
end
