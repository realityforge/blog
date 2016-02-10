require 'fileutils'

task :default => :build

desc 'Build site with Jekyll'
task :build do
  sh 'rm -rf _site'
  sh 'jekyll build'
end

desc 'Start server with --watch'
task :server do
  sh 'jekyll serve --watch'
end

desc 'Start server without --watch'
task :noauto_server do
  sh 'jekyll serve'
end

task :convert_textile_to_markdown do
  require 'tempfile'
  files = Dir["#{File.dirname(__FILE__)}/**/*.textile"]

  files.each do |filename|
    target_filename = "#{File.join(File.dirname(filename), File.basename(filename, '.textile'))}.md"
    File.delete("#{target_filename}.src.textile") if File.exist?("#{target_filename}.src.textile")
    File.delete("#{target_filename}.md") if File.exist?("#{target_filename}.md")
    File.delete(target_filename) if File.exist?(target_filename)
  end

  files = Dir["#{File.dirname(__FILE__)}/**/*.textile"]
  files.each do |filename|
    target_filename = "#{File.join(File.dirname(filename), File.basename(filename, '.textile'))}.md"

    puts "Converting #{filename} to #{target_filename}"

    textile = IO.read(filename)

    header = ''
    textile.gsub(/^(---[^-]+---\n)/s) { header = $1 }

    File.open("#{target_filename}.src.textile",'wb') do |f|
      f.write textile[header.size,textile.size]
    end

    command = [
        'pandoc',
        '--wrap=preserve',
        '--smart',
        '-f',
        'textile',
        '-t',
        'markdown_github',
        "#{target_filename}.src.textile",
        '-o',
        target_filename,
    ]
    system(*command) or raise 'pandoc failed'

    File.delete("#{target_filename}.src.textile")

    new_markup = header + IO.read(target_filename)

    File.open(target_filename,'wb') do |f|
      f.write new_markup
    end

    system('git','rm', '-f', filename)
    system('git','add', target_filename)
  end
end
