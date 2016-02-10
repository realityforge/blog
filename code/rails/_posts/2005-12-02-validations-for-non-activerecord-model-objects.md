------------------------------------------------------------------------

layout: post
title: Validations for non-ActiveRecord Model Objects
—-
Rails provides support for validating form input if the form is backed by an ActiveRecord. The application I am currently working on has a form that has a large number of input parameters but is not persisted to the database. I still wanted to use the ActiveRecord [Validations](http://api.rubyonrails.com/classes/ActiveRecord/Validations.html) as they make my life easier but I did not know if there was an simple way to do this.

Initially I created a dummy table in the database with just an id field and made my model object sub-class ActiveRecord. I could then use the validations with all the fields I had defined using <code>attr\_accessor</code>. This looked something like;

{% highlight ruby %}
class Search &lt; ActiveRecord::Base

attr\_accessor :user\_name, :email, :locator

validates\_length\_of :user\_name,
:within =&gt; 6..20,
:too\_long =&gt; “pick a shorter name”,
:too\_short =&gt; “pick a longer name”
validates\_format\_of :email,
:with =&gt; /^(\[^`\s]+)`((?:\[-a-z0-9\]*\\.)*\[a-z\]{2,})$/i
validates\_numericality\_of :locator
…
end
{% endhighlight %}

In my controller I created the Search object in the same way that I created all the other model objects but I never called save. Instead I called the <code>valid?</code> method to check whether the model passed all the validations. If the model is not valid the <code>@search.errors</code> object is populated with all the errors.

{% highlight ruby %}
class NavigatorController &lt; ApplicationController

def search
`search = Search.new(params[:search])
    if `search.valid?
…
end
end
…
end
{% endhighlight %}

Of course this left a bad taste in my mouth as it is a seriously ugly hack that requires an empty table in the database just to get form validation working. So I began to look at what I needed to do to implement an **ActiveForm** object. I was not looking forward to this task as I had read on the rails mailing list that the Validations were intermingled with ActiveRecord::Base and difficult to untangle.

This could not be further from the truth. The first thing I did was create a new ActiveForm class and <code>include ActiveRecord::Validations</code>. This caused a few errors as the ActiveRecord::Validations class attempts to call alias\_method for methods that do not exist in ActiveForm. I implement these methods (save and update\_attribute) so that they raise a NotImplementedError exception. Then I attempt to call the <code>valid?</code> method but it calls the <code>new\_record?</code> method which I implement to return true. To view the errors in the view using the standard helper methods I need to implement the human\_attribute\_name method. These changes seem to get basic validations working.

The only validations that are not working are <code>validates\_uniqueness\_of</code> and <code>validates\_numericality\_of</code>. <code>validates\_uniqueness\_of</code> is not expected to work as it accesses the database so I just make it raise a NotImplementedError exception. <code>validates\_numericality\_of</code>
does not work as it relies on a method named “\#{attr\_name}\_before\_type\_cast” for each attribute named “attr\_name”. This is an artifact of the type coercion that ActiveRecord performs on input parameters. ActiveRecord will convert an input parameter from a string to an integer if the underlying database record stores the field as an integer. As this does not occur with ActiveForm I just duplicated the method and replaced “\#{attr\_name}\_before\_type\_cast” with “\#{attr\_name}”.

The only functionality that ActiveForm was missing was the ability to create a model object from a hash. As ActiveForm does not need to do any type coercion this is as simple as

{% highlight ruby %}
def initialize(attributes = nil)
if attributes
attributes.each do |key,value|
send(key.to\_s + ‘=’, value)
end
end
yield self if block\_given?
end
{% endhighlight %}

At this stage ActiveForm is in a usable state and it took less than 20 minutes. It only took that long because I needed to restart webrick for each change (not to mention the fact that I had never looked at ActiveRecord before). Isn’t ruby/rails great?

To get this working grab the [active\_form.rb](/files/active_form.rb) file and place it in the app/models directory. You can then make your model objects extend ActiveForm and use them like regular ActiveRecord objects.

I cleaned up a few warts of ActiveForm like overriding methods you should not be calling (save![](, save_with_validation, create), validate\_on\_create, validate\_on\_update). I hope to get motivated enough to send a patch that enables this style of functionality in the core once edge rails is working for me again.

**Update:**

It seems there is already a [HowTo](http://wiki.rubyonrails.com/rails/pages/HowToUseValidationsWithoutExtendingActiveRecord) on the rails wiki that describes a similar technique. However rather than duplicating <code>validates\_numericality\_of</code> they handle the calls to “\#{attr\_name}\_before\_type\_cast” by implementing a [method\_missing](http://www.rubycentral.com/ref/ref_c_object.html#method_missing) method which I incorporated to cleanup my code.

**Update on 12th Dec 2005**

Today I decided that I needed to add reloading of ActiveForm subclasses and this is done with the following code chunk.

{% highlight ruby %}
require ‘dispatcher’
class Dispatcher
class &lt;&lt; self
if ! method\_defined?(:form\_original\_reset\_application![]() 
      alias :form_original_reset_application) :reset\_application!
def reset\_application!
form\_original\_reset\_application!
Dependencies.remove\_subclasses\_for(ActiveForm) if defined?(ActiveForm)
end
end
end
end
{% endhighlight %}

#### Update 12th of May, 2010

The plugin is now available on GitHub. See the [GitHub project page](http://github.com/realityforge/rails-active-form)
