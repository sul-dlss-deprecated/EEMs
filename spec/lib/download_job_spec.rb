require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'curl'
require 'active_fedora'

describe Dor::DownloadJob do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
    FileUtils.mkdir(File.join(Sulair::WORKSPACE_DIR, 'druid:123')) unless (File.exists?(File.join(Sulair::WORKSPACE_DIR, 'druid:123')))
  end
  
  after(:all) do
    FileUtils.rm_rf(File.join(Sulair::WORKSPACE_DIR, 'druid:123'))
  end
  
  describe "perform" do
    it "should download the content file using Curl and update progress percentage and set the Part as download_done" do
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
    end
  end
end