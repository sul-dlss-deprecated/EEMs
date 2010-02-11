require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe Eem do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
  end
  before(:each) do
    @eem = Eem.new(:pid => 'my:testpid')
  end
  
  it "should be a kind of ActiveFedora::Base" do
    @eem.should be_kind_of(ActiveFedora::Base)
  end
end