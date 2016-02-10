--- 
layout: post
title: Loading Binary Data into Rails Fixtures
---
Loading image data into fixtures was a chore until recently as I had been using separate rake tasks to do the job. The following code demonstrates how easy it is to load binary data such as images into the fixtures via standard mechanisms. It loads some image data from within the `$RAILS_ROOT/test/fixtures/` directory and puts it in database.

{% highlight yaml %}
&lt;%
def fixture\_data(name)
render\_binary(“\#{RAILS\_ROOT}/test/fixtures/\#{name}”)
end

def render\_binary(filename)
data = File.open(filename,‘rb’).read
“!binary | \#{\[data\].pack(‘m’).gsub(/\\n/,”\\n “)}\\n”
end
%&gt;
picture\_data\_1:
id: 1
picture\_id: 1
content\_type: ‘image/jpg’
data: &lt;= fixture\_data(“picture\_data\_1.jpg”)&gt;
picture\_data\_2:
id: 2
picture\_id: 2
content\_type: ‘image/gif’
data: &lt;= fixture\_data(“picture\_data\_2.gif”)&gt;
{% endhighlight %}

If you do not use two spaces as your indent then you will need to alter the line in `render_binary(filename)` that replaces newline so that every newline is replaced with two indents.

Easy peasy!

**Update on 16th April 2006**

It turns out that it was not as easy peasy under postgres as the driver did not know it had to escape the data as binary as fixtures don’t actually load the column type. The simplest hack around it is to add in the following bit of code somewhere that just patches the driver if a 0 is in the data. This may not always work but it works with my test data so that is good enough for me at the moment.

{% highlight ruby %}
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter &lt; ActiveRecord::ConnectionAdapters::AbstractAdapter
def quote(value, column = nil)
if (value.kind\_of?(String) && column && column.type == :binary) || (value.kind\_of?(String) && value.include?(0))
“‘\#{escape\_bytea(value)}’”
else
super
end
end
end
{% endhighlight %}
