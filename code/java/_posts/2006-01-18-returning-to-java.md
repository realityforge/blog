--- 
layout: post
title: Returning to Java
---
Over the last year I have wandered away from the Java programming language and experimented with different languages. Over the last six months I have had little contact with java programming except for occasionally helping out a student. However most of my time has been spent reading, teaching and programming in other languages such as [Ruby](http://www.ruby-lang.org/en/) (via [Ruby On Rails](http://www.rubyonrails.org/)), [Prolog](http://www.swi-prolog.org/), [Erlang](http://www.erlang.org/) and a dash of eLisp and Scheme.

I have just returned to working with Java and I find it lacking. Some of the features that java lacks do not really fit with Javas philosophy such as “open” classes. Why java does not support the richness of rubys collection classes is beyond me.

### Open Classes

Ruby has the ability to re-open classes and add, remove and rename methods that have already been defined. At times this has been a lifesaver as I could re-open a class that was defined by a framework and fix bugs without having to keep a separate branch for all my dependencies.

This feature also allowed me to ensure that my code worked across different versions of libraries. For example the [Struct](http://www.rubycentral.com/ref/ref_c_struct.html) class differs betweem Ruby 1.8.2 and Ruby 1.8.3 in the way that it handles symbols with ‘?’ but I was able to re-open the class and make the behaviour consistent. I have also been able to fix many rails variations and bugs between versions so that my code would work out of the box.

I don’t think this is a feature that Java or any statically typed language should support but it is useful none the less.

### Collection Classes

Ruby also has an amazingly nice set of collection classes. While it is true that the classes may include a lot of cruft, I really like the four search methods defined in [Enumerable](http://www.rubycentral.com/ref/ref_m_enumerable.html) ; select/find\_all, detect/find, reject, and collect/map. (select is aliased to find\_all or vice versa as is detect and find, and collect and map). I believe they were originally derived from Smalltalks collection classes and it is a pity they did not find their way into java.

Consider doing something like iterating through a unordered list of 3D vertexes and any in front of the plane are placed in a new list but transformed via a matrix associated with the plane.

{% highlight ruby %}
results = my\_vertexes.select {|v| v.in\_front?(my\_plane) }.
collect {|v| v.transform(my\_matrix)}
{% endhighlight %}

While the equivelent java code is something like

{% highlight java %}
LinkedList<Vertex> tempList = new LinkedList<Vertex>()
for( Vertex v : myVertexes )
{
if( v.isInFront(myPlane) )
{
tempList.add( v );
}
}
LinkedList<Vertex> results = new LinkedList<Vertex>()
for( Vertex v : tempList )
{
tempList.add( v.transform(myMatrix) );
}
{% endhighlight %}

I suspect that both code snippets could be improved but they are only meant to demonstrate a point. Namely that ruby code tends to support the common case with a far shorter syntax and IMHO smaller cognitive load than equivelent code in java. My guess is that java would make it much easier to optimize the code for speed but that is rarely the most important feature of software.

### Conclusion

While I am remembering that there is things I miss about java there is also things that I wish java had. I am finding it difficult to live without rubys “blocks” but still looking forward to hacking on java again.
