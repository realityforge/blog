--- 
layout: post
title: Optimizing for fun
---
People are the most important factor for a successful software project. OK - that is an over-generalization. A project’s success or failure can be impacted by market realities, developer skill sets, resource availabilities, timing etc. However, happy programmers developing software that they are passionate about are far more likely to produce a larger quantity of high quality work. No where is it more obvious than in Free / Open Source Software (FOSS) projects where developers are typically not paid to work on projects but do so in their own time for fun or self-improvement. Given this it seems obvious that one way to improve the chance for a successful project is to make it fun. (“-Ofun” combines the -O flag that indicates the primary optimization goal in a compiler and indicates it should be fun).

A few years ago I read an [article](#BibBroadwell) that argued that making development fun resulted in an increased velocity of code development *and* an increase in overall code quality. Pugs, the project in question was an implementation of a Perl 6 interpreter in Haskell. A focus on fun combined with a supportive community and low barriers of entry lead to broad committer community with diverse interests and a wide range of skills.

This is not the first time I have read such an opinion. Years before I read an interview with John Carmack, one of the main developers on the Quake game engine, where it was claimed that the short feedback loop between making a change and receiving feedback contributed to the rapid evolution of the Quake code base. Particularly because the feedback was visual. Experiments seemed to be par for the course at iD Software and Carmack often discussed these experiments at conferences, interviews or in his online journal. Some experiments (GLQuake, Quakeworld) were released to the community and the feedback from the broader community drove future development.

Fun is a somewhat subjective term but the strategies below can be used to encourage fun.

Fast feedback
=============

Impediments to early feed back should be removed. It should be possible to make a change and see the effects of the change as fast as possible. Ruby On Rails is a web framework that took this change to heart. The developer modified the source code and then refreshed the web page to see the change. There was no separate deployment or configuration step. Only a limited number of changes actually required the user to restart the web server.

Levity
======

The project should have a general sense of levity about it. Often the example code or documentation will express the personality of the programmers. Python has a spam and eggs theme and a general tendency towards Monty Python humor. Ruby has it’s own distinct feel and [Why’s (poignent) guide to ruby](#BibWhy) is tutorial in comic book form. I am told Perl has a tendency to embrace Tolkein poetry.

Low Barriers of Entry
=====================

There should be low barriers of entry for anyone interested in contributing. One way to achieve this is to use a distributed version control system such as git and allow anyone to fork and evolve the code base with ease. Committer privileges to the primary tree should also be passed out liberally to reduce road blocks for getting code into main line.

There should be decent test coverage so that a developer can quickly assess whether their changes have broken any assumptions in the system. Writing a test is also a good way to get fast feedback on a feature!

Code Talks
==========

Ultimately code talks. So if a developer has an idea encourage them to prototype it and make the source available. The code need not be complete but can just sketch the idea out. If it seems interesting it can be expanded and ultimately may make it back into the mainline development tree.

Bibliography
============

-   <a name="BibBroadwell"></a> Broadwell, Geoff. “*-Ofun*”. Published on Oct. 05, 2005. URL: <http://www.onlamp.com/pub/wlg/7996>. Local Copy: [OFun.html](/code/software-development/OFun.html) (Cached on Dec. 24th, 2008)
-   <a name="BibWhy"></a> Why. “*Why’s (poignent) guide to Ruby*”. URL: <http://poignantguide.net/ruby/>.

