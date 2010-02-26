require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'json'

describe ContentFilesController do
  
  it "should be restful" do
    params_from(:get, "/content_files/23").should == {:controller => 'content_files', :action => 'show', :id => "23"}
  end
  
  describe "#show" do
    it "should return the percentage done as json" do
      cf = ContentFile.new
      cf.percent_done = 45
      cf.save
      
      get "show", :id => cf.id
      
      json = JSON.parse(response.body)
      json.should == {'percent_done' => '45'}
    end
  end
end