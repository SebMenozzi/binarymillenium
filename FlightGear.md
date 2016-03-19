# Introduction #

I've recently become interested in making an autopilot application that can control a vehicle in flightgear in response to updates of the state of the vehicle.

I may create an interface to Processing that just sends a smaller custom struct with only the information the autopilot should have.  This will be plotted by processing in timecharts, and also saved to file somewhere.  Processing could also host the autopilot.

See this location in svn for the current app:
http://binarymillenium.googlecode.com/svn/trunk/flightgear/

# Details #

Flightgear has an interface that allows sending and receiving of the state of the vehicle being simulated (the FGNetFDM structure) and the position of control surfaces and other things (the FGNetCtrls structure).

What I do is have flightgear send my c++ application both, then modify the contents of the controls structure with new aileron/elevator/rudder positions and send the modified structure back to flightgear.

The fdm structure contains the position and attitude of the vehicle, so using my application one could code up an autopilot that looks at vehicle state and alters the control surfaces in response.

I'm working in Linux right now with flightgear 1.0, my software would probably compile under Windows in Cygwin but I haven't yet tried that.

To set up flightgear to interact with this correctly, it needs to output the native-ctrl to udp on port 5700, input the native-ctrl on port 5600, and output the native-fdm on port 5500 (--native-fdm=socket,out,2, 127.0.0.1, 5500,udp).  The update rates all need to be the same.


# Update #

I've done some more looking and I think there is software similar to this (and maybe more correctly implemented) in the latest flightgear cvs.  One of the reasons that was so hard to find is there are no documents or web pages that explain it, just a few references in the flightgear mailing list.

Check out http://vimeo.com/877752 for a video of my flight control code in use.

# Getting Body Angle Rates #

Things get a little more complicated here, flightgear has to be recompiled in order to get values one would get from gyros on board the vehicle being simulated- P Q & R.

In net\_fdm.hxx, add to the FGNetFDM:

```
    float p;    // radians/sec
    float q;
    float r;
```

In native\_fdm.cxx, add the following to FGProps2NetFDM:

```
    net->p = cur_fdm_state->get_P_body();
    net->q = cur_fdm_state->get_Q_body();
    net->r = cur_fdm_state->get_R_body();

    htonf(net->p);
    htonf(net->q);
    htonf(net->r);
```

And now on the autopilot app side it can get pqr.  Other values that are applicable to aparticular system could be gotten out of flightgear in the same way, assuming they exist already in the fdm.