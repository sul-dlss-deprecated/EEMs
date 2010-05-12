require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EemsHelper do
  
  describe "#eems_text_field_tag" do
    it "should generate the html for an eem property using the field name and text" do
      html =<<-EOF
      <p>
          <%= text_field_tag 'eem[note]' %>
          <input id="eem_note" name="eem[note]" type="text" value=""/>
      </p>
      EOF
      
      out = helper.eems_text_field_tag(:note)
      out.should =~ /<input id=\"eem_note\" name=\"eem\[note\]\" type=\"text\" value=\"\" \/>/      
    end
  end
  
  describe "#get_source_url" do
    it "should return a URL or an empty string for a given referrer object" do
      helper.get_source_url('https://jirasul.stanford.edu/jira/browse/EEMS-13').should == 'https://jirasul.stanford.edu/jira/browse/EEMS-13'
      helper.get_source_url(nil).should == ""      
    end 
  end  

  describe "#shorten_url" do
    it "should return a shortened URL (if length is less than 50 chars) for a given URL" do
      helper.shorten_url('http://www.irs.gov/app/picklist/list/formsPublications.html').should == 'http://www.irs.gov/app/picklist/list/formsPublicat...'
      helper.shorten_url('http://www.stanford.edu/01.pdf').should == 'http://www.stanford.edu/01.pdf'      
    end 
  end  
    
end
