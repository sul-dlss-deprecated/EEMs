require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
    it "should create a new Eem from the params hash" do
      params = {
        'contentdoc' => 'http://www.site.com/some.pdf',
        # :copyrightdoc => 'http://www.site.com/cright.pdf',
        # :copyrightdate => '1/1/10',
        # :copyrightstatus => 'pending',
        # :creator => 'Pdf author',
        # :language => 'English',
        # :notify => 'some@email.com',
        # :paymentaccount => 'aaaaaa-aa-aaaaaa',
        # :paymentunit => 'dollars',
        # :selectorname => 'Bob Smith',
        # :selectorsunetid => 'bsmith',
        # :sourcetitle => 'title',
        # :sourceurl => 'http://something.org/papers'
      }
      
      @eem = Eem.new(:pid => 'pid:123')
      Eem.should_receive(:from_params).with(params).and_return(@eem)
      @eem.should_receive(:save)
      
      post "create", :eem => params
      
      response.should redirect_to(:action => 'show', :id => @eem.pid)
    end
    
  end
  
  describe "#show" do
    it "should find an Eem and render the show page" do
      @eem = Eem.new(:pid => 'pid:123')
      Eem.should_receive(:find).with('pid:123').and_return(@eem)
      
      get "show", :id => 'pid:123'
      
      assigns[:eem].should == @eem
    end
  end
end