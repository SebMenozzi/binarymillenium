# Introduction #

This graph has a radio button that captures a single still from a webcam /dev/video0 input.  The frame is added to a buffer and played back to show the animation up to the current image.

Very short video made with it here: http://vimeo.com/343150.

Put this in your graphs directory:
http://binarymillenium.googlecode.com/svn/trunk/gephex_graphs/stopmotioncam
It requires my average gephex module http://bmillenium.sourceforge.net/average.zip or http://binarymillenium.googlecode.com/svn/trunk/gephex_graphs/average.so (maybe it will work for you if your system resembles mine) because I couldn't figure out how to make a pulse with numbers.

Inspired by watching the special features of Robot Chicken and seeing the Lunchbox http://www.animationtoolworks.com/products/lbdv_summ.html in action.

The linux program stopmotion (http://stopmotion.bjoernen.com/) has some interesting features that could be incorporated into the graph, like showing the diff and always appending the current frame, but would be a little tricky.  I can't get it to work on my system with my quickcam or Hauppage WinTV device.

Something else to do:
Make a stand alone hardware device to do this same thing with minimal interface- video in, video out, and capture, and a knob for frame rate.  Could be a small cheap computer inside (<$100?), but an FPGA solution would be interesting- Spartan3 with analog input module could probably do it in black & white, maybe lower resolution than 640x480.

# Workflow #

I haven't tried a long animation yet, but I imagine that this is only a preview device, not something to capture the production animation with.  The workflow would be to have a high quality camera with a video out connected to the preview capture device, hit capture on the preview device, watch the preview animation, then take a real picture with the camera.  Later the high resolution images will be downloaded and assembled and the preview animation can be left to be copied over.

There may be non-gephex ways to hook up a camera with usb, and instantly download the full quality image and put it into an animation (with gphoto or just a script to ls the external camera and look for new images), but probably more software development intensive.

# Details #

What I'd like to be able to do:
  * save each new frame to disk to prevent loss of frames when current buffer fills - an image (png or jpeg) output plugin with a separate buffer sharing same trigger.
  * Count the number of captured frames and adjust playback rate if less than size of buffer
  * A better way to deliver a pulse than the image delay hack