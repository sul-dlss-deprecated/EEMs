require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe Eem do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  before(:each) do
    @eem = Eem.new(:pid => 'my:pid123')
    @eem.stub!(:save)
  end
  
  it "should be a kind of ActiveFedora::Base" do
    @eem.should be_kind_of(ActiveFedora::Base)
  end
  
  it "should have a eemsProperties datastream" do
    @eem.datastreams['eemsProperties'].should_not be_nil
  end
  
  it "should have get and set properties" do
    props_ds = @eem.datastreams['eemsProperties']
    props_ds.document_values = ['mydocument']
    props_ds.copyrightdate_append('10-22-10')
    props_ds.contentdoc_values = ['http://mydoc.com']
    
    xml = props_ds.to_xml
    xml.should =~ /<document order='1'>mydocument<\/document>/
    xml.should =~ /<copyrightdate>10-22-10<\/copyrightdate>/
  end
  
  it "should initialize properties from a rails param hash" do
    @submitted_eem = {
      :contentdoc => 'http://www.site.com/some.pdf',
      :copyrightdoc => 'http://www.site.com/cright.pdf',
      :copyrightdate => '1/1/10',
      :copyrightstatus => 'pending',
      :creator => 'Pdf author',
      :language => 'English',
      :notify => 'some@email.com',
      :paymentaccount => 'aaaaaa-aa-aaaaaa',
      :paymentammount => '123.00',
      :paymentunit => 'dollars',
      :selectorname => 'Bob Smith',
      :selectorsunetid => 'bsmith',
      :sourcetitle => 'title',
      :sourceurl => 'http://something.org/papers',
      :submitted => 'sometimestamp'
    }
    
    eem = Eem.from_params(@submitted_eem)
    props = eem.datastreams['eemsProperties']
    props.creator_values = ['Pdf author']
  end
  
  #it "should handle a file that isn't retreived via HTTP GET'"
  
end