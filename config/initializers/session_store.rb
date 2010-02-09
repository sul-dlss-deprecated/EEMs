# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eems_session',
  :secret      => '76c46a2952dd0742f2fca22c91fa4a77f598d27af4dde40635f2c9b2c2ceff34223b0afa60b6b4fc14ff099af836febe5479aaac97079b94a86fbf8d36c98416'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
