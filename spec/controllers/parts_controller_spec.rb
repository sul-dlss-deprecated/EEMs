
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PartsController do
  before(:all) do
    ActiveFedora::SolrService.register(SOLR_URL)
    Fedora::Repository.register(FEDORA_URL)
    Fedora::Repository.stub!(:instance).and_return(stub('frepo').as_null_object)
  end
  
  it "should be restful" do
    params_from(:post, "/eems/druid:123/parts").should == {:controller => 'parts', :action => 'create', :eem_id => 'druid:123'}                                                                     
  end
  
  
  describe "#create" do
    before(:each) do
      @file = Tempfile.new(['pre%20space', '.pdf'])
      @file.stub!(:original_filename).and_return(@file.path.split(/\//).last)

      
      @eem = Eem.new(:pid => 'pid:123')
      Eem.should_receive(:find).with('pid:123').and_return(@eem)
            
      @part = Part.new(:pid => 'part:345')
      @part.stub!(:save)
      Part.should_receive(:new).and_return(@part)
      
      @log = Dor::ActionLogDatastream.new
      @eem.stub_chain(:datastreams, :[]).and_return(@log)
      
      # @user = EemsUser.new('Willy Mene', 'wmene')
      #       @user.save_to_session(session)
      #       request.env['WEBAUTH_LDAPPRIVGROUP'] = Sulair::AUTHORIZED_EEMS_PRIVGROUP

      post "create", :eem_id => 'pid:123', :content_upload => @file, :wau => 'Willy Mene'
    end
    
    it "should create the content datastream and save it" do    
      content_ds = @part.datastreams['content']
      content_ds[:dsLocation].match(/#{Sulair::WORKSPACE_URL}\/pid:123\/pre space.pdf/).should_not be_nil
      
      props_ds = @part.datastreams['properties']
      props_ds.filename_values.first.should =~ /pre space.pdf/
      
      @log.entries.size.should == 1
      entry = @log.entries.first
      entry[:action].should == "File uploaded by Willy Mene"
      
      response.body.should == 'eem_pid=pid:123'
    end
  end
end