require 'rcov/rcovtask'
require 'rake/rdoctask'
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('cine-passion', '0.5.0') do |p|
    p.description    = "Use Cine Passion scraper http://passion-xbmc.org/scraper-cine-passion-support-francais/ http://passion-xbmc.org/scraper/."
    p.url            = "http://github.com/nledez/ruby-scraper-cine-passion"
    p.author         = "Nicolas Ledez"
    p.email          = "gem.cinepassion@ledez.net"
    p.ignore_pattern = ["tmp/*", "script/*"]
    p.development_dependencies = []
end

task :default => [:rcov]

desc "RCov"
Rcov::RcovTask.new do | t |
    t.test_files = FileList[ 'test/test_*.rb' ]
    t.rcov_opts << '--exclude /gems/,/Library/,/usr/,spec,lib/tasks'
end

Rake::RDocTask.new do | t |
    t.rdoc_files.include("lib/*.rb", "README.rdoc")
    t.main = "README.rdoc"
    t.title = "Documentation"
end
