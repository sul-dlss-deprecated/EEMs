require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EemsUser do
  it "should should generate a display name" do
    u = EemsUser.new('first', 'last', 'sunetid')
    u.display_name.should == 'first last'
  end
  
  describe "#find" do
    it "should find users as defined in /config/users.yml" do
      w = EemsUser.find('wmene')
      w.sunetid.should == 'wmene'
    end
  end
  
end