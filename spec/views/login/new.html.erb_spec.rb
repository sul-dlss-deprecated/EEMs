require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe " New Login view" do
  it "should display a link to /login/webauth" do
    render "login/new.html.erb"
    
    response.body.should =~ /<a href=\"\/login\/webauth\">/
  end
end