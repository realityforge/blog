# Author: Toby DiPasquale <toby@cbcg.net>
require 'fileutils'
require 'yaml'

module Jekyll
  module Typo
    # this SQL *should* work for both MySQL and PostgreSQL, but I haven't
    # tested PostgreSQL yet (as of 2008-12-16)
    SQL = <<-EOS
    SELECT c.id id,
           c.title title,
           c.permalink slug,
           c.body body,
           c.created_at date,
           COALESCE(tf.name, 'html') filter,
 COALESCE(Cat.permalink,'.') AS category
      FROM contents c
           LEFT OUTER JOIN text_filters tf
                        ON c.text_filter_id = tf.id
           LEFT JOIN articles_categories AC ON AC.article_id = c.id
           LEFT JOIN categories Cat ON Cat.id = AC.category_id
      WHERE c.type IN ('Page','Article') AND
  NOT ( c.title = 'Scripting Databases' AND Cat.permalink = 'java')
    EOS

    def self.process 
      require '/usr/share/java/postgresql-jdbc3.jar'

      odriver = Java::JavaClass.for_name("org.postgresql.Driver")
      url = "jdbc:postgresql://127.0.0.1/typo"
      puts "About to connect..."
      con = java.sql.DriverManager.getConnection(url,ENV["DB_USER"],ENV["DB_PASS"]);
      if con
        puts " connection good"
      else
        puts " connection failed"
      end
        
      stmtSelect = con.create_statement
      
      # Execute the query
      rsS = stmtSelect.execute_query(SQL)

      # For each row returned do some stuff
      while rsS.next do
        date = rsS.getObject("date")
        name = [ sprintf("%.04d", date.year + 1900),
                 sprintf("%.02d", date.month + 1),
                 sprintf("%.02d", date.day + 1),
                 rsS.getObject("slug") || rsS.getObject("id") ].join('-')
        # Can have more than one text filter in this field, but we just want
        # the first one for this
        name += '.textile'

        dir = "#{rsS.getObject("category")}/_posts"
        FileUtils.mkdir_p dir
       File.open("#{dir}/#{name}", 'w') do |f|

          f.puts({ 'layout'   => 'post',
                   'title'    => rsS.getObject("title").to_s
                 }.delete_if { |k, v| v.nil? || v == '' }.to_yaml)
          f.puts '---'

          body = rsS.getObject("body")
          body = body.delete("\r")
          
          body = body.gsub(/<typo:code lang="ruby">/,"{% highlight ruby %}")
          body = body.gsub(/<typo:code lang="java">/,"{% highlight java %}")
          body = body.gsub(/<\/typo:code>/,"{% endhighlight %}")

          f.puts body
        end
      end
    end

  end   # module Typo
end   # module Jekyll

Jekyll::Typo.process
