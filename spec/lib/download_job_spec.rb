require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'curl'
require 'active_fedora'

describe Dor::DownloadJob do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  describe "perform" do
    it "should download the content file using Curl and update progress percentage" do
      cf = ContentFile.new
      cf.url = 'http://server.com/a.pdf'
      cf.filepath = File.join(SULAIR::WORKSPACE_DIR, 'druid:123', 'a.pdf')
      cf.part_pid = 'part:123'
      curl = mock('curl')
      
      part = Part.from_params(:url => cf.url, :content_file_id => 12)
      part.stub!(:save)
      part.stub!(:parent_pid).and_return('parent:pid')
      
      ContentFile.stub!(:find).and_return(cf)
      Curl::Easy.should_receive(:download).with(cf.url, cf.filepath).and_yield(curl)
      curl.should_receive(:on_progress).and_yield(100, 33, 0, 0)
      Part.should_receive(:find).with(cf.part_pid).and_return(part)
      
      job = Dor::DownloadJob.new(1)
      job.perform
      
      cf.percent_done.should == 33
      part.datastreams.has_key?('content').should be_true
      part.datastreams['properties'].done_values.should == ['true']
    end
  end
end