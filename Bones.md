# Introduction #

The idea here was to make a very quick demonstration of bones animation, without out doing any research into other implementations.

Other implementations may be implemented as free software but they require the use of not very free 3D animation software in order to create the animation files.  As far as I know there is no fast and easy open source tool for making an animation or taking a mesh and assigning weights and bones to vertices and so forth.

So my first pass here is not that kind of tool - instead it just generates a random set of bones and animates them with perlin noise.  The complexity of the model comes not from those uniform meshes but the random arrangement and branching of them.

Instead of a single mesh (which would be harder to generate randomly), I'm using a hierarchy of uniform meshes.  Each is rotated around 2-3 axes with standard osg::PositionAttitudeTransforms but I manipulate the vertex geometry manually in software (could be done in the GPU I suppose).  Each vertice is assigned a weight based on the distance it is from the root of the bone, so there is no complex multi-bone weighting.




# Details #

http://binarymillenium.googlecode.com/svn/trunk/bones/

![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-10.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-10.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-11.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-11.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-12.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-12.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-5.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-5.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-6.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-6.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-7.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-7.jpg)
![http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-9.jpg](http://binarymillenium.googlecode.com/svn/trunk/bones/screenshots/Screenshot-9.jpg)

