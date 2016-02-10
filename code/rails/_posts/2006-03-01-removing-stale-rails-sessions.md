--- 
layout: post
title: Removing Stale Rails Sessions
---
By default rails does not clear out stale sessions from the session store. To implement this feature I added the following small snippet of code;

{% highlight ruby %}
class SessionCleaner
def self.remove\_stale\_sessions
CGI::Session::ActiveRecordStore::Session.
destroy\_all( \[‘updated\_on &lt;?’, 20.minutes.ago\] )
end
end
{% endhighlight %}

And then invoke the remove\_stale\_sessions method every 10 minutes via;

    */10 * * * * ruby /full/path/to/script/runner 
       -e production "SessionCleaner.remove_stale_sessions"
