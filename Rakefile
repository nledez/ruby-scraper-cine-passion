require 'rcov/rcovtask'

task :default => [:rcov]

desc "RCov"
Rcov::RcovTask.new do | t |
    t.test_files = FileList[ 'test/test_*.rb' ]
    t.rcov_opts << '--exclude /gems/,/Library/,/usr/,spec,lib/tasks'
end
