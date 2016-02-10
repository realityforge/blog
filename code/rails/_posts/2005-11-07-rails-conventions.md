--- 
layout: post
title: Rails Conventions
---
As I have been hacking away at Ruby On Rails I have found a number of conventions to make things easier to hack on software. The following is a list of various conventions I have adopted.

Coding style
------------

-   Two spaces, no tabs
-   Blocks use { } if its a one liner, otherwise use do … end
-   Surround equal signs with spaces, <code>`myvar = 'foo'</code>, not <code>`myvar=‘foo’</code>
-   Surround hash assignments with spaces, <code>:foo =&gt; ‘bar’</code>, not <code>:foo=&gt;‘bar’</code>
-   <code>Class.method(my\_arg)</code> — not <code>method( my\_arg )</code> or <code>method my\_arg</code>

Derived from Typos [code conventions](http://typo.leetsoft.com/trac/wiki/CodingStyle)

config/databases.yml
--------------------

-   **config/databases.yml**: Should NOT store the <code>config/database.yml</code> in source control. Instead store <code>config/database.yml.example</code> and make users copy the file to <code>config/database.yml</code>. Add <code>config/database.yml</code> into ignore list as appropriate for source control system (svn:ignore, .cvsignore etc) to avoid being warned about non-source controlled file.
-   **db/create.VENDOR.sql**: Store creation scripts for the database in separate SQL files.

Standard Flash Usage
--------------------

Place messages in the flash according to the following conventions

-   \* :notice\* for positive feedback. eg. “User successfully updated.”
-   \* :message\* for neutral feedback. eg. “User has 3 grace logins remaining.”
-   \* :warning\* for negative feedback. eg. “User does not exist or password does not match.”

The view would then present this information in the following manner


      <% for name in FLASH_[:notice, :warning, :message] %>
        <% if flash[name] %>
          <%= "#{flash[name]}" %>
        <% end %>
      <% end %>

Derived from the email thread [RFC: Standardising flash usage amongst Rails applications & generators](http://thread.gmane.org/gmane.comp.lang.ruby.rails/28104)
