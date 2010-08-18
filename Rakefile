require 'rcov/rcovtask'
require 'rake/rdoctask'

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
