module EemsHelper
  def eems_text_field_tag(prop, value = '', options = {})
    text_field_tag "eem[#{prop.to_s}]", value, options 
  end
end