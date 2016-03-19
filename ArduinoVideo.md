# Introduction #

So video actually isn't that hard to generate with the arduino given a few resistors and testing.  The most important thing is to generate 242 lines of consistent length near 62.625us or so with 5 us of that time being SYNC (0 volts) pulses, the rest varying from 0.3-1.0V to represent black to white colors, with a few microseconds of 0.3V black voltage before and after the sync.  After that there should be 20 lines all at the SYNC OV voltage for a vertical sync.

I noticed if the sync is a little too long or too short the upper part of the screen curves oer to the right or left - it looks like macrovision protection.

http://binarymillenium.googlecode.com/svn/trunk/arduino/videontsc/

# Details #

The first thing I did was generate a test pattern, then generate random pixels and scrolling them in a loop.  The interesting thing is that every change to the code will probably screw up the video a little- big changes may screw it up a lot.  With small changes it's easy to tune the different delays so the video comes back into sync, one has to get a feel for the amount of time the code takes to execute (dissassembling the object code may provide more clues also, though I haven't tried that yet).

# Pictures #

Here's some video, illustrating incorrect timing also:
http://vimeo.com/288344

I'll try to get pictures up.  The video show very crisply on a regular tv, but a WinTV USB device did not accept it at all and a Canopus Twinpact captured it only in a flickery way.  Next I'll try a Canon DV camera that has video in and see if it can record it/format it into firewire.


# Sources #

Arduino pong, this was in PAL and doesn't explain a few things.
http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1187659197

The following talk about RS170/A b&w video, and are sometimes contradictory- is the VSYNC inverted 3 pulses surrounded by standard horizontal lines with normal sync pulses?  Either one seems to sort of work, but the best thing to do is what arduino pong does and just have 20 horizontal line periods that are all at the SYNC voltage- and then use a subset of that time to update the graphics output.

TV Paint EE assignment:
http://www.stanford.edu/class/ee281/handouts/lab4.pdf

Atmel Video Generation:
http://instruct1.cit.cornell.edu/courses/ee476/video/
