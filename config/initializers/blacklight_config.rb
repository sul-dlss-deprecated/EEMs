# You can configure Blacklight from here. 
#   
#   Blacklight.configure(:environment) do |config| end
#   
# :shared (or leave it blank) is used by all environments. 
# You can override a shared key by using that key in a particular
# environment's configuration.
# 
# If you have no configuration beyond :shared for an environment, you
# do not need to call configure() for that envirnoment.
# 
# For specific environments:
# 
#   Blacklight.configure(:test) {}
#   Blacklight.configure(:development) {}
#   Blacklight.configure(:production) {}
# 

Blacklight.configure(:shared) do |config|
  
  # FIXME: is this duplicated below?
  SolrDocument.marc_source_field  = :marc_display
  SolrDocument.marc_format_type   = :marc21
  
  # default params for the SolrDocument.search method
  SolrDocument.default_params[:search] = {
    :qt=>:search,
    :per_page => 10,
    :facets => {:fields=>
      ["format",
        "language_facet",
        "lc_1letter_facet",
        "lc_alpha_facet",
        "lc_b4cutter_facet",
        "language_facet",
        "pub_date",
        "subject_era_facet",
        "subject_geo_facet",
        "subject_topic_facet"]
    }  
  }
  
  # default params for the SolrDocument.find_by_id method
  SolrDocument.default_params[:find_by_id] = {:qt => :document}
  
  
  ##############################
  
  
  config[:default_qt] = "search"
  

  # solr field values given special treatment in the show (single result) view
  config[:show] = {
    :html_title => "title_field",
    :heading => "title_field",
    :display_type => "format"
  }

  # solr fld values given special treatment in the index (search results) view
  config[:index] = {
    :show_link => "title_field",
    :num_per_page => 10,
    :record_display_type => "format"
  }

  # solr fields that will be treated as facets by the blacklight application
  #   The ordering of the field names is the order of the display 
  config[:facet] = {
    :field_names => [
      "selectorName_facet", 
      "status_facet", 
      "paymentType_facet",
      "paymentFund_facet",
      "copyrightStatus_facet",       
      "language_facet",
      "creatorOrg_facet",
      "creatorPerson_facet"
    ],
    :labels => {
      "selectorName_facet" => "Selector", 
      "status_facet" => "Status",
      "paymentType_facet" => "Purchase",
      "paymentFund_facet" => "Fund",
      "copyrightStatus_facet" => "Copyright",
      "language_facet"      => "Language",
      "creatorOrg_facet"    => "Creator (organization)",
      "creatorPerson_facet" => "Creator (person)"
    }
  }

  # solr fields to be displayed in the index (search results) view
  #   The ordering of the field names is the order of the display 
  config[:index_fields] = {
    :field_names => [
      "submitted", 
      "selectorName_field", 
      "copyrightStatus_field",
      "status_field"
    ],
    :labels => {
      "submitted"              => "Date Requested",
      "selectorName_field"     => "Selector", 
      "copyrightStatus_field"  => "Copyright",
      "status_field"           => "Status"
    }
  }

  # solr fields to be displayed in the show (single result) view
  #   The ordering of the field names is the order of the display 
  config[:show_fields] = {
    :field_names => [
      "title_field",
      "sourceUrl_field",
      "language_field", 
      "creatorPerson_field",
      "creatorOrg_field", 
      "url_field", 
      "note_field",
      "copyrightStatus_field", 
      "copyrightStatusDate_field", 
      "paymentType_field",
      "paymentFund_field", 
      "selectorSunetid_field", 
      "id"
    ],
    :labels => {
      "title_field" => "Title",
      "sourceUrl_field" => "Found at this site",
      "language_field" => "Language",
      "creatorPerson_field" => "Creator",
      "creatorOrg_field" => "Creator", 
      "url_field" => "Direct link to PDF", 
      "note_field" => "Citation/Comments", 
      "copyrightStatus_field" => "Copyright", 
      "copyrightStatusDate_field" => "Copyright date", 
      "paymentType_field" => "Purchase", 
      "paymentFund_field" => "Payment fund", 
      "selectorSunetid_field" => "Selector SUNet id", 
      "id" => "Id"
    }
  }

# FIXME: is this now redundant with above?
  # type of raw data in index.  Currently marcxml and marc21 are supported.
  config[:raw_storage_type] = "marc21"
  # name of solr field containing raw data
  config[:raw_storage_field] = "marc_display"

  # "fielded" search configuration. Used by pulldown among other places.
  # For supported keys in hash, see rdoc for Blacklight::SearchFields
  config[:search_fields] ||= []
  config[:search_fields] << {:display_label => 'All Fields', :qt => 'search'}
  config[:search_fields] << {:display_label => 'Title', :qt => 'title_search'}
  config[:search_fields] << {:display_label =>'Author', :qt => 'author_search'}
  config[:search_fields] << {:display_label => 'Subject', :qt=> 'subject_search'}
  
  # "sort results by" select (pulldown)
  # label in pulldown is followed by the name of the SOLR field to sort by and
  # whether the sort is ascending or descending (it must be asc or desc
  # except in the relevancy case).
  # label is key, solr field is value
  config[:sort_fields] ||= []
  config[:sort_fields] << ['relevance', 'score desc, pub_date_sort desc, title_sort asc']
  config[:sort_fields] << ['year', 'pub_date_sort desc, title_sort asc']
  config[:sort_fields] << ['author', 'author_sort asc, title_sort asc']
  config[:sort_fields] << ['title', 'title_sort asc, pub_date_sort desc']
  
  # If there are more than this many search results, no spelling ("did you 
  # mean") suggestion is offered.
  config[:spell_max] = 5
end

