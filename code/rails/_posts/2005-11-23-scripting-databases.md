--- 
layout: post
title: Scripting Databases
---
I have always considered [data modeling](http://www.agiledata.org/essays/dataModeling101.html) as the one of the most critical aspects of software development. A well designed data model can outlive the specific software product it was designed for and provide a valuable asset to the organization. In the ideal scenario the data model will [evolve](http://www.agiledata.org/essays/evolutionaryDevelopment.html) and [adapt](http://www.martinfowler.com/articles/evodb.html) with the organization as requirements change.

However, as a software developer I have rarely worked in an environment where I needed a deep understanding of any particular vendors database implementation. Recently I have been developing database-centric software on a number of different platforms. It may be that I am missing something but I have yet to find a decent database centric scripting language.

Consider the following problem that I was tackling a month ago. We have a central database server and application server to access the database. Database writes **MUST** occur through the application server to maintain data integrity due to limitations at our software layer. We also support distributed servers that can periodically synchronize with the central server. The synchronization process requires heavy use of buisness logic to detect and resolve conflicts in synchronized data. Some data may also come from other external systems such as personal or payroll. This data needs to be cleaned and converted into our schema before being synchronized with the central server.

I was tasked with automating the synchronization from an external system to our central server. I also needed to have a test run through the synchronization prior to the real run to stop the process if synchronization would fail. This involved the following steps

1.  Import, convert and clean the data from external database into INCOMING database
2.  Backup INCOMING database
3.  Backup CENTRAL database
4.  Restore CENTRAL database into TEST database
5.  Run synchronization between INCOMING and TEST. This involves;
    1.  Startup TEST application
    2.  Start INCOMING application and initiate synchronization with TEST
    3.  Shutdow TEST application

6.  If synchronization in previous step was successful then synchronize between INCOMING and CENTRAL servers. This involves;
    1.  Start INCOMING server and initiate synchronization with CENTRAL

7.  Backup CENTRAL database

At each step along the way we need to log information about progress into another database as the process can take several hours. If an error occurs we need to inform appropriate party.

I ended up implementing this as a stored procedure in Microsoft SQL Server. This is not without it’s problems. For starters it is tied to a specific vendors database server (and possibly a specific database server version). Secondly there is a large number of ugly code hacks. To execute external processes in SQL Server you need to create a job with the command then start the job. Then I poll a system table every 10 seconds until the job has completed using [GOTO’s](http://www.acm.org/classics/oct95/) .

If that was not bad enough, I needed to come up with a mechanism to log progress messages to a different database. My problem was that if an error occured during a number of the steps a transaction roll back was issued which reverted all the log messages. The only way I could find to get around this was to open another connection to SQL Server using the [SQL-DMO](http://www.sqlteam.com/item.asp?ItemID=9093) COM object. The COM object only used to write log entries and as it was a different connection it would not be rolled back when the main transaction rolled back. **ugly**![]()

These uglies occur when I was just automating the process. When you get down to the data manipulation and synchronization it gets even less appealing. The code to extract data from the external database and clean it prior to putting it into INCOMING is contained within

-   an xml document defining transformation rules
-   auxilliary SQL scripts to support non-standard rules
-   a look-up-table in another database

The code to synchronize the data between multiple applications is placed within

-   another xml document defining consistancy rules
-   custom java code to support non-standard rules

It is not a pretty sight.

Admittedly if the system was to be rewritten from scratch the whole process would probably be a lot cleaner. But even then, I was skeptical that there was a *nice* way to implement this. The software would need to be able to define a domain model with rules that contain both imperative/procedural (ie java or some other imperative language) and declarative elements (ie sql and some data constraint language).

Previously I had thought that the best path to tackle this problem was to use some sort of [Domain Specific Language](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html) to define the declarative aspects of the data model and then define the procedural elements using a language like Java. I have used this approach with success before. I defined the static model characteristerics and data constraints in an XML document and then used [Velocity](http://jakarta.apache.org/velocity/) to generate the java code that was enhanced with procedural elements.

Recently I have been playing with [Ruby on Rails](http://www.rubyonrails.org/) and I have been re-evaluating my position. Rails has the [ActiveRecord](http://ar.rubyonrails.com/) library that allows you to define model classes (using the [Active Record pattern](http://www.martinfowler.com/eaaCatalog/activeRecord.html) as described by Martin Fowler). These model classes can define [validations](http://ar.rubyonrails.com/classes/ActiveRecord/Validations.html) that offer a psuedo-constraint language for the data. It also offers support for defining [associations](http://ar.rubyonrails.com/classes/ActiveRecord/Associations/ClassMethods.html), and [aggregations](http://ar.rubyonrails.com/classes/ActiveRecord/Aggregations/ClassMethods.html) between different active record elements and is generally a nice and easy toolkit to use to access relational data. If you need to escape to SQL for performance or conceptual reasons then that is [possible](http://api.rubyonrails.com/classes/ActiveRecord/Base.html#M000691) with few hassles.

Even more recently I discovered [migrations](http://jamis.jamisbuck.org/code/rails/2005/09/27/getting-started-with-activerecord-migrations) in rails that make it possible to incrementally modify your database schema as your application evolves. You can add or remove columns, tables, indexes etc all the while preserving and migrating data as per application requirements. To upgrade to the latest schema you need only run the “migrate” rake task and be done with it.

This makes rails or more specifically ActiveRecord a very strong contender for my toolkit of choice to script database It would make it possible to avoid vendor specific stored procedures or SQL, to a certain degree and make it much easier to develop software to manipulate schemas and data.

The only negative is that it is in ruby and I have a greater understanding of the java language. Then again maybe ruby does not require the breadth of understanding java does - ir is much simpler to just get stuff done.

Maybe ruby is the next java.
