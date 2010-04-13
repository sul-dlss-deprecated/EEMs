require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Eems show page" do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stubs(:instance).returns(stub('frepo').as_null_object)
  end
  
  before(:each) do
    @parts_params = {
      :url => 'http://somesite.com/a.pdf',
      :content_file_id => 12
    }
    
    @p = Part.new(:pid => 'my:pid123')
    @p.stub!(:save)
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
      :sourceTitle => 'some title for the eem',
      :sourceUrl => 'http://something.org/papers',
      :submitted => 'sometimestamp'
    }

		eem = Eem.from_params(@eem_params)
		eem.stub!(:save)

		part = Part.from_params(@parts_params)
		part.stub!(:save)
    part.add_relationship(:is_part_of, @eem)

    assigns[:eem] = eem
    
    render "eems/show.html.erb"
    
    response.body.should =~ /<h1 class=\"mainTitle\">some title for the eem<\/h1>/i
    response.body.should =~ /<option value=\"person\" selected=\"selected\">person<\/option>/i
  end
end
