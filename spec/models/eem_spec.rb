require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe Eem do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
  end
  
  before(:each) do
    Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
    @eem = Eem.new(:pid => 'my:pid123')
    @eem.stub!(:save)
  end
  
  it "should be a kind of ActiveFedora::Base" do
    @eem.should be_kind_of(ActiveFedora::Base)
    @eem.should be_kind_of(Dor::Base)
  end
  
  it "should have a eemsProperties datastream" do
    @eem.datastreams['eemsProperties'].should_not be_nil
  end
  
  it "should have get and set properties" do
    props_ds = @eem.datastreams['eemsProperties']
    props_ds.note_values = ['a note to myself']
    props_ds.copyrightStatusDate_append('10-22-10')
    
    xml = props_ds.to_xml
    xml.should =~ /<note>a note to myself<\/note>/
    xml.should =~ /<copyrightStatusDate>10-22-10<\/copyrightStatusDate>/
  end
  
  describe "creator initialization" do
    before(:each) do
      @submitted_eem = HashWithIndifferentAccess.new({
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
        :sourceUrl => 'http://something.org/papers',
        :requestDatetime => 'sometimestamp'
      })
      
      
    end
    
    it "should initialize an eem with a creator type of person" do
      eem = Eem.from_params(@submitted_eem.stringify_keys)
      props = eem.datastreams['eemsProperties']
      props.creatorPerson_values.should == ['Joe Bob']
      props.creatorOrg_values.should == []
    end
    
    it "should initialize an eem with a creator type of organziation" do
      @submitted_eem[:creatorType] = 'organization'
      @submitted_eem[:creatorName] = 'US Geological Survey'
      
      eem = Eem.from_params(@submitted_eem.stringify_keys)
      props = eem.datastreams['eemsProperties']
      props.creatorPerson_values.should == []
      props.creatorOrg_values.should == ['US Geological Survey']
    end
  end
  

  
  #it "should handle a file that isn't retreived via HTTP GET'"
  
end
