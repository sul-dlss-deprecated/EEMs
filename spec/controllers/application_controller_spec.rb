require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Need to test filters defined in ApplicationController, so all tests are used in context of a real controller
# since ApplicationController does not have any actions to handle requests
describe EemsController do
  
  describe "set_current_user filter" do
    context "when a user has webauth'ed" do
      it "saves the EemsUser into the session" do
        request.env['WEBAUTH_LDAP_DISPLAYNAME'] = 'My Name'
        request.env['WEBAUTH_USER'] = 'mysunetid'
        
        controller.send(:set_current_user)
        user = EemsUser.load_from_session(session)
        user.display_name.should == 'My Name'
        user.sunetid.should == 'mysunetid'
      end
    end
    
    context "when a user has not webauth'ed" do
      it "does not save an EemsUser into the session" do
        controller.send(:set_current_user)
        session[:eems_user].should be_nil
      end
    end
  end
  
  describe "user_required filter" do
    context "with no user" do
      it "redirects to /login and pass the referrer" do
        get "show", :id => 'dontcare', :referrer => "http://someurl.com"
        response.should redirect_to('/login?referrer=http://someurl.com')
      end
      
      it "and no referrer redirects to /login and pass '/' as the referrer" do
        get "show", :id => 'dontcare'
        response.should redirect_to('/login?referrer=/')
      end
    end
    
    context "with user" do
      it "returns true" do
        user = EemsUser.new('dname', 'sunet')
        user.save_to_session(session)
        controller.send(:user_required).should be_true
      end
    end
  end
  
  
  describe "authorized_user filter" do
    it "checks to see if the WEBAUTH_LDAPPRIVGROUP environent variable contains the authorized privgroup" do
      request.env['WEBAUTH_LDAPPRIVGROUP'] = 'sulair:eems-users'
      controller.send(:authorized_user).should be_true
    end
    
    it "returns a 401 unauthorized error if WEBAUTH_LDAPPRIVGROUP environent variable is not set" do
      controller.should_receive(:user_required).and_return(true)
      get "show", :id => 'pid:123'
      
      response.should render_template('eems/_error/_not_authorized')
      response.status.should == '401 Unauthorized'
    end
  end
end