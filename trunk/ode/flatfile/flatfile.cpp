/*************************************************************************
 *                                                                       *
 * Open Dynamics Engine, Copyright (C) 2001,2002 Russell L. Smith.       *
 * All rights reserved.  Email: russ@q12.org   Web: www.q12.org          *
 *                                                                       *
 * This library is free software; you can redistribute it and/or         *
 * modify it under the terms of EITHER:                                  *
 *   (1) The GNU Lesser General Public License as published by the Free  *
 *       Software Foundation; either version 2.1 of the License, or (at  *
 *       your option) any later version. The text of the GNU Lesser      *
 *       General Public License is included with this library in the     *
 *       file LICENSE.TXT.                                               *
 *   (2) The BSD-style license that is included with this library in     *
 *       the file LICENSE-BSD.TXT.                                       *
 *                                                                       *
 * This library is distributed in the hope that it will be useful,       *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the files    *
 * LICENSE.TXT and LICENSE-BSD.TXT for more details.                     *
 *                                                                       *
 *************************************************************************/

/* exercise the C interface */

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>

#include "ode/ode.h"
#include "drawstuff/drawstuff.h"
#include "texturepath.h"

#include "utility.h"

#ifdef _MSC_VER
#pragma warning(disable:4244 4305)  // for VC++, no precision loss complaints
#endif

/* select correct drawing functions */

#ifdef dDOUBLE
#define dsDrawBox dsDrawBoxD
#define dsDrawSphere dsDrawSphereD
#define dsDrawCylinder dsDrawCylinderD
#define dsDrawCapsule dsDrawCapsuleD
#endif


/* some constants */

#define NUM 10			/* number of boxes */
#define SIDE (0.2)		/* side length of a box */
#define MASS (1.0)		/* mass of a box */
#define RADIUS (0.1732f)	/* sphere radius */


/* dynamics and collision objects */

static dWorldID world;
static dSpaceID space;
static dJointGroupID contactgroup;

/* this is called by dSpaceCollide when two objects in space are
 * potentially colliding.
 */

static void nearCallback (void *data, dGeomID o1, dGeomID o2)
{
  /* exit without doing anything if the two bodies are connected by a joint */
  dBodyID b1,b2;
  dContact contact;

  b1 = dGeomGetBody(o1);
  b2 = dGeomGetBody(o2);
  if (b1 && b2 && dAreConnected (b1,b2)) return;

  contact.surface.mode = 0;
  contact.surface.mu = 0.1;
  contact.surface.mu2 = 0;
  if (dCollide (o1,o2,1,&contact.geom,sizeof(dContactGeom))) {
    dJointID c = dJointCreateContact (world,contactgroup,&contact);
    dJointAttach (c,b1,b2);
  }
}


/* start simulation - set viewpoint */

static void start()
{
  static float xyz[3] = {2.1640f,-1.3079f,1.7600f};
  static float hpr[3] = {125.5000f,-17.0000f,0.0000f};

  dAllocateODEDataForThread(dAllocateMaskAll);
  dsSetViewpoint (xyz,hpr);
}


/* simulation loop */

static void simLoop (int pause)
{
  int i;
  if (!pause) {
    static double angle = 0;
    angle += 0.05;
    //dBodyAddForce (body[NUM-1],0,0,1.5*(sin(angle)+1.0));

    dSpaceCollide (space,0,&nearCallback);
    dWorldStep (world,0.05);

    /* remove all contact joints */
    dJointGroupEmpty (contactgroup);
  }

  dsSetColor (1,1,0);
  dsSetTexture (DS_WOOD);
  //for (i=0; i<NUM; i++) dsDrawSphere (dBodyGetPosition(body[i]),
  //				      dBodyGetRotation(body[i]),RADIUS);
}

struct odePart {
  int id;
  dGeomID geom;
  dBodyID body;
};

std::vector<odePart> allParts;

int main (int argc, char **argv)
{
  int i;
  dReal k;
  dMass m;

  /* setup pointers to drawstuff callback functions */
  dsFunctions fn;
  fn.version = DS_VERSION;
  fn.start = &start;
  fn.step = &simLoop;
  fn.command = 0;
  fn.stop = 0;
  fn.path_to_textures = DRAWSTUFF_TEXTURE_PATH;

  
  std::ifstream parts("odespec.txt");
  if (!parts) {
    std::cerr << "file not found " << std::endl;
    return -1;
  }

  /* create world */
  dInitODE2(0);
  world = dWorldCreate();
  space = dHashSpaceCreate (0);
  contactgroup = dJointGroupCreate (1000000);
  dWorldSetGravity (world,0,0,-0.5);
  dCreatePlane (space,0,0,1,0);


  std::string lines;
  while (getline(parts,lines)) {
      //cout << lines << "\n";
      vector<string> tokens = tokenize(tokenize(tokenize(lines,"\t"),"\n"),"\r");

      if ((tokens.size() >0)
              && (tokens[0].size() >0)
              && (tokens[0][0] != '#')
              && (tokens[0][0] != ' ')) {

      if (tokens[0] == "body") {
        if (tokens.size() == 8) {
          odePart newPart;       
          newPart.id = atoi(tokens[1].c_str());
          newPart.body = dBodyCreate(world);
          dBodySetPosition(newBody, atof(tokens[2].c_str()), atof(tokens[3].c_str()), atof(tokens[4].c_str()));
          dBodySetBox(&m, 1,  atof(tokens[5].c_str()), atof(tokens[6].c_str()), atof(tokens[7].c_str()));
          dMassAdjust(&m, atof(tokens[8].c_str()));
          newPart.geom = dCreateBox(space, atof(tokens[5].c_str()), atof(tokens[6].c_str()), atof(tokens[7].c_str()));
          dGeomSetBody(newPart.body, newPart.geom);
          allParts.push_back(newPart);
        }
      } // body

      if (tokens[0] == "joint") {
        dJointId newJoint = dJointCreateBall(world,0);
        dBodyId body1 = allParts[atoi(tokens[1])].body;
        dBodyId body2 = allParts[atoi(tokens[2])].body;
        dJointAttach(newJoint, body1, body2 );
        dJointSetBallAnchor(newJoint, atof(tokens[3]), atof(tokens[4]), atof(tokens[5]) );
      } //body

    } // tokens
  } // getline

  /* run simulation */
  dsSimulationLoop (argc,argv,352,288,&fn);

  dJointGroupDestroy (contactgroup);
  dSpaceDestroy (space);
  dWorldDestroy (world);
  dCloseODE();
  return 0;
}
