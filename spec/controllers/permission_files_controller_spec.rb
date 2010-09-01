require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lyber_core'

describe PermissionFilesController do
  
  before(:each) do
    Fedora::Repository.stub!(:instance).and_return(stub('fedora').as_null_object)
    ActiveFedora::SolrService.stub!(:instance).and_return(stub('solr').as_null_object)
  end
  
  it "should be restful" do
    params_from(:post, "/eems/eem123/permission_files").should == {:controller => 'permission_files', :action => 'create',
                                                                          :eem_id => 'eem123'}
  end
  
  it "#destroy should delete a PermissionFile object" do
    mock_pf = mock('pf').as_null_object
    mock_pf.should_receive(:delete)
    PermissionFile.should_receive(:find).with('pfpid').and_return(mock_pf)
    
    delete "destroy", :submit_id => 'parentpid', :id => 'pfpid'
    
    response.should be_success
    response.should have_text('OK')
  end
  
  
  describe "#process_file" do
    it "should save a file to local disk and create a datastream for the content file" do
      file_stub = stub('stub_file', :original_filename => 'some_file.pdf', :size => 100000)
      eem_stub = stub('stub_eem', :pid => 'druid:123')
      props_ds =  mock('stub_props_ds').as_null_object 
      datastreams = {'properties' => props_ds }
      pf_stub = stub('stub_pf', :datastreams => datastreams, :save => true, :pid => 'druid:345')
      params = {:file => file_stub, :comment => "some comment"}
      
      controller.file = pf_stub
      controller.eem = eem_stub
      
      props_ds.should_receive(:comment_values=).with(["some comment"])
      
      #Save file to local disk
      File.should_receive(:exists?).and_return(true) 
      Dir.stub!(:mkdir)
      File.stub!(:open)
      
      #Create datastream for content
      mock_ds = mock('mock_datastream')
      ActiveFedora::Datastream.should_receive(:new).and_return(mock_ds)
      mock_ds.should_receive(:control_group=).with('E')
      mock_ds.should_receive(:versionable=).with(false)
      mock_ds.should_receive(:save)
      
      controller.process_file(params, "my dissertation")
    end
  end
    
  describe "#create_response" do
    before(:each) do
      controller.file_name = 'permission.pdf'
    end
    
    it "should create a hash with file name" do
      controller.create_response.should == {:file_name => 'permission.pdf'}
    end
    
  end
  
  
end