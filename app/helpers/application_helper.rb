# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require_dependency 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
  
  def application_name
    'EEMs'
  end

  def render_document_heading
    '<h1>' + document_heading.to_s + '</h1>'
  end
  
  def eem_title_heading
    @document['title_t'].first
  end
    
  # Get value for a given eem field
  def print_solr_field(name, msg = '') 
    value = eval("@document[:#{name.to_s}]")
    
    if (value.nil? || value.empty?)
      value = msg
    end
    
    value
  end 

  def get_facet_display_value(fname, value)
    if (fname == 'language_facet')
      value = get_language_name(value)
    end
    
    value
  end      
  
  def format_search_results_timestamp(timestamp)        
    if !timestamp.nil?
      time = Time.parse(timestamp) 
      return time.strftime("%d-%b-%Y")
    end
        
    return ''    
  end
  
end

