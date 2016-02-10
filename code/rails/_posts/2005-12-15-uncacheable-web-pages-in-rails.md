--- 
layout: post
title: Uncacheable web pages in Rails
---
In an attempt to ensure that a page is always fetched from
the server I needed to add the following code to my base
controller. Seems to be a bit long-winded but does the job.

{% highlight ruby %}
class ApplicationController &lt; ActionController::Base
before\_filter :force\_no\_cache

private
def force\_no\_cache
\# set modify date to current timestamp
response.headers\[“Last-Modified”\] = CGI::rfc1123\_date(Time.now)

\# set expiry to back in the past
\# (makes us a bad candidate for caching)
response.headers\[“Expires”\] = 0

\# HTTP 1.0 (disable caching)
response.headers\[“Pragma”\] = “no-cache”

\# HTTP 1.1 (disable caching of any kind)
\# HTTP 1.1 ‘pre-check=0, post-check=0’ (IE specific)
response.headers\[“Cache-Control”\] =
“no-cache, no-store, must-revalidate, pre-check=0, post-check=0”

end
{% endhighlight %}
