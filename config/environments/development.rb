# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

FEDORA_URL = 'http://***REMOVED***@127.0.0.1:8080/fedora'
WIDGET_NAME = 'Dev EEMs Widget'

module Sulair
  WORKSPACE_URL = 'http://localhost:3000/workspace'
end

module Dor
  MINT_SURI_IDS = true
  SURI_URL = 'http://lyberservices-dev.stanford.edu:8080'
  ID_NAMESPACE = 'druid'
  SURI_USER = ***REMOVED***
  SURI_PASSWORD = ***REMOVED***
  
  CREATE_WORKFLOW = false
  WF_URI = 'http://lyberservices-dev.stanford.edu/workflow'
end

# Dor::SuriService::MINT_SURI_IDS = true
# Dor::SuriService::SURI_URL = 'http://lyberservices-dev.stanford.edu:8080'
# Dor::SuriService::ID_NAMESPACE = 'druid'
# Dor::SuriService::SURI_USER = ***REMOVED***
# Dor::SuriService::SURI_PASSWORD = ***REMOVED***