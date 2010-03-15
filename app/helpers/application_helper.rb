require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def application_name
    return 'EEMs'
  end
  def render_document_heading
    '<h1>' + document_heading.to_s + '</h1>'
  end
end
