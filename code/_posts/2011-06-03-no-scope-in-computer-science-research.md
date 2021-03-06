---
layout: post
title: No Scope in Computer Science Research
---
Computer Science research seems to be tackling all the wrong problems. Rather than fixing the source we attack the symptoms and we do so with such a rigour that the irrelevance of the solution is often forgotten. Research that attempts to address the source of problems is often considered too broad, too academic or ignoring commercial realities. What is worse is that research that tackles the symptoms is often well funded but completely irrelevant by the time it makes any progress as a change in the underlying computing infrastructure has shifted the symptoms to a different location.

Automatic Memory Management
===========================

Very few people will argue that automatic memory management (AutoMM) is not a vast improvement over manual memory management (ManMM) for most problem sets. In some scenarios AutoMM will have better performance than even highly tuned ManMM but in most cases the simplicity bought using AutoMM has a space or time performance cost.

Most research into AutoMM or garbage collection (GC) as it is more commonly called, focuses on the analysis of memory usage patterns of existing applications in existing runtime environments and adapting or tuning existing approaches. As new languages and problem domains become popular regularly there will always be new tweaks possible. Thus this approach can provide a steady stream of research papers but it is hardly ground breaking stuff.

A more interesting approach to AutoMM research would be to tackle the bigger problems. Rather than reacting to changes, proactively propose future changes to the programming practices to improve GC. I suspect that most existing AutoMM would be inadequate in the face of 1 TiB or 1 PiB of shared memory. If the performance gap between processor speed and memory access latency keeps widening how will this effect GC algorithms? As the number of processors increases in systems, how will this effect GC? Essentially we need to find what changes need to be put in place so that future generations of hardware and software platforms are more amenable to AutoMM.

My understanding is that most GC algorithms will partition the available space into logically separated spaces. Allocations that share common characteristics (e.g. traceability, size, lifetime and locality of reference) will be placed in a common space. A space can be collected if no other space references allocations within the space or the referees can be patched or the spaces of the referees can be simultaneously collected.

Most GC algorithms aimed at SMP systems, have a worst-case scenario that will cause all spaces to be simultaneously collected. This is obviously going to have some serious performance repercussions. To combat this, some approaches will separate the tracing into one phase and incrementally collect/move the allocations over a period of time to reduce the spike in response time. (I am not sure what the correct term is under GC but by response time I mean the time between when an allocation starts and when it completes.) The tracing phase will still take too long if there is a large number of references or the references are not “cache-friendly”. The memory hierarchy of most hardware is designed to work well with locality of reference but most (all?) tracing is not going to have that characteristic[1].

AutoMM research into a 1 PiB shared memory system may not have been addressed in current PL but most probably have been examined within distributed file systems or distributed garbage collection. Solving these problems is almost certainly going to require changes in the programming environment and GC algorithms. Maintaining locality of reference is also likely to have consequences in performance and programming style.

Machines and Instruction Sets
=============================

Now consider the boundary between hardware and compilers; the instruction set architecture (ISA). For all the massive advances in computer architecture we seemed to have been hobbled ourselves with bad ISAs designed for historically interesting domains that no longer exist (The exception seems to be GPUs which are unconstrained by historical choices and typically have drivers that compile from a byte-code to their own instruction set). IA-32 (and IA-32e) show their lineage from a time when people wrote programs in assembly directly and the time where memory access was slow compared to computation. But IA-32 seems to be quite difficult to generate efficient code for (especially as the rules keep changing).

> Just as an aside, to give you an interesting benchmarkon roughly the same system, roughly optimized the same way, a benchmark from 1979 at Xerox PARC runs only 50 times faster today. Moore’s law has given us somewhere between 40,000 and 60,000 times improvement in that time. So there’s approximately a factor of 1,000 in efficiency that has been lost by bad CPU architectures. [2]

CoGenT is one of the more interesting projects relating to this area. In this scenario they model each ISA instruction as having an internal representation (i.e. the bits), an external representation (i.e. assembly) and a semantic interpretation. The hardware such as instruction pipeline, memory hierarchy etc are also modelled abstractly and in theory you can combine the hardware description and ISA description to create a simulator. However - a more interesting proposition is creating the back end of a compiler automagically. You see a compiler essentially represents the code as a semantic tree and CoGenT tries to automagically create a transformer[3] from the compiler semantic tree to the machine semantic tree taking into account machine characteristics and thus predicted performance characteristics[4]. I suspect transforming one tree representation to another while minimizing the cost is one of those NP problems but this does not mean it is a hard NP problem or that a reasonable approximation will not do. (It should be noted that most register allocators are just another tree transformation from abstract registers to real registers that is driven by cost analysis and semantics of registers.)

Interestingly enough the tree transformation approach has been baked into certain programming languages from early on (i.e. the Lisps). The scheme macros (i.e. hygienic) base the transformation on syntax and are not directed by cost analysis but could provide an interesting view. UNCOL demonstrated there is unlikely to be any universal IR but it may be possible to create a universal tree manipulation language. An interesting hardware platform might be to focus on would be one where there is 1000s of cores on a chip[5].

[1] I am not aware of any hierarchical GC schemes that explicitly take into account the memory hierarchy or adjust the algorithm based on memory access speeds. Increasing the locality of reference either by changing the GC algorithm, the programming environment or style would likely give a significant performance boost.

[2] Alan Kay. [A conversation with alan kay](http://queue.acm.org/detail.cfm?id=1039523). In ACM Queue, volume 2. ACM, December/January 2004-2005.

[3] I think from memory it actually outputs a bunch of BURS-like rules which is effectively the same thing.

[4] Now transforming one tree to another based on cost analysis … hmm does this not sound like what most compiler optimization phases do?

[5] Krste Asanovic, Ras Bodik, Bryan Christopher Catanzaro, Joseph James Gebis, Parry Husbands, Kurt Keutzer, David A. Patterson, William Lester Plishker, John Shalf, Samuel Webb Williams, and Katherine A. Yelick. [The landscape of parallel computing research: A view from berkeley](http://www.eecs.berkeley.edu/Pubs/TechRpts/2006/EECS-2006-183.html). Technical Report UCB/EECS-2006-183, EECS Department, University of California, Berkeley, Dec 2006.
