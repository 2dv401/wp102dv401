FriendlyId.defaults do |config|
  config.use :reserved    
  # Reserve words in url.
  config.reserved_words = %w(new edit delete destroy img images css js stylesheet stylesheets javascript javascripts admin assets public public_html root)    
end