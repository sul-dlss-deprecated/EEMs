require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Eems show page" do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  it "should render the fields of an Eem" do
    @eem_params = {
      :contentdoc => 'http://www.site.com/some.pdf',
      :copyrightdoc => 'http://www.site.com/cright.pdf',
      :copyrightdate => '1/1/10',
      :copyrightstatus => 'pending',
      :creator => 'Pdf author',
      :language => 'English',
      :notify => 'some@email.com',
      :paymentaccount => 'aaaaaa-aa-aaaaaa',
      :paymentunit => 'dollars',
      :selectorname => 'Bob Smith',
      :selectorsunetid => 'bsmith',
      :sourcetitle => 'title',
      :sourceurl => 'http://something.org/papers'
    }
    assigns[:eem] = Eem.from_params(@eem_params)
    
    render "eems/show.html.erb"
    
    response.body.should =~ /Pdf author/
  end
end