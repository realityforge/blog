--- 
layout: post
title: "Eyelook: Rails photo gallery"
---
Eyelook is a photo gallery I created over a weekend when I was home sick. It is amazing how productive rails can make you because within 8 hours I had the code in place and had set it up on my personal web server.

Very little of that time was spent coding - most of it was spent working on re-arranging the xhtml+css or figuring out how to go about [Loading Binary Data into Rails Fixtures.](/code/rails/2006/04/06/loading-binary-data-into-rails-fixtures.html)

Every eyelook application has a set of users who have a list of albums with pictures. The image data is stored in the database and cached on the filesystem on demand. This way a backup of the database backs up the complete system.

An example of users page that lists galleries is

<center>
[![](/files/album_list_small.jpg)](/files/album_list.jpg)

</center>
You can select one of these galleries and it will bring up a list of images such as

<center>
[![](/files/photo_list_small.jpg)](/files/photo_list.jpg)

</center>
From there you can either download the original or can view a larger lightbox style image

<center>
[![](/files/lightbox_small.jpg)](/files/lightbox.jpg)

</center>
The admin section is not as sexy but it is functional.

#### Update 12th of May, 2010

The subversion repository holding the original version of this has since gone away but the code has been imported into GitHub. See the [GitHub Project Page](http://github.com/realityforge/eyelook) for further details.
