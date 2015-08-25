use strict;
use warnings;
use LWP;
use LWP::Simple;
use HTML::TreeBuilder;
use HTTP::Request;
use HTTP::Headers;
use HTTP::Cookies;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError); 
my @html;
my @want;
my @bt;
my %hash;
###set the values for run.
###url indicate the first page
my $url="http://cl.bearhk.info/thread0806.php?fid=2";
my $page="http://cl.bearhk.info/";
my $rurl="http://www.rmdown.com/link.php?hash=";
my $durl="http://www.rmdown.com/download.php";
my $stroe="e:\\1025bt\\";
###start gether links of each post
my $wanted=&bro($url);
#print $wanted;
while($wanted=~/(htm_data\/2\/1508.*?html)/g){ #get the post link of the first page
	push @html,$1;
	}

###unique the array
@html = grep { ++$hash{$_} < 2 } @html; 
foreach my $i(@html){
print "processing  ",$i,"\n"; 
sleep(5);
&getlink($i);
#&downbt();
}





sub getlink{
	my @values="";
	my @names = split(/\//, $_[0]);
	my $torrentlink=$page.$_[0];
	#print $torrentlink,"\n";
	my $post=&bro($torrentlink);
###get the bt file url of each post
	while($post=~/http:\/\/www.rmdown.com\/link\.php\?hash=([0-9a-z].*?)</g) {
		my $url_req=$rurl.$1;
		print $url_req,"\n";
		my $file=$1.".torrent.gzip";
		if(-e $file){
		next;
		} 
	my $cookie_jar = HTTP::Cookies->new(file => "lwp_cookies.dat", autosave => 1);
	my $browser=LWP::UserAgent->new;
	$browser->agent("Mozilla/5.0 (Windows NT 5.2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.122 Safari/534.30");
	$browser->cookie_jar($cookie_jar);
	my $content=HTTP::Request->new(GET=>"$url_req");
	$cookie_jar->add_cookie_header( $content );
	$content=$browser->request($content) or die("Could not get the URL:$url_req\n");
	$content=$content->as_string;
#print $content;
	while($content=~/value="(.*?)"/g){	
	#print $1,"\n";
	push @values,$1;
	}
	my $ref = <<END;
------WebKitFormBoundaryMBF9fAhK24hYqUlS
Content-Disposition: form-data; name="ref"

END
my $refid=$values[1];
my $reff=<<END;

------WebKitFormBoundaryMBF9fAhK24hYqUlS
Content-Disposition: form-data; name="reff"

END
my $reffid=$values[2];
my $submit=<<END;

------WebKitFormBoundaryMBF9fAhK24hYqUlS
Content-Disposition: form-data; name="submit"

download
------WebKitFormBoundaryMBF9fAhK24hYqUlS--
END
my $data =$ref.$refid.$reff.$reffid.$submit;	
#print $data,"\n";

my %header=(
"Connection"=>"keep-alive",
"Content-Length"=>"385",
"Accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
"Content-Type"=>" multipart/form-data; boundary=----WebKitFormBoundaryMBF9fAhK24hYqUlS",
"DNT"=>"1",
"Referer"=>$url_req,
"Accept-Encoding"=>"gzip, deflate",
"Content"=>$data,
);


my $request = HTTP::Request->new(GET=>"$durl");
$cookie_jar->add_cookie_header( $request );
$request->header(%header);
my $response = $browser->post($durl,%header); 
#$response=$response->as_string;
$response=$response->content;
 open(OUT,">$file");
 binmode(OUT);
 print OUT $response;
 close OUT;		

	}

}

sub bro{
my $url_req=$_[0],
my $browser=LWP::UserAgent->new;
$browser->cookie_jar({});
$browser->agent("Mozilla/5.0 (Windows NT 5.2) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.122 Safari/534.30");
my $content=HTTP::Request->new(GET=>"$url_req");
$content=$browser->request($content) or die("Could not get the URL:$url_req\n");
$content=$content->as_string;
}


