module EemsHelper

  # Get text field tag for a property
  def eems_text_field_tag(prop, value = '', options = {})
    text_field_tag "eem[#{prop.to_s}]", value, options 
  end

  # Get value for a given eem field
  def print_eems_field(name, msg = '') 
    value = eval("@eem.fields[:#{name.to_s}][:values].first")
    
    if (value.nil? || value.empty?)
      value = msg
    end
    
    return value
  end 

  # Get value for a given eem part field
  def print_parts_field(name, msg = '') 
    value = eval("@parts[0].datastreams['properties'].#{name.to_s}_values.first")
    
    if (value.nil? || value.empty?)
      value = msg
    end
    
    return value
  end 

  
  # Get creator name (value from either creatorOrg or creatorPerson)
  def get_creator_name
    value = ''
    creator_person = @eem.fields[:creatorPerson][:values].first
    creator_org = @eem.fields[:creatorOrg][:values].first
    
    if (!creator_person.nil? && !creator_person.empty?)
      value = creator_person
    end  

    if (!creator_org.nil? && !creator_org.empty?)
      value = creator_org
    end  
    
    return value
  end

  # Get creator type (either 'person' or 'organization')
  def get_creator_type
    value = 'organization'
    creator_person = @eem.fields[:creatorPerson][:values].first
    
    if (!creator_person.nil? && !creator_person.empty?)
      value = 'person'
    end  
    
    return value
  end


  # Get locally saved filename 
  def get_local_filename
    value = ''
    file_url = @parts[0].datastreams['properties'].url_values.first
    
    if (!file_url.nil? && !file_url.empty?)
      value = file_url.split(/\?/).first.split(/\//).last
    end
    
    return value
  end
  
  
  # Get URL to the locally saved filename
  def get_local_file_path 
    value = 'unknown'
    filename = get_local_filename()
    
    if (!filename.empty?)
      value = Sulair::WORKSPACE_URL + '/' + @eem.pid + '/' + filename
    end  
    
    return value
  end

  
  # Get payment fund 
  def get_payment_fund
    value = ''
    payment_status = print_eems_field('paymentStatus')
    
    if (payment_status == 'Paid')
      value = print_eems_field('paymentFund')
    end
    
    return value
  end
    
end