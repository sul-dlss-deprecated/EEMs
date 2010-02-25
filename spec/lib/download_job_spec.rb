require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'curl'

describe Dor::DownloadJob do
  describe "perform" do
    it "should download the content file using Curl and update progress percentage" do
      cf = ContentFile.new
      cf.url = 'http://server.com/a.pdf'
      curl = mock('curl')
      
      ContentFile.stub!(:find).and_return(cf)
      Curl::Easy.should_receive(:download).with('http://server.com/a.pdf', /a\.pdf/).and_yield(curl)
      curl.should_receive(:on_progress).and_yield(100, 33, 0, 0)
      
      job = Dor::DownloadJob.new(1)
      job.perform
      
      cf.percent_done.should == 33
    end
  end
end