= cine-passion

* http://github.com/nledez/ruby-scraper-cine-passion
* http://rubyforge.org/projects/cine-passion/

== DESCRIPTION:

Cine Passion is a powerfull movies scraper.
This lib allow you to get information about a movie in Ruby without manipulating XML.

If you want try scraper online :
http://passion-xbmc.org/scraper/

If you have any question about this scraper you have a forum :
http://passion-xbmc.org/scraper-cine-passion-support-francais/

== FEATURES/PROBLEMS:

* Extract XML information to build ruby objects

* Does not work actualy for images

== SYNOPSIS:

  FIX (code sample of usage)

== REQUIREMENTS:

In my project, you can't find Cine Passion API Key.

In fact you need a key your own side, you can request one here :
http://passion-xbmc.org/demande-clef-api-api-key-request/

See INSTALL

== INSTALL:

* gem install cine-passion
* cd /lib/to/gem/cine-passion
* cp lib/cine_passion_config.rb.sample lib/cine_passion_config.rb
* edit lib/cine_passion_config.rb # And replace APIKEY

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

* XML Sample files
To start devel on my project I made sample files. You can found them on test/data folder. At this time I have theres :
cinepassion-scraper-test-00-no-response.xml -> No response from scraper
cinepassion-scraper-test-01-one-response.xml -> One result from scraper
cinepassion-scraper-test-02-mutiple-response.xml -> Many result from scraper

In "exploded" directory, I have "translate" files in human readable format (only with indentation ;) ). Do not use there files.

* Demo mode
By default if you not create a lib/cine_passion_config.rb you are in demo mode :
- Query: "noresult" => Return cinepassion-scraper-test-00-no-response.xml
- Query: "Home" => Return cinepassion-scraper-test-01-one-response.xml
- Query: "The Men Who Stare At Goats" => Return cinepassion-scraper-test-02-mutiple-response.xml
- Other query => Random result of above

== LICENSE:

Ruby Licence:
http://www.ruby-lang.org/en/LICENSE.txt
