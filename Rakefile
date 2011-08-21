require 'fileutils'
require 'net/http'
require 'rexml/document'

BASE_DIR=File.dirname(__FILE__)
FEED_DIR="#{BASE_DIR}/_feeds"
SMUGMUG_FILE_NAME="#{FEED_DIR}/smugmug.atom"
SMUGMUG_FEED_URL="http://bluemeanie.smugmug.com/hack/feed.mg?Type=nickname&Data=bluemeanie&format=atom10"

task :default => :build

desc 'Download feeds integrated into site'
task :download_feeds do
  FileUtils.mkdir_p File.dirname(SMUGMUG_FILE_NAME)
  File.open(SMUGMUG_FILE_NAME, 'w') do |f|
    puts "Retrieving smugmug feed\n"
    f.write Net::HTTP.get(URI.parse(SMUGMUG_FEED_URL))
  end
end

desc 'Transform feeds into pages/includes on the site'
task :transform_feeds do

  count = 4
  File.open("#{BASE_DIR}/_includes/smugmug.html", 'w') do |f|
    puts "Converting smugmug feed\n"
    f.write("<table style=\"width: 100%; padding: 0; margin: 0\" class=\"galleryfeed\">\n<tr>\n")
    REXML::Document.new(IO.read(SMUGMUG_FILE_NAME)).elements.each('feed/entry') do |e|
      if count > 0
        #title = e.elements['title'].text
        #link = e.elements['link'].attributes["href"]
        #content = e.elements['content'].text
        e.elements['content'].text =~ /<\/p><p>(<a href=\".*\/><\/a>)<\/p>/
        html_link = $1
        #puts "Title: #{title} Link: #{link} Content: #{$1}"
        f.write "<td style=\"width: 25%;\">\n<div style=\"text-align: center;\">\n#{html_link}</div>\n</td>\n"
        count = count - 1
      end
    end

    f.write("</tr>\n</table>\n")
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

desc 'Start server without --auto'
task :noauto_server do
  jekyll('--server')
end

desc 'Rebuild and deploy'
task :deploy do
  task(:download_feeds).invoke
  task(:transform_feeds).invoke
  task(:quick_deploy).invoke
end

desc 'Deploy without retrieving remote resources first'
task :quick_deploy do
  task(:build).invoke
  copy '.htaccess', '_site/.htaccess'
  sh 'rsync -rtzh --progress --delete --exclude "/laptop"  --exclude "/static" _site/ pdonald@realityforge.org:~/www/www.realityforge.org/'
end

def jekyll(opts = '')
  sh 'jekyll ' + opts
end
