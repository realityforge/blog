--- 
layout: post
title: Switch from Mysql to Postgres?
---
Most of my personal applications require a small database that enforces foreign key constraints and has a reasonably standard SQL interface. [Mysql 4.1](http://www.mysql.com) + [Mysql Front](http://www.mysqlfront.de/) have served me well but recently I have been getting the dreaded <code>Lost connection to MySQL server during query</code> error. I believe it is a problem with the drivers I am using but I am still digging to find the cause of the error.

I have contemplated the switch to [Postgres](http://www.postgresql.org/) as my database of choice; It *feels* like a much more mature offering and has far more liberal [license](http://www.postgresql.org/docs/faqs.FAQ.html#item1.3) . I would not miss out on having a nice graphical front end as there is a number available ([PGnJ](http://www.trikenit.com/projects/pgnj) , [pgAdmin](http://www.pgadmin.org/) , [EMS SQL Manager for PostgreSQL](http://www.sqlmanager.net/en/products/postgresql/manager)).

After the initial period of cognitive I expect I will be happy with Postgres so maybe this mysql driver error is the kick I need to finally make the move.
