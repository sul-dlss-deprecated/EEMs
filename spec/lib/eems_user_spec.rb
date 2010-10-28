require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EemsUser do
  it "generates a display name" do
    u = EemsUser.new('first last', 'sunetid')
    u.display_name.should == 'first last'
  end
  
  it "does not have a #find method" do
    EemsUser.should_not respond_to(:find)
  end
  
  it "does not have a #valid? method" do
    EemsUser.should_not respond_to(:valid?)
  end
  
end