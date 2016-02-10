--- 
layout: post
title: Embarking on a FOSS project
---
When building a Free / OpenSource Software project it is important to [optimize for now](http://www.37signals.com/svn/posts/896-optimize-for-now). If you don’t optimize for now there is no guarantee you get to tomorrow. Limiting today’s solution by tomorrows constraints means you can not fully utilize the strengths of your current situation. This may result in the system failing to meet today’s problems and thus never getting to tomorrow. (i.e. Why design a system for 1,000 users when 10 will do for now? Why design for 1,000,000 users when 1,000 will do?)

For a project to survive without corporate sponsorship you also need to [optimize for fun](/code/software-development/2011/05/15/optimizing-for-fun.html). People program best when they are having fun, when they are under no deadlines, when there is no stress. So heavy weight approaches that increase the gap between action and response should be minimized. This means reducing the amount of boilerplate / “bureaucracy” coding, having simple steps to get started and having a short loop to getting the code included in the mainline.

This may mean having a build server that is constantly online testing changes and applying them if they introduce no new errors. People could submit to the build server against a particular version. If the build and testing loop succeeds it is submitted to some of the core group for inclusion in mainline, otherwise the submitter is informed of the failures.

So no matter what the primary goal of the project, the project may benefit by optimizing for now and optimizing for fun.
