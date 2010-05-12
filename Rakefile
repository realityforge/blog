require 'fileutils'
require 'net/http'

FEED_DIR="#{File.dirname(__FILE__)}/_feeds"
SMUGMUG_FILE_NAME="#{FEED_DIR}/smugmug.atom"
SMUGMUG_FEED_URL="http://bluemeanie.smugmug.com/hack/feed.mg?Type=nickname&Data=bluemeanie&format=atom10"

task :default => :build

desc 'Download feeds integrated into site'
task :download_feeds do
  FileUtils.mkdir_p FEED_DIR
  File.open(SMUGMUG_FILE_NAME, 'w') do |f|
    puts "Retrieving smugmug feed\n"
    f.write Net::HTTP.get(URI.parse(SMUGMUG_FEED_URL))
  end
end

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
