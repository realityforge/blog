--- 
layout: post
title: Typo Category feed
---
I did not realize that my blog was subscribed over at [JavaBlogs.com](http://www.javablogs.com) so when I wrote my recent entry on [AAA in rails](/code/rails/2005/11/12/aaa_in_rails.html) I was surprised to get a comment like this [one](/code/rails/2005/11/12/aaa_in_rails.html#comment-2) and despite the tone he did have a point. I should not have it subscribed at java blogs. The version of [Typo](http://typo.leetsoft.com/trac/) I am using did not seem to support category based rss feeds. So I did a quick google for answers and found that [others](http://www.eric-stewart.com/blog/articles/2005/06/03/tweakin-typo) had added support this and it had even landed on the [issue tracker](http://typo.leetsoft.com/trac.cgi/ticket/22) . So I had a quick browse and decided it was easier to write myself and added a route and a quick hack to <code>app/controllers/xml\_controller.rb</code> from

{% highlight ruby %}
def rss
@articles = Article.find(:all, :conditions =&gt; ‘published=1’,
:order =&gt; ‘created\_at DESC’,
:limit =&gt; config\[:limit\_rss\_display\])
end
{% endhighlight %}

to

{% highlight ruby %}
def rss
joins = nil
conditions = ‘published=1’
if params\[:category\]
conditions = \[‘published = 1 AND categories.name = ? AND
articles\_categories.article\_id = articles.id AND
articles\_categories.category\_id = categories.id’,
params\[:category\] \]
joins = ‘, categories, articles\_categories’
end
@articles = Article.find(:all,
:select =&gt; ‘articles.\*’,
:conditions =&gt; conditions,
:joins =&gt; joins,
:order =&gt; ‘created\_at DESC’,
:limit =&gt; config\[:limit\_rss\_display\])
end
{% endhighlight %}

And it took me less than 15 minutes which includes time to go and make a coffee. Now that is why I have come to like rails. I may have been able to do the same in another framework but chances are I would have had to guess the table names, file locations, foreign keys etc. With rails I don’t really have to think if the app follows the conventions.
