require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def application_name
    'EEMs'
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
    
    value
  end 

  def get_facet_display_value(fname, value)
    if (fname == 'language_facet')
      value = get_language_name(value)
    end
    
    value
  end      
  
  def formatSearchResultsTimestamp(timestamp)        
    if !timestamp.nil?
      time = Time.parse(timestamp) 
      return time.strftime("%d-%b-%Y")
    end
        
    return ''    
  end
  
  # link_back_to_catalog(:label=>'Back to Search')
  # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
  # Removed '_query_:"EEM"' from query string (EEMS-146)
  def link_back_to_catalog(opts={:label=>'Back to Search'})
    query_params = session[:search].dup || {}
    query_params.delete :counter
    query_params.delete :total
    link_url = catalog_index_path(query_params)
    link_url = link_url.gsub('_query_%3A%22Eem%22', '') 
    link_to opts[:label], link_url
  end
  
  
end

