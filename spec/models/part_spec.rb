require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'active_fedora'

describe Part do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  before(:each) do
    @eem = Part.new(:pid => 'my:pid123')
    @eem.stub!(:save)
  end
  
  it "should be a kind of ActiveFedora::Base" do
    @eem.should be_kind_of(ActiveFedora::Base)
  end
    
  it "should initialize with url, content_file_id, and set done to false " do
    @parts_params = {
      :url => 'http://somesite.com/a.pdf',
      :content_file_id => 12
    }
    
    part = Part.from_params(@parts_params)
    props = part.datastreams['properties']
    props.url_values.should  == ['http://somesite.com/a.pdf']
    props.content_file_id_values.should == ['12']
    props.done_values.should == ['false']
  end
end