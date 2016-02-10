------------------------------------------------------------------------

layout: post
title: Meta-Programming in Java
—-
I have been looking over my old code repository and I came across GEL (Generated Entity Layer). GEL was a toolkit that allowed me to define entities and events for [HLA (High Level Architecture)](http://en.wikipedia.org/wiki/High_Level_Architecture) using an XML data definition language.

The HLA (High Level Architecture) is a family of specifications developed to promote intereoperability and reuse of simulation assets. Unfortunately there is a significant development effort associated with construction of a HLA-compliant federation. Less than 2% of the 2500+ lines of code in the “Hello World” sample HLA application relates to simulation logic. The integration code is a significant cost and there is often a high-level of coupling between the simulation code and the integration code.

GEL (Generated Entity Layer) was created to simplify HLA (High Level Architecture) developers task by generating all the integration code from a simulation model defined in an XML document. The HLA developer had the sole responsibility of writing the simulation/logic code. Think of GEL as a a poor-mans [MDA](http://en.wikipedia.org/wiki/Model_Driven_Architecture) (I even planned to have a set of separate generators that would allow the simulation objects to be hosted in a Quake3 game). This approach rocks as you only need to fix and update the code in one place (the generator) and you are far more productive at the higher level of abstraction.

Each simulation object in the GEL XML document resulted in the generation of several Java classes by [velocity](http://jakarta.apache.org/velocity/).

-   a `Model` class for holding data of a specific instance.
-   a `ModelListener` class that receives events relating to a `Model` instance.
-   a `HLAPeer` class that reflects the data in a `Model` instance into the HLA runtime.
-   a `PersistPeer` class that persists the data in a `Model` instance.
-   a number of [Value Object](http://www.martinfowler.com/ap2/valueObject.html) classes to represent various events
-   etc…

I had long believed in having a single high-level model of the domain objects and generating. Prior to XML I had used SGML, INI and custom formats to represent the model. On a number of occasions I have attempted to move the model data into the code to make it easier to keep up to date. I have used C/C++’s macro expansions, XDoclet-like processors and Java 1.5 Annotations at various times.

Six months using [Ruby On Rails’](http://www.rubyonrails.org/) has changed my world view. The model classes are very close to the level at which I would create my domain model. The good thing about ruby is that you can always add more language constructs to make sure the code matches your domain model. (I know Lisp-ers have always raved about this but I have never been able to use lisp in a commercial environment). Things like [acts\_as\_list](http://api.rubyonrails.com/classes/ActiveRecord/Acts/List/ClassMethods.html) to order your domain objects, [acts\_as\_versioned](http://ar-versioned.rubyforge.org/) to version your domain objects or [acts\_as\_threaded](http://www.railtie.net/articles/2006/02/05/rails-acts_as_threaded-plugin) to have a threaded tree representation radically simplify the representation of domain objects.

I have been thinking about how I would do this in Java but most of the neat stuff just does not seem possible without the introduction of a [Meta-object Protocol](http://en.wikipedia.org/wiki/Meta-object_protocol) or some sort of load-time class file modification.

Consider a simple simulation object. In ruby I would represent it via

{% highlight ruby %}
class Kettle &lt; Model::Base
shared\_attr :temperature, :float, :resolution =&gt; 1.0, :accuracy =&gt; 1.0
end
{% endhighlight %}

In java there is no simple equivalent. I could just define the model in a class like below. However this would probably need to be instrumented during loading so that the runtime could monitor changes to the shared attribute.

{% highlight java %}
public class Kettle extends BaseModel
{
@SharedAttribute(resolution = 1.0, accuracy = 1.0 )
private float m\_temperature;

public float getTemperature()
{
return m\_temperature;
}

public void setTemperature(final float temperature)
{
m\_temperature = temperature;
}
}
{% endhighlight %}

Instrumentation in whatever form it takes is fairly complex even if you use something like AspectJ that is perfect for this scenario. Much more complex than writing the equivalent acts\_as\_\* plugin.

The above only works when the instrumentation code does not need to add any methods. However if you want a simulation object to support shared events you need to be able to subscribe, unsubscribe and generate these events which means you need the same boilerplate code repeated over and over.

I can not think of anyway to do this in java so I guess it is back to generating the Java classes from a central model file. Pity I think I liked the ruby way better.
