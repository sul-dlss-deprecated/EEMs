require 'dor/workflow_service'

class SubmitToTechServicesController < ApplicationController

  def create
    @eem = Eem.find(params[:eems_id])
    
    @props_ds = @eem.datastreams['eemsProperties']
    @props_ds.status_values = ['Submitted']
    now = Time.new.xmlschema
    @props_ds.statusDatetime_values = [now]
    @props_ds.requestDatetime_values = [now]
    @props_ds.save
    
    user = EemsUser.find(session[:user_id])
    action_log = @eem.datastreams['actionLog']
    action_log.log("Request submitted by #{user.display_name}", params[:comment])
    action_log.save
    
    Dor::WorkflowService.update_workflow_status('dor', params[:eems_id], 'eemsAccessionWF', 'submit-tech-services', 'completed')
    
    render :text => 'true'
  rescue Exception => e
    msg = e.message
    unless(e.backtrace.nil?)
      msg << "\n" << e.backtrace.join("\n")
    end
        
    Rails.logger.error("SubmitToTechServices failed:\n" << msg)
    render :status => 500, :text => "false"
  end
end