------------------------------------------------------------------------

layout: post
title: Distributed Case-Based Reasoning using Java
—-
Over the next few months I will be investing some time into a research project focusing on distributed [case-base reasoning](http://en.wikipedia.org/wiki/Case-based_reasoning). The idea is to establish an [ad-hoc network](http://en.wikipedia.org/wiki/Mobile_ad-hoc_network) of nodes that each have a separate case-base. When a node attempts to find a solution to a problem it will query both it’s local case-base and case-bases of connected nodes to determine the solution.

The exact algorithms that the solver uses to select nodes to query will have a significant impact on the speed and accuracy with which a solution can be found. The maintainece of the distributed cases-bases via case addition or removal will also need to be addressed in our research.

I will be working on an existing codebase but I have been looking around to see if I can find any free or opensource java case-base reasoning software. Something that I can tack a distribution layer on top of but I have been unable to find any products that are not commercial software and/or under highly restrictive licenses. I wonder if this is an area that just does not appeal to FOSS developers?
