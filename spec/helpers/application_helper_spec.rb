require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  describe "#parse_solr_title_t" do
    it "should return a substring of 0..string.size/2 -2" do
      s = "123, 123"
      helper.parse_solr_title_t(s).should == '123'
    end
    
    it "should should handle a string where size/2 is odd" do
      s = "12, 12"
      helper.parse_solr_title_t(s).should == '12'
    end
  end
end