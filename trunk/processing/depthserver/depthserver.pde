/**
 * Shared Drawing Canvas (Server) 
 * by Alexander R. Galloway. 
 * 
 * A server that shares a drawing canvas between two computers. 
 * In order to open a socket connection, a server must select a 
 * port on which to listen for incoming clients and through which 
 * to communicate. Once the socket is established, a client may 
 * connect to the server and send or receive commands and data.
 * Get this program running and then start the Shared Drawing
 * Canvas (Client) program so see how they interact.
 */


import processing.net.*;
import java.io.*;

Server s;
Client c;
String input;
int data[];

int w = 320;
int h = 240;
byte[] pixbytes = new byte[w*h*3];
String imagebase = "C:/Documents and Settings/lucasw/My Documents/own/processing/depthvis3dgrid/frames/grid3d_";
int index = 10000;

void setup() 
{
  size(w, h);
  background(204);
  stroke(0);
  frameRate(5); // Slow it down a little
  s = new Server(this, 12345); // Start a simple server on a port
}

boolean sendimage = false;

void keyPressed() 
{
  if (key == 'a') {
    sendimage = true;
  }   
}

//int count = 0;
//int framecount = 0;

void draw() 
{
  
  if ((s.clientCount > 0) && sendimage) {
    
    String filename = imagebase + index + ".png";
    FileInputStream fstream;
    //println(filename + " ");
    try {
      fstream = new FileInputStream(filename);
    } catch(IOException e) {
      System.err.println("Caught IOException: " 
                        + e.getMessage());
      return;
    }
  
   File imfile = new File(filename);
   int len = (int)imfile.length();
  
   //println("server: index " + index + ", len " + len);
   byte[] buffer = new byte[len];
   
   try {
     fstream.read(buffer);
   } catch(IOException e) {
     System.err.println("Caught IOException: " 
                        + e.getMessage());
      return;
   }
   
   index++;
    
    s.write("IMST");
    s.write(len & 0xFF);
    s.write((len >> 8) & 0xFF);
    s.write((len >> 16) & 0xFF);
    s.write((len >> 24) & 0xFF);
     
    s.write(buffer);
    
    println("server sent " + len + " + " + 8);
    
    sendimage = false;
  }
  
}

