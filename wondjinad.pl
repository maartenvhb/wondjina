#!/usr/bin/perl -w
# Wondjina is a PoC of HTTP tunneling using the ETag header
# 2006 Maarten Van Horenbeeck [maarten@daemon.be]

 use IO::Socket;
 use Net::hostent;              
 use MIME::Base64;
 
 $port = 80;                  
 $host = '000.000.000.000';
 $file = 'wondjina.out';
 $size = '1024';

 $server = IO::Socket::INET->new( Proto     => 'tcp',
                                  LocalPort => $port,
				  LocalHost => $host,
                                  Listen    => SOMAXCONN,
                                  Reuse     => 1);
								  
 die "Could not bind to $port on the selected IP" unless $server;
 print "Wondjina server [Web Header Tunneling]\n";
 print "Accepting content on $host port $port and storing in $file\n\n";

 print "Generating $size bytes of semi-random data\n\n";
 my @chars=('a'..'z','0'..'9');
 my $string;
 foreach (1..$size) {
  $string.=$chars[rand @chars];
 };

while ($client = $server->accept()) {
   $client->autoflush(1);

   
   my $request = <$client>;
   my $hostname = <$client>;
   my $etag = <$client>;
   if ($request =~ m|^GET /(.+) HTTP/1.[01]|) {
     open (DATA,">>$file");
     binmode DATA;
     my $document= $1;
     if ($etag =~ m|^If-None-Match: (.+)|) {
	my $tag= $&; chomp($tag); my $newtag= decode_base64($1); print DATA $newtag; print "Processing ",substr($1,1,-2),"\n";};
        print $client "HTTP/1.0 206 Partical Content\nContent-Type: text/html\nCache-Control: no-cache\n";
	print $client $string;
     } 
    else {
     print $client "HTTP/1.0 400 Bad Request\n";
     print $client "Content-Type: text/plain\n\n";
     print $client "Bad Request\n";
   }
   close $client;
   close(DATA);
}
