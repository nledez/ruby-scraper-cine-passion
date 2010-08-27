gem 'hoe', '>=2.0.0'
require 'hoe'

$:.unshift 'lib'
require 'cine_passion'

Hoe.spec 'cine-passion' do
    self.summary        = "Ruby binding for Cine Passion scraper"
    self.description    = "Use Cine Passion scraper http://passion-xbmc.org/scraper-cine-passion-support-francais/ http://passion-xbmc.org/scraper/."
    self.url            = "http://github.com/nledez/ruby-scraper-cine-passion"
    self.author         = "Nicolas Ledez"
    self.email          = "gem.cinepassion@ledez.net"
    self.post_install_message = <<-POST_INSTALL_MESSAGE
#{'*'*50}

  Thank you for installing cine-passion-#{CinePassion::VERSION}

  Please be copy lib/lib/cine_passion_config.rb.sample to lib/cine_passion_config.rb
  And replace APIKEY with your own.

  You can request one here :
  http://passion-xbmc.org/demande-clef-api-api-key-request/

#{'*'*50}
POST_INSTALL_MESSAGE
end

# vim: syntax=ruby
