--- 
layout: post
title: Proxy to Lighttpd for Rails apps
---
Over the last few weeks I have been looking at what is required
to deploy rails applications in an environment with a peak load
of about 30 requests a second but with an average rate of 1 request
per second.

I am running Apache and initially I was hesitant to try [fastscgi](http://www.fastcgi.com/) due to the horror stories that
I read about on the rails mailing list. I initially tried
[mod\_ruby](http://www.modruby.net/en/) but it was not speedy and it
consumed large chunks of memory. I assume this was due to to the ruby
interpreter being added to each process.

Next I migrated to fastcgi which was not anywhere near as painful
as I had heard. I followed the directions in [Apache tuning for Rails
and FastCGI](http://scottstuff.net/blog/articles/2005/07/20/apache-tuning-for-rails-and-fastcgi)
and I had it up and running in no time. Very occasionally I am seeing
fastcgi processes that are left alive after a web server reload. Apparently [Lighttpd](http://www.lighttpd.net/) does not have this problem but I need
to stick with Apache2 because of applications running on the server.

I want to try an approach that I read about on the rails mailing list that involves proxying requests to Lighttpd from Apache2 using configuration like the following. This would then allow me to run a separate Lighttpd on to handle the rail requests.



        ServerName napts.realityforge.org
        ProxyPass / http://napts.realityforge.org:8080/
        ProxyPassReverse / http://napts.realityforge.org:8080/

I also noticed an easy way to host multiple rails applications on one hostname. Previously I had created a new hostname for each rails application ala napts.realityforge.org, iplan.realityforge.org, etc.



        ServerName realityforge.org
        ProxyPass /napts/ http://realityforge.org:8080/
        ProxyPassReverse /napts/ http://realityforge.org:8080/

And then in my rails application I need to add the following to my environment.rb

{% highlight ruby %}
ActionController::AbstractRequest.relative\_url\_root = “/napts”
{% endhighlight %}

Pretty neat! and it clears up many of my remaining issues with rails.
