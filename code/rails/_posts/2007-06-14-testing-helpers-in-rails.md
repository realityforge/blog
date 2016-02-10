--- 
layout: post
title: Testing Helpers in Rails
---
It can be useful at times to unit test helpers to make sure they generate correct html. It is not obvious how to do this at first. So far I have been testing my helper by defining a class “MyClass” at the top of my unit test and including all the appropriate modules. I also need to define a url\_for method if I ever want to test helpers that generate links.

The code follows (Replace MyHelper with your appropriate helper class);

{% highlight ruby %}
class MyClass
include ERB::Util
include ActionView::Helpers::TagHelper
include ActionView::Helpers::UrlHelper
include MyHelper

def url\_for(options)
ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
generated\_path, extra\_keys = ActionController::Routing::Routes.generate\_extras(options, {})
generated\_path
end
end
{% endhighlight %}

Then in my tests I do something like;

{% highlight ruby %}
def test\_revision\_link
assert\_equal(
“&lt;a href=\\”http://svn.sourceforge.net/viewvc/jikesrvm?view=rev&amp;revision=22\\“&gt;22</a>”,
MyClass.new.revision\_link(22))
end
{% endhighlight %}

Seems easy enough to do in retrospect but things usually do.
