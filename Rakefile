# Adopted from Scott Kyle's Rakefile
# http://github.com/appden/appden.github.com/blob/master/Rakefile

task :default => :build

desc 'Build site with Jekyll'
task :build do
  sh 'rm -rf _site'
  jekyll
end

desc 'Start server with --auto'
task :server do
  jekyll('--server --auto')
end

desc 'Build and deploy'
task :deploy => :build do
  sh 'rsync -rtzh --progress --delete --exclude "/laptop"  --exclude "/static" _site/ pdonald@realityforge.org:~/www/www.realityforge.org/'
end

def jekyll(opts = '')
  sh 'ruby /var/lib/gems/1.8/gems/jekyll-0.5.7/bin/jekyll ' + opts
end
