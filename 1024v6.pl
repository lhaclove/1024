#!C:/perl/bin/perl.exe
use strict;
#use warnings;
use LWP;
use LWP::Simple;
use HTML::TreeBuilder;
use HTTP::Request;
my @html;
my @names;
my @want;
my @images;
my %hash;
my $pageSta= $ARGV[0];
my $pageEnd = $ARGV[1];
#define the field of the 1024
my $url="http://cl.bearhk.info/thread0806.php?fid=16&search=&page=";

#define the homepage
my $page="http://cl.bearhk.info/";
#define the store location
my $stroe="d:\\1024";
my @mHtml;
#analysis the page, and get the post link of the first page
for(my $NO = $pageSta; $NO<=$pageEnd; $NO++){
	my $url = $url.$NO;
	my $done = 0; 
	#print $url;
	my $wanted=&bro($url);
	while($wanted=~/(htm_data\/16\/1511.*?html)/g){ 
		push @html,$1;
		}
	#unique the array of post
	@html = grep { ++$hash{$_} < 2 } @html; 
	my $n=@html;
	#save all the pic of each post
	foreach my $i (@html){ 
	$done++;
	print "processing  ",$i,"(",$done,"/",$n,")\n";  
	my @indexa = split(/\//, $i);
	my $index=@indexa[3];
	my $allindex = $stroe."/index.html"; 
		open IND,">>","$allindex";
		 print IND '<a href="',$index,'/index.html">',$index,'</a><br>';
		 close IND;
		 &getlink($i);
		}

}	
	
#sub for pic save and make index.html
sub getlink{
	my @names = split(/\//, $_[0]);
	my $folder=$stroe."\\".$names[3]; #creat folder for each post
#if the dir for save pic exists then save the next post
#else make the dir for pic save
	if(-e $folder){
		next;
	} 
	mkdir("$folder")||die "can not creat"; 
	my $outhtml = $folder."\\index.html";
	open OUT,">>","$outhtml";
	print OUT "<html><body><br>";
	my $imglink=$page.$_[0];
	print $outhtml,"\n";
#get all the url of pics
	my $post=&bro($imglink);
	while($post=~/input src='(.*?)' type='image'/g){
		if( $1!~/viidii/){
			push @images,$1;
		}
		@images = grep { ++$hash{$_} < 2 } @images;
#save pic
		foreach my $image(@images){
			$image=~/.*\/(.*?\.jpg|.*?\.jpeg|.*?\.png)/g;
			my $filename=$1;
			getstore($image,$folder."\\".$filename);
			print "saved  ",$folder."\\".$filename,"\n";
			print OUT  "<br>";
			print OUT  "<img src='",$filename,"' type='image'>";
			print OUT  "<br>";
		}
	}
	print OUT  "<br>";
	print OUT  "</html>";
	print OUT  "</body>";
	close OUT;
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


# sub generateHTML{
# my @link = @_;
# my $htmlfile = $_[0],
# open 
# print OUT "<html>";
# print OUT "<body>";
# print OUT "<br>";
# foreach my $link(@link){
# print OUT  "<br>";
# print OUT  "<img src='",$link,"' type='image'>";
# print OUT  "<br>";
# }
# print OUT  "<br>";
# print OUT  "</html>";
# print OUT  "</body>";



# }