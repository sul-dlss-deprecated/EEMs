require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Eems show page" do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  it "should render the fields of an Eem" do
    @eem_params = {
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
    assigns[:eem] = Eem.from_params(@eem_params)
    
    render "eems/show.html.erb"
    
    response.body.should =~ /creator person/
  end
end