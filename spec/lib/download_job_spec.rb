require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'curl'
require 'active_fedora'
require 'tempfile'

describe Dor::DownloadJob do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
    
  end
    
  describe "perform" do
    it "should download the content file using Curl and update progress percentage and set the Part as download_done" do
      FileUtils.mkdir(File.join(Sulair::WORKSPACE_DIR, 'druid:123')) unless (File.exists?(File.join(Sulair::WORKSPACE_DIR, 'druid:123')))
      
      cf = ContentFile.new
      cf.url = 'http://stanford.edu/images/stanford_title.jpg'
      cf.filepath = File.join(Sulair::WORKSPACE_DIR, 'druid:123')
      cf.part_pid = 'part:123'
      #curl = mock('curl')
      
      part = Part.from_params(:url => cf.url, :content_file_id => 12)
      part.stub!(:save)
      part.stub!(:parent_pid).and_return('parent:pid')
      
      ContentFile.stub!(:find).and_return(cf)
      #Curl::Easy.should_receive(:download).with(cf.url, cf.filepath).and_yield(curl)
      #curl.should_receive(:on_progress).and_yield(100, 33, 0, 0)
      Part.should_receive(:find).with(cf.part_pid).and_return(part)
      
      job = Dor::DownloadJob.new(1)
      job.perform
      
      part.datastreams.has_key?('content').should be_true
      part.datastreams['properties'].done_values.should == ['true']
      part.datastreams['properties'].filename_values.should == ['stanford_title.jpg']
      
      File.file?(File.join(cf.filepath, 'stanford_title.jpg')).should be_true
      
      FileUtils.rm_rf(File.join(Sulair::WORKSPACE_DIR, 'druid:123'))
    end
  end
  
  describe "error handling" do
    it "should increment the number of attempts if an exception is thrown" do
      
      cf = ContentFile.new
      cf.url = 'http://stanford.edu/images/stanford_title.jpg'
      cf.attempts = 1
            
      ContentFile.stub!(:find).and_return(cf)
      Tempfile.should_receive(:new).and_raise(Exception.new)
      job = Dor::DownloadJob.new(1)
      cf.should_receive(:attempts=).with(2)
      cf.should_receive(:save)
      lambda{ job.perform }.should raise_exception
            
    end
    
    it "should not set attempts to greater than 5" do
      
      cf = ContentFile.new
      cf.url = 'http://stanford.edu/images/stanford_title.jpg'
      cf.attempts = 5
            
      ContentFile.stub!(:find).and_return(cf)
      Tempfile.should_receive(:new).and_raise(Exception.new)
      job = Dor::DownloadJob.new(1)
      cf.should_not_receive(:attempts=)
      cf.should_not_receive(:save)
      lambda{ job.perform }.should raise_exception
            
    end
  end
end