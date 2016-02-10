---
layout: post
title: HTML 5 Canvas Sheet Fire Effect
---

&lt;center&gt;
{% include sheetFireCanvas.html %}
&lt;/center&gt;

I had a few hours to kill last Saturday so I was looking to try out some neat little programming hack … possibly in a new programming language. I settled on playing with the HTML 5 Canvas component in javascript.

Initially I built the traditional "Hello World![](" program of the graphics world ... the Starfield effect) I was working on a 2d canvas but projecting from a 3D particle system. The maths are relatively easy to get right even if you are out of practice. However this was too easy and I grew bored even though I did create a fireworks system that looked pretty.

I decided to move onto pixel based simulation and that is when I remembered the sheet fire effect as above. I used to love putting the effect in assembly demos back in the day. It is a simple system where each pixel is assigned a *heat*. The heat of a pixel is a function of the average heat of the surrounding pixels in the previous time frame with more weight given to the pixels below the current pixel. The heat decays each time step. (i.e. heat rises and dissipates over time). The bottom row of pixels has randomly generated heat. The heat value is then mapped to a pixel value. In the example above I used a linear mapping between heat and intensity of the red color. A more interesting mapping could map heat values to a spectrum of colors such as red ~~&gt; yellow~~&gt; blue -&gt; white.

While it was interesting to spend a few hours learning about the canvas component, I have decided that I really dislike javascript as a language. It has the significant advantage that it is ubiquitous and every Joe can almost be guaranteed to have it installed but as a developer the experience is somewhat lacking. Even with all the fancy debugging plugins provided with FireFox it was less than fun. I really felt the lack of static typing which is not something I have felt even in languages like Ruby.

I put the sheet fire effect on one of the http [error pages](/errors/forbidden.html) so that I don’t lose it. It will be interesting to see if the javascript still runs in a year or two or if it rots as the HTML 5 standard evolves.
