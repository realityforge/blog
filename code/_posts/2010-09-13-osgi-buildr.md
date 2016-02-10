---
layout: post
title: Using Buildr to build an OSGi application
---
Where I work, we have recently had the opportunity to re-asses our technology and move forward with newer and groovier technologies. The code base is 10 years old and has 3717 source files (4012 if you include generated files) or 108,384 LOC (132,282 LOC if you include generated files) in variety of languages spanning java, ruby, sql, server-side javascript, xslt etc. The code base evolved over this period and is littered with a variety of dead different evolutionary trees. One of the majors goals of the next major version of the software is to lower the complexity of building components. Thus enters [Buildr](http://buildr.apache.org/) and [OSGi](http://www.osgi.org/About/Technology).

### Buildr

Buildr is a build system that is a hybrid between [Rake](http://rake.rubyforge.org/) and [Maven](http://maven.apache.org). Buildrs tag line is “Build like you code”. All the build scripts are ruby programs so it is trivial to customize the build process. Like Maven, Buildr is opinionated. If you follow a few conventions you do not have to put as much energy into configuring the build process. Buildr also uses Maven2 style repositories to retrieve dependencies thus reducing a large source of head-aches during the build and configuration process.

A buildfile can be as simple as;

{% highlight ruby %}
define “my-project” do
project.version = “1.0”
project.group = “com.biz”
package :jar
end
{% endhighlight %}

The build process will compile code from the default location `src/main/java` and package th compiled .class files and any resources from the standard location `src/main/resource` in a jar named `my-project-1.0.jar`. Buildr will also compile and run any junit4 tests present in `src/test/java` before building the package.

### OSGi

OSGi is a dynamic module system for Java. The modules, or bundles, are packages of code (both native and .class files) and resources with some associated metadata. Each bundle is loaded in a separate classloader. The bundle can import packages that another bundle exports or all the packages a specific bundle exports. The imports are versioned so a bundle can declare a dependency on a specific version of a package. This allows multiple versions of one library to be hosted by an OSGi framework.

The framework allows you to dynamically install, uninstall, start, stop or update a bundle. The framework is also responsible for ensuring that all the declared dependencies are present before starting the bundle. This allows you to patch and update part of an application on the fly without bringing down the whole application.

The framework also defines a mechanism by which bundles can expose services to other bundles. The services are java objects that registered with the framework. The bundle typically supplies metadata with the service to make it easy for clients to select the correct service. The OSGi specification also defines a suite of “standard” services that are of varing use, depending on the context.

### Bnd

Generating the correct metadata for an OSGi bundle can be complex to say the least. All the imported packages need to be listed as do the versions of the imported packages. Exported packages should list packages that they make use of so that a consistent class space can be constructed. The [Bnd Tool](http://www.aqute.biz/Code/Bnd) takes advantage of the fact that a lot of information can be inferred from the classpath used to compile the .class files placed in the bundle and .class files them selves. The user supplies directives such as the packages and versions to export from the bundle and the bnd tool will construct a bundle with the required metadata. Luckily there is an [extension](http://github.com/realityforge/buildr-bnd) that integrates the bnd tool with buildr.

### The “Hello World” bundle

As is tradition, the first example will simply be a bundle that prints “Hello World![](" on bundle startup and "Goodbye World)” on bundle shutdown. A bundle can specify that an activator be is invoked on bundle startup and shutdown. The java code for the activator follows;

{% highlight java %}
package org.example.helloworld;

import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;

public class Activator implements BundleActivator
{
public void start( final BundleContext bundleContext )
{
System.out.println( “Hello World!” );
}

public void stop( final BundleContext bundleContext )
{
System.out.println( “Goodbye World!” );
}
}
{% endhighlight %}

To build a bundle from this you need to supply the bnd tool with two parameters. The “Bundle-Activator” parameter is copied into the resulting bundle manifest and identifies the class name of the activator. The “Private-Package” directive tells bnd to include .class files in the bundle but not to export them. If this directive is not supplied the bnd tool would be unable to determine which .class files to include in the bundle.

The following `buildfile` demonstrates how to build the bundle using the buildr-bnd extension and download an artifact from a maven 2 repository.

{% highlight ruby %}

1.  Include the buildr-bnd extension
    gem ‘buildr-bnd’, :version =&gt; ‘= 0.0.5’
    require ‘buildr\_bnd’

<!-- -->

1.  The maven2 repository from which dependencies will be downloaded
    repositories.remote &lt;&lt; ‘http://www.ibiblio.org/maven2’

desc ‘Example: Hello World’
define ‘helloworld’ do
project.version = “1.0.0”
project.group = “org.example”

\# Compile the code with the following artifact
compile.with ‘org.apache.felix:org.osgi.core:jar:1.4.0’

package(:bundle).tap do |bnd|
bnd\[‘Private-Package’\] = “org.example.helloworld”
bnd\[‘Bundle-Activator’\] = “org.example.helloworld.Activator”
end
end
{% endhighlight %}

The source for the example can be found at <http://github.com/realityforge/buildr-examples/tree/master/bnd-helloworld/>. To build the project you will need to install ruby or jruby, [buildr](http://buildr.apache.org/) and the [build-bnd](http://github.com/realityforge/buildr-bnd) gem.

### Deploying the bundle

The bundle should deploy into almost any OSGi container or framework. The following steps assume that [Eclipse Equinox 3.6.0](http://download.eclipse.org/equinox/drops/R-3.6-201006080911/download.php?dropFile=org.eclipse.osgi_3.6.0.v20100517.jar) is downloaded and installed.

{% highlight bash %}
$ java -jar org.eclipse.osgi\_3.6.0.v20100517.jar -console

osgi&gt; install file:target/helloworld-1.0.0.jar
Bundle id is 1

osgi&gt; start 1
Hello World!

osgi&gt; stop 1
Goodbye World!

osgi&gt; close
{% endhighlight %}

### Summary

The above example gives you a taste of how easy it is to build a simple bundle using buildr. More complex bundles that export packages or use OSGi component models such as [iPojo](http://felix.apache.org/site/apache-felix-ipojo.html) or declarative services are surprisingly easy to integrate into the build process.
