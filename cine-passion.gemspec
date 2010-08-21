# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cine-passion}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nicolas Ledez"]
  s.date = %q{2010-08-21}
  s.description = %q{Use Cine Passion scraper http://passion-xbmc.org/scraper-cine-passion-support-francais/ http://passion-xbmc.org/scraper/.}
  s.email = %q{gem.cinepassion@ledez.net}
  s.extra_rdoc_files = ["README.rdoc", "lib/cine_passion.rb", "lib/cine_passion_config.rb.sample"]
  s.files = ["README.rdoc", "Rakefile", "SuiteTests", "exemple.rb", "html/classes/CinePassion.html", "html/created.rid", "html/files/README_rdoc.html", "html/files/lib/cine_passion_rb.html", "html/fr_class_index.html", "html/fr_file_index.html", "html/fr_method_index.html", "html/index.html", "html/rdoc-style.css", "lib/cine_passion.rb", "lib/cine_passion_config.rb.sample", "scripts/ajouteClasse", "scripts/ajouteFixture", "scripts/creeShoesApp", "test/data/cinepassion-scraper-test-00-no-response.xml", "test/data/cinepassion-scraper-test-01-one-response.xml", "test/data/cinepassion-scraper-test-02-mutiple-response.xml", "test/data/exploded/cinepassion-scraper-test-00-no-response.xml", "test/data/exploded/cinepassion-scraper-test-01-one-response.xml", "test/data/exploded/cinepassion-scraper-test-02-mutiple-response.xml", "test/test_cine_passion.rb", "Manifest", "cine-passion.gemspec"]
  s.homepage = %q{http://github.com/nledez/ruby-scraper-cine-passion}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Cine-passion", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cine-passion}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Use Cine Passion scraper http://passion-xbmc.org/scraper-cine-passion-support-francais/ http://passion-xbmc.org/scraper/.}
  s.test_files = ["test/test_cine_passion.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
