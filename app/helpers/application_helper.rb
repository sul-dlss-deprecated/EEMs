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
    @eem.fields[:title][:values].first
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
  
  # Because title_t is indexed twice, and returned from solr in one comma delimited string
  # We will return the substring of half the string before the comma
  def parse_solr_title_t(title_t)
    title_t[0..title_t.size/2 - 2]
  end

end

