#!/bin/bash

echo $1

#curl http://192.168.1.57/now.jpg > $1/images/test.jpg
curl http://192.168.1.57/now.jpg?ds=4 > /dev/shm/test.jpg
#$1/arlaser $1/images/test.jpg $1
$1/arlaser /dev/shm/test.jpg $1


