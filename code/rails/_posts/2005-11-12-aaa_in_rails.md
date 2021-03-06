--- 
layout: post
title: Authentication, Authorization, Auditing in Rails
---
It is interesting to watch how the “login” discussion on the [Rails Mailing List](http://thread.gmane.org/gmane.comp.lang.ruby.rails/) evolves. There is an abundance of choice for developers who want to integrate login functionality into a rails application. A sample selection;

-   [LoginGenerator](http://wiki.rubyonrails.com/rails/pages/LoginGenerator)
-   [SaltedHashLoginGenerator](http://wiki.rubyonrails.org/rails/pages/SaltedHashLoginGenerator)
-   [Auth Generator](http://penso.info/rails/auth_generator/)
-   [Model Security](http://perens.com/FreeSoftware/ModelSecurity/Tutorial.html)
-   [LoginEngine](http://rails-engines.rubyforge.org/rdoc/login_engine/)
-   [ActiveRBAC](https://rbaconrails.turingstudio.com/trac/wiki)
-   [LoginGeneratorACLSystem](http://wiki.rubyonrails.com/rails/pages/LoginGeneratorACLSystem)
-   [AccessControlList](http://wiki.rubyonrails.com/rails/pages/AccessControlListExample)
-   [Extensible Authorization for Rails](http://randomoracle.org/2005/09/24/extensible-authorisation-for-rails)

My current project requires “login” functionality so I thought I would have a look at some of these projects to see what they offered and to see how easy it would be to integrate one of the existing software products. To my dismay I found that all of them seemed to try and do too much of one thing or not enough of another. Now I think I am begining to understand why rails does not consider these components worthy of core or [not evil but distracting](http://weblog.rubyonrails.com/articles/2005/11/11/why-engines-and-components-are-not-evil-but-distracting) .

All of the systems seem to mix different concerns in the one system. What I would like to see is the ability to separate out authentication from authorization. In the software I am currently developing users do not register for an account but must be explicitly added and passwords must not be stored in clear text. Next month I will be helping to develop a system where each user authentication attempt is delegated to an external system, if the user authenticates then a user account is created if it does not exist. If all goes well I will be developing another system about March next year that uses HTTP authentication.

However in each of these applications there will need to be a very similar concept of authorization. Each application will have a fixed set of parameterizable permissions, roles/groups that are granted these permissions and linkage between users and roles/groups. All of the solutions that I looked at seem to lump too much functionality together. If only they had separated out the pieces into smaller reusable chunks then I would be jumping at the chance to reuse them. As it stands it looks like I am going to end up reinventing the wheel as it is just less work.
