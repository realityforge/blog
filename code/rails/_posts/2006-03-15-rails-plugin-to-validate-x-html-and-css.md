--- 
layout: post
title: Rails Plugin to Validate (X)HTML and CSS
---
Here is an enahnced version of [Scott Raymond’s](http://scottraymond.net) [assert\_valid\_markup](http://redgreenblu.com/svn/projects/assert_valid_markup/)
plugin that I use in my projects. Below are the directions for use;

### HowTo Validate (X)HTML

{% highlight ruby %}

1.  Calling the assertion with no parameters validates
2.  whatever is in @request.body, which is automatically
3.  set by the existing get/post/etc helpers. For example:

class FooControllerTest &lt; Test::Unit::TestCase
def test\_bar\_markup
get :bar
assert\_valid\_markup
end
end

1.  Add a string parameter to the assertion to validate
2.  any random fragment. For example:

class FooControllerTest &lt; Test::Unit::TestCase
def test\_bar\_markup
assert\_valid\_markup "

<div>
Hello, world.

</div>
"
end
end

1.  For the ultimate in convenience, use the class-level
2.  method to validate a number of actions in one line.

class FooControllerTest &lt; Test::Unit::TestCase
assert\_valid\_markup :bar, :baz, :qux
end
{% endhighlight %}

### HowTo Validate CSS

{% highlight ruby %}

1.  Pass a string parameter to the assertion to validate
2.  a css fragment. For example:

class FooControllerTest &lt; Test::Unit::TestCase
def test\_bar\_css
filename = “\#{RAILS\_ROOT}/public/stylesheets/bar.css”
assert\_valid\_css(File.open(filename ,‘rb’).read)
end
end

1.  For the ultimate in convenience, use the class-level
2.  method to validate a bunch of css files in one line.
3.  Assumes that the CSS files are relative to
4.  $RAILS\_ROOT/public/stylesheets/ and end with ‘.css’.
5.  The following example validates
6.  $RAILS\_ROOT/public/stylesheets/layout.css,
7.  $RAILS\_ROOT/public/stylesheets/standard.css and
8.  $RAILS\_ROOT/public/stylesheets/theme.css

class FooControllerTest &lt; Test::Unit::TestCase
assert\_valid\_css\_files ‘layout’, ‘standard’, ‘theme’
end
{% endhighlight %}

Most of the credit for this plugin goes to Scott for the initial idea! The modifications that I made include;

-   Validation of CSS files.
-   Caching of fragments occurs in `$RAILS_ROOT/tmp` according to the name of the test class + test method. This avoids filling up the system temp folder with expired cache files.
-   Ability to turn off validation by setting the “NONET” environment variable to “true”.

#### Update 12th of May, 2010

The plugin is now available on GitHub. See the [GitHub project page](http://github.com/realityforge/rails-assert-valid-asset)
