--- 
layout: post
title: MMTk Tutorial
---
I was a little stressed earlier on today so I decided to relax by doing some coding and I have yet to really play down in the guts of MMTk so I decided to have a look at the tutorial. The tutorial available from the [website](http://jikesrvm.org/MMTk) is a little out of date but relatively easy to follow even if you have little knowledge about garbage collection literature. MMTk is designed to provide automatic memory management for different languages in different environments. Initially some of the abstractions within the toolkit seem somewhat academic but when viewed in this context it makes much more sense.

For example, *ObjectReference* is used to refer to the client objects that MMTk is managing. Tasks (i.e. [processes](http://en.wikipedia.org/wiki/Process_%28computing%29) , [threads](http://en.wikipedia.org/wiki/Thread_%28computer_science%29) and [fibers](http://en.wikipedia.org/wiki/Fiber_%28computer_science%29) ) are not directly represented but the data required for those entities are represented by *CollectorContext* and *MutatorContext*. In gc literature a *collector* is the task responsible for identifying and reclaiming the space used by client objects when they are no longer live. The *collector* is for most parts a virtual machine managed entity that is triggered by various events. The *mutators* are the tasks representing application functionality and generally responsible for allocating client objects.

At the current time, in the Jikes RVM the VM\_Processor are both collectors and mutators at various times. This is enforced by MM\_ProcessorContext that includes both the CollectorContext and MutatorContext classes. MM\_ProcessorContext extends the mutator, rather than composes the mutator as the information in the MutatorContext is used very frequently. Every allocation needs to access mutator specific methods. By extending it rather than composing it the methods can be accessed directly rather than indirectly. This increases performance but I have never actually evaluated how much of an impact this has.

In VMs that use native threads I would expect that mutators would be separate threads from collectors. In a StopTheWorld plan the collector threads would likely sit idle until a collection is triggered and all the mutator threads became idle. The mutator threads would most likely need to get to a gc safe location. GC safe locations are easy to do within the RVM’s green threads but more “interesting” in native threads I would hazard to guess.

Another trick that MMTk uses to improve performance is to separate out operations on global resources vs collector local resources or mutator local resources. For example, each mutator is likely to grab a block of memory from a global resource (synchronized) and allocate from that block (unsynchronized) until the local block runs out, at which point it would access the global resource again.

The tutorial predates the separation of CollectorContext from MutatorContext (previously it seems to have been combined in a single PlanLocal class). Once I figured that out it was relatively easy to translate the tutorials instructions into the new MMTk. Especially if you peek at some of the other classes in MMTk plan sub-packages.

I think my next little experiment will be decorating objects with some before and after data. In theory it should be relatively easy and I guess I could look at refcount plans for hints - I assume they have to store data around the object.

Anyhoo - I wonder if anyone else finds it relaxing to muck about coding up a garbage collector ? :)
