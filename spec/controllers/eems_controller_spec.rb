require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'json'

describe EemsController do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  it "should be restful" do
    params_from(:get, "/eems/druid:1234").should == {:controller => 'eems', :action => 'show',
                                                     :id => 'druid:1234'}
  end
  
  describe "#create" do
    before(:each) do
      @eems_params = HashWithIndifferentAccess.new(
        {
          :copyrightDate => '1/1/10',
          :copyrightStatus => 'pending',
          :creatorName => 'Joe Bob',
          :creatorType => 'person',
          :language => 'English',
          :note => 'text of note',
          :notify => 'some@email.com',
          :paymentStatus => 'free|paid',
          :paymentFund => 'BIOLOGY',
          :selectorName => 'Bob Smith',
          :selectorSunetid => 'bsmith',
          :sourceTitle => 'title',
          :sourceUrl => 'http://something.org/papers',
        }
      )
      
      @content_url = 'http://something.org/papers/a.pdf'
      @eem = Eem.new(:pid => 'pid:123')
      @eem.set_properties(@eems_params.symbolize_keys)
      @eem.should_receive(:save)

      Eem.should_receive(:from_params).with(@eems_params).and_return(@eem)
      
      @cf = ContentFile.new
      @cf.stub!(:id).and_return(1)
      @cf.should_receive(:save).twice
      ContentFile.should_receive(:new).and_return(@cf)
      
      @part = Part.new(:pid => 'part:345')
      @part.stub!(:save)
      
      Part.should_receive(:new).and_return(@part)
      
      job = Dor::DownloadJob.new(@cf.id)
      Dor::DownloadJob.should_receive(:new).with(@cf.id).and_return(job)
      Delayed::Job.should_receive(:enqueue).with(job)
      
      post "create", :eem => @eems_params, :contentUrl => @content_url
      
    end
    
    it "should create a new Eem from the params hash and create the DelayedJob to do the download" do
     

    end
    
    it "should create a ContentFile object from the url" do

      @cf.url.should == @content_url
      @cf.filepath.should == File.join(SULAIR::WORKSPACE_DIR, 'pid:123', 'a.pdf')
    end
    
    it "should create a Part object from the ContentFile and url" do
      props = @part.datastreams['properties']
      props.url_values.should == [@content_url]
      props.content_file_id_values.should == ['1']
    end
    
    it "should set the ContentFile's part_pid to the created Part's pid" do
      @cf.part_pid.should == 'part:345'
    end
    
    it "should set the eem as the parent pid for the created part" do
      @part.parent_pid.should == @eem.pid
    end
    
    it "should return json with the eem pid, content file id, and part pid" do
      json = JSON.parse(response.body)
      json.should == {
        'eem_pid' => 'pid:123',
        'part_pid' => 'part:345',
        'content_file_id' => 1
        }
    end
    
  end
  
  describe "#show" do
    it "should find an Eem and render the show page" do
      @eem = Eem.new(:pid => 'pid:123')
      @part = Part.new()
      @part.add_relationship(:is_part_of, @eem)
      Eem.should_receive(:find).with('pid:123').and_return(@eem)
      @eem.should_receive(:parts).and_return([@part])
      
      get "show", :id => 'pid:123'
      
      assigns[:eem].should == @eem
      assigns[:parts].should == [@part]
    end
  end
end