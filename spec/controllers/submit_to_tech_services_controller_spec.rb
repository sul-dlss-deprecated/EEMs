require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubmitToTechServicesController do
  it "should be restful" do
    params_from(:post, "/eems/23/submit_to_tech_services").should == {:controller => 'submit_to_tech_services', :action => 'create', :eems_id => "23"}
  end
  
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
  end
  
  describe "#create" do
  
    before(:each) do
      Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
      @eem = Eem.new(:pid => 'my:pid123')
      log = Dor::ActionLogDatastream.new
      @eem.add_datastream(log)
      
      session[:user_id] = 'wmene'
      Eem.should_receive(:find).with('my:pid123').and_return(@eem)

      Dor::WorkflowService.should_receive(:update_workflow_status).with('dor', 'my:pid123', 'eemsAccessionWF', 'submit-tech-services', 'completed')
    end
    
    it "should set status to 'Submitted'" do
      post "create", :eems_id => 'my:pid123'
      @props_ds = @eem.datastreams['eemsProperties']
      @props_ds.status_values.should == ['Submitted']
    end
    
    it "should set statusDatetime and requestDatetime to now" do
      post "create", :eems_id => 'my:pid123'
      @props_ds = @eem.datastreams['eemsProperties']
      sleep 1
      status = Time.parse(@props_ds.statusDatetime_values.first)
      status.should < Time.new
      
      request = Time.parse(@props_ds.requestDatetime_values.first)
      request.should < Time.new
    end
    
    it "should create the eemsAccessioningWF datastream" do
      post "create", :eems_id => 'my:pid123'
    end
    
    it "should add a log entry saying 'Request submitted by {current_user}'" do
      post "create", :eems_id => 'my:pid123'
      @props_ds = @eem.datastreams['eemsProperties']
      entry = @eem.datastreams['actionLog'].entries.first
      entry[:action].should == 'Request submitted by Willy Mene'
    end
    
    it "should handle a comment passed as a param" do
      post "create", :eems_id => 'my:pid123', :comment => 'My thoughts on this...'
      @props_ds = @eem.datastreams['eemsProperties']
      entry = @eem.datastreams['actionLog'].entries.first
      entry[:action].should == 'Request submitted by Willy Mene'
      entry[:comment].should == 'My thoughts on this...'
    end
    
    it "should return the text 'true' if there were no errors" do
      post "create", :eems_id => 'my:pid123'
      
      response.should be_success
      response.status.should == "200 OK"
      response.body.should == 'true'
    end
  end
  
  it "should return false if there was a problem" do
    Eem.stub!(:find).and_throw(Exception.new('Something bad'))
    post "create", :eems_id => 'my:pid123'
    
    response.should_not be_success
    response.status.should == "500 Internal Server Error"
    response.body.should == 'false'
  end
end