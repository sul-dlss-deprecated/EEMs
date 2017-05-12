# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

FEDORA_URL = 'https://***REMOVED***@dor-test.stanford.edu/fedora'
module LyberCore
  CERT_FILE = File.join(RAILS_ROOT, "config", "certs", "etd-test.crt")
  KEY_FILE = File.join(RAILS_ROOT, "config", "certs", "etd-test.key")
  KEY_PASS = ***REMOVED***
end

module Fedora
  class Connection
    CERT_FILE = LyberCore::CERT_FILE
    KEY_FILE = LyberCore::KEY_FILE
    KEY_PASS = LyberCore::KEY_PASS
  end
end

WIDGET_NAME = 'Test EEMs Widget'
WIDGET_SUFFIX = '-test'

module Sulair
  WORKSPACE_URL = 'https://eems-test.stanford.edu/workspace'
end

module Dor
  MINT_SURI_IDS = true
  SURI_URL = 'https://lyberservices-test.stanford.edu'
  ID_NAMESPACE = 'druid'
  SURI_USER = ***REMOVED***
  SURI_PASSWORD = ***REMOVED***

  CREATE_WORKFLOW = true
  WF_URI = 'http://lyberservices-test.stanford.edu/workflow'
  DOR_SERVICES_URI = 'https://***REMOVED***@sul-lyberservices-test.stanford.edu/dor'
end
