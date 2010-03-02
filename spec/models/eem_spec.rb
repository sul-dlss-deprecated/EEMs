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
    props_ds.note_values = ['a note to myself']
    props_ds.copyrightDate_append('10-22-10')
    
    xml = props_ds.to_xml
    xml.should =~ /<note>a note to myself<\/note>/
    xml.should =~ /<copyrightDate>10-22-10<\/copyrightDate>/
  end
  
  it "should initialize properties from a rails param hash" do
    @submitted_eem = {
      :copyrightDate => '1/1/10',
      :copyrightStatus => 'pending',
      :creatorOrg => 'text from creator field',
      :creatorPerson => 'creator person',
      :language => 'English',
      :note => 'text of note',
      :notify => 'some@email.com',
      :paymentStatus => 'free|paid',
      :paymentFund => 'BIOLOGY',
      :selectorName => 'Bob Smith',
      :selectorSunetid => 'bsmith',
      :sourceTitle => 'title',
      :sourceUrl => 'http://something.org/papers',
      :submitted => 'sometimestamp'
    }
    
    eem = Eem.from_params(@submitted_eem)
    props = eem.datastreams['eemsProperties']
    props.creatorPerson_values.should == ['creator person']
  end
  
  #it "should handle a file that isn't retreived via HTTP GET'"
  
end