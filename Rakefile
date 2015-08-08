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

desc 'Rebuild and deploy'
task :deploy => [:build] do
  task(:build).invoke
  copy '.htaccess', '_site/.htaccess'
  sh 'rsync -rtzh --progress --delete --exclude "/laptop"  --exclude "/static" _site/ pdonald@realityforge.org:~/www/www.realityforge.org/'
end

def jekyll(opts)
  sh 'jekyll ' + opts
end
