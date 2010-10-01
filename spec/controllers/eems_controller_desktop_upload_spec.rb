
require File.dirname(__FILE__) + '/../spec_helper'
require 'json'

describe EemsController do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
  end
  
  describe "#create" do
    before(:each) do
      @file = Tempfile.new(['pre%20space', '.pdf'])
      @file.stub!(:original_filename).and_return(@file.path.split(/\//).last)
      @eems_params = HashWithIndifferentAccess.new(
        {
          :copyrightStatusDate => '1/1/10',
          :copyrightStatus => 'pending',
          :creatorName => 'Joe Bob',
          :creatorType => 'person',
          :language => 'English',
          :note => 'text of note',
          :paymentType => 'free|paid',
          :paymentFund => 'BIOLOGY',
          :selectorName => 'Bob Smith',
          :selectorSunetid => 'bsmith',
          :title => 'title',
          :sourceUrl => 'http://something.org/papers'
        }
      )
      
      @eem = Eem.new(:pid => 'pid:123')
      @eem.set_properties(@eems_params.stringify_keys)
      @eem.should_receive(:save)
      
      Eem.should_receive(:from_params).with(@eems_params).and_return(@eem)
      Dor::WorkflowService.should_receive(:create_workflow).with('dor', 'pid:123', 'eemsAccessionWF', ACCESSION_WF_XML)
      
      @log = Dor::ActionLogDatastream.new
      Dor::ActionLogDatastream.should_receive(:new).and_return(@log)
      @eem.should_receive(:add_datastream).with(an_instance_of(Dor::ActionLogDatastream))
      
      @part = Part.new(:pid => 'part:345')
      @part.stub!(:save)
      
      Part.should_receive(:new).and_return(@part)
      
      
      session[:user_id] = 'wmene'

      post "create", :eem => @eems_params, :content_upload => @file
    end
    
    it "should create the content datastream and save it" do    
      content_ds = @part.datastreams['content']
      content_ds[:dsLocation].match(/#{Sulair::WORKSPACE_URL}\/pid:123\/pre space.pdf/).should_not be_nil
      
      props_ds = @part.datastreams['properties']
      props_ds.filename_values.first.should =~ /pre space.pdf/
      
      @log.entries.size.should == 2
      entry = @log.entries[1]
      entry[:action].should == "PDF uploaded by Willy Mene"
      
      response.body.should == 'eem_pid=pid:123'
    end
    
  end
  
end