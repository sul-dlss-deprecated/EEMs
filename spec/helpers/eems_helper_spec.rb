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
    it "should return a shortened URL (if length is less than 40 chars) for a given URL" do
      helper.shorten_url('http://www.irs.gov/app/picklist/list/formsPublications.html').should == 'http://www.irs.gov/app/picklist/list/for...'
      helper.shorten_url('http://www.stanford.edu/01.pdf').should == 'http://www.stanford.edu/01.pdf'      
    end 
  end  
  
  describe "#get_local_file_path" do
    it "should return a URI with a url-encoded filename" do
      parts = stub('parts')
      eem = stub('eem')
      eem.stub!(:pid).and_return('etd:123')
      assigns[:parts] = parts
      assigns[:eem] = eem
      parts.stub_chain(:[], :datastreams, :[], :filename_values, :first).and_return('file some space.pdf')
      
      helper.get_local_file_path.should == Sulair::WORKSPACE_URL + '/etd:123/file%20some%20space.pdf'
    end
  end
    
end
