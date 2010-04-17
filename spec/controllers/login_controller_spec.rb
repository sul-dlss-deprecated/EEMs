require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginController do



  describe "#new" do

    it "should handle the /login path" do
      params_from(:get, '/login').should == {:controller => 'login', :action => 'new'}
      params_from(:get, '/login?referrer=http://google.com').should ==  {:controller => 'login', :action => 'new',
                                                                        :referrer => 'http://google.com'}
    end
    


    it "should store the referrer param in the session" do
      get 'new', :referrer => 'http://cnn.com'
      
      session[:referrer].should == 'http://cnn.com'

    end

  end
  
  describe "#webauth" do
    it "should handle the /login/webauth path" do
      params_from(:get, '/login/webauth').should == {:controller => 'login', :action => 'webauth'}
    end
    
    it "should redirect to session[:referrer]" do
      session[:referrer] = 'http://cnn.com'
      get 'webauth', :wau => 'wmene'
      
      response.should redirect_to('http://cnn.com')
      session[:user_id].should == 'wmene'
    end
  end

end