--- 
layout: post
title: Rails Plugin to Help Debug Views
---
The debug\_view\_helper plugin was developed to make it easy to add debug information into your views. It was derived from techniques described in [HowtoDebugViews](http://wiki.rubyonrails.com/rails/pages/HowtoDebugViews) and it makes it possible to expose the followng following debug data;

-   Request Parameters
-   Session Variables
-   Flash Variables
-   Assigned Template Variables

Typically you add code such as the following to the bottom of your layout that exposes the debug button in development mode.

{% highlight ruby %}
&lt;% if RAILS\_ENV == ‘development’ %&gt;

<center>
<button onclick="show_debug_popup(); return false;">
Show debug popup

</button>
</center>
&lt;= debug\_popup&gt;
&lt;% end %&gt;
{% endhighlight %}

—You can grab the plugin from subversion at;—

**Update:** Added the ability to add inline debug information via the following. Suggestion by John Dell.

{% highlight ruby %}
&lt;% if RAILS\_ENV == ‘development’ %&gt;
&lt;= debug\_inline&gt;
&lt;% end %&gt;
{% endhighlight %}

#### Update 12th of May, 2010

The plugin is now moved to GitHub. See the [GitHub project page](http://github.com/realityforge/rails-debug-view-helper)
