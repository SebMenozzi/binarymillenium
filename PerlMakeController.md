# Introduction #
Code to talk to a [Make controller](http://www.makezine.com/controller/) with Perl and the IO::Socket::INET module.


# Details #

```

#!/usr/bin/perl
# Make controller servo program
# binarymillenium Oct 21 2006

# number of bytes in packets so far seems to also be multiples of 4, so zeros are used after
# the text part of the message to pad out length

use Time::HiRes qw( usleep ualarm gettimeofday tv_interval );
use IO::Socket::INET;

$addr = '192.168.0.200';

# Create a new socket
$MySocket=new IO::Socket::INET->new(PeerPort=>10000,LocalPort=>10000,Proto=>'udp',PeerAddr=>$addr) or die "Can't Bind: $!\n";


#initialize the servos
$finalpart = pack("N",1);
# the last three letters of 'active' -> 'ive', plus the comma and typetag 'i')
$secondpart = pack("NN", 0x69766500,0x2c690000  );
$MySocket->send("/servo/0/act" .$secondpart .$finalpart);
$MySocket->send("/servo/1/act" .$secondpart .$finalpart);

# not really sure if a delay is needed to allow the make controller processing time
usleep(10000);

$servospeed = 1000;
$finalpart = pack("N",int($servospeed));

# the letters 'ed' to spell the last part of 'speed', plus same comma and typetage
$secondpart = pack("NN", 0x65640000,0x2c690000  );
$MySocket->send("/servo/0/spe" .$secondpart . $finalpart);
$MySocket->send("/servo/1/spe" .$secondpart . $finalpart);

usleep(10000);

$pi = 3.14592;
$delay = 50000;

$freq = 2;

$offset = 500; 
$amp = 150;

# make the servos move in sine waves, with second one 90 degrees out of phase
for ($i = 1; $i <2 ; $i++) {
	$t = ($i*(2.0*$delay))/1e6;
	# letter n plus same comma and typetage
	$secondpart = pack("NN",0x6e000000,0x2c690000);

	$firstpart = '/servo/0/positio';
	$pos = $offset + int($amp+$amp*sin($t*$freq*2.0*$pi));
	$finalpos = pack("N", $pos);
	$MySocket->send($firstpart . $secondpart . $finalpos);

	usleep($delay);	

	# add 90 degrees phase delay  (never mind the $delay amount of delay)
	$firstpart = '/servo/1/positio';
	$pos2 = $offset + int($amp+$amp*sin($t*$freq*2.0*$pi + $pi/2.0));
	$finalpos = pack("N", $pos2);
	$MySocket->send($firstpart . $secondpart . $finalpos);
		
	usleep($delay);
}


```