module EemsHelper
  def eems_text_field_tag(prop)
    text_field_tag("eem[#{prop.to_s}]")
  end
end