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
    
end
