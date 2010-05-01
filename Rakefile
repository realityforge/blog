# Adopted from Scott Kyle's Rakefile
# http://github.com/appden/appden.github.com/blob/master/Rakefile

task :default => :build

desc 'Build site with Jekyll'
task :build do
  jekyll
end

desc 'Start server with --auto'
task :server do
  jekyll('--server --auto')
end

desc 'Build and deploy'
task :deploy => :build do
  # TODO: Update url to be www.realityforge.org when it goes live
  sh 'rsync -rtzh --progress --delete --exclude "/static" _site/ pdonald@superbhosting.stocksoftware.com.au:~/www/www.realityforge.org/'
end

def jekyll(opts = '')
  sh 'rm -rf _site'
  sh 'ruby /var/lib/gems/1.8/gems/jekyll-0.5.7/bin/jekyll ' + opts
end