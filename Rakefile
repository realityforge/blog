require 'fileutils'

task :default => :build

desc 'Build site with Jekyll'
task :build do
  sh 'rm -rf _site'
  jekyll('build')
end

desc 'Start server with --auto'
task :server do
  jekyll('--server --auto')
end

desc 'Start server without --auto'
task :noauto_server do
  jekyll('--server')
end

def jekyll(opts)
  sh 'jekyll ' + opts
end
