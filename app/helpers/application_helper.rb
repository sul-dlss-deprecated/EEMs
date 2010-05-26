require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def application_name
    return 'EEMs'
  end

  def render_document_heading
    '<h1>' + document_heading.to_s + '</h1>'
  end
  
  # Get value for a given eem field
  def print_solr_field(name, msg = '') 
    value = eval("@document[:#{name.to_s}]")
    
    if (value.nil? || value.empty?)
      value = msg
    end
    
    return value
  end 


    
end

