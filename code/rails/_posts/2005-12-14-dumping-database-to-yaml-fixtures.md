--- 
layout: post
title: Dumping database to YAML fixtures
---
I finally got fed up with the bugs in Rails 1.0 handling of mysql connections and have decided to move to postgres. I have [talked](/code/2005/12/02/mysql_to_postgres.html) about the move and even migrated my DDL to the database agnostic [schema](http://api.rubyonrails.com/classes/ActiveRecord/Schema.html) language. The one thing I had not yet thought about was how to move my data.

After doing a little bit of [asking](http://www.mail-archive.com/typo-list@rubyforge.org/msg01274.html) and [searching](http://comments.gmane.org/gmane.comp.lang.ruby.rails/28315) I decided to just dump my data out the databse to fixtures and then reload these fixtures. This is surprisingly simple using the rake task.

{% highlight ruby %}
desc ‘Dump a database to yaml fixtures. ’
task :dump\_fixtures =&gt; :environment do
path = ENV\[‘FIXTURE\_DIR’\] || “\#{RAILS\_ROOT}/data”

ActiveRecord::Base.establish\_connection(RAILS\_ENV.to\_sym)
ActiveRecord::Base.connection.
select\_values(‘show tables’).each do |table\_name|
i = 0
File.open(“\#{path}/\#{table\_name}.yml”, ‘wb’) do |file|
file.write ActiveRecord::Base.connection.
select\_all(“SELECT \* FROM \#{table\_name}”).inject({}) { |hash, record|
hash\[“\#{table\_name}\_\#{i += 1}”\] = record
hash
}.to\_yaml
end
end
end

desc “Reset Database data to that in fixtures that were dumped”
task :load\_dumped\_fixtures =&gt; :environment do
require ‘active\_record/fixtures’
ActiveRecord::Base.establish\_connection(RAILS\_ENV.to\_sym)
path = ENV\[‘FIXTURE\_DIR’\] || “\#{RAILS\_ROOT}/data”
Dir.glob(“\#{path}/\*.{yml}”).each do |fixture\_file|
Fixtures.create\_fixtures(path, File.basename(fixture\_file, ‘.\*’))
end
end
{% endhighlight %}

This is Mysql specific due to the use of
<code>select\_values(‘show tables’)</code> but apparently sqlite usues <code>select\_values(‘.table’)</code> and postgres uses the following.

{% highlight sql %}
select\_values(&lt;&lt;-end\_sql
SELECT c.relname
FROM pg\_class c
LEFT JOIN pg\_roles r ON r.oid = c.relowner
LEFT JOIN pg\_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN (‘r’,‘’)
AND n.nspname IN (’myappschema’, ‘public’)
AND pg\_table\_is\_visible(c.oid)
end\_sql
{% endhighlight %}

This worked like a charm except when my data contained embedded ERB directives because when rails loads the fixtures it attempts to evaluate the fixture as an ERB script. In this scenario I just needed to nip into the <code>read\_fixture\_files</code> method in <code>$RUBY\_HOME\\activerecord-1.13.2\\lib\\active\_record\\fixtures.rb</code>
and comment out the erb rendering while I imported my data.

**Update:** The code for this can be found is available in [dump\_fixtures.rake](/files/dump_fixtures.rake)
