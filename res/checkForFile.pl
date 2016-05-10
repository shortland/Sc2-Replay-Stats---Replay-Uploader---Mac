#!/usr/bin/perl

open(my $fh, '>', "../data/currentPaths/newList.txt");
print $fh "";
close $fh;

$whoami = `whoami`;
$whoami =~ s/\n//g;

$mainPath = "/Users/$whoami/Library/Application Support/Blizzard/StarCraft II/Accounts/";
$accountsLS = `ls '$mainPath'`;

my @accountsAR = split "\n", $accountsLS;
foreach(@accountsAR)
{
	$accountDIR = $_;
    $res = `ls '${mainPath}$_'`;
    my @fileWithinAcc = split "\n", $res;
    foreach(@fileWithinAcc)
    {
		if(($_ =~ m/1/) || ($_ =~ m/2/))
		{
			$pathing = $accountDIR . "/" . $_;
    		push(@withinAccounts, $pathing);
		}
    }
}

foreach(@withinAccounts)
{
	$replayFolderPath = $_ . "/Replays/Multiplayer/";
	$replayFolderReplays = `ls '${mainPath}$replayFolderPath'`;
	my @replayNames = split "\n", $replayFolderReplays;
	foreach(@replayNames)
	{
		open(my $fh, '>>', "../data/currentPaths/newList.txt");
		print $fh $mainPath.$replayFolderPath.$_."\n";
		close $fh;
	}
}

## gets current wrriten replays
open my $fh, '<', "../data/currentPaths/newList.txt";
chomp(my @currentReplayList = <$fh>);
close $fh;

## gets past written replays
open my $fh, '<', "../data/currentPaths/originalList.txt";
chomp(my @originalReplayList = <$fh>);
close $fh;

## checks for differences (new replay)
@diff{ @originalReplayList }= ();;
push (@newReplays, grep !exists($diff{$_}), @currentReplayList);

foreach(@newReplays)
{
	## upload file
	$timestamp = time;

	my @chars = ("0".."9", "a".."z");
	my $token;
	$token .= $chars[rand @chars] for 1..32;

	open my $fh, '<', "../data/hashkey.txt"; 
	my $hashkey = <$fh>; 
	close $fh;

	$response = `curl -A "Macintosh Apple Auto Upload v1" -v -F Filedata=@"$_" -F timestamp=$time -F token=$token -F hashkey=$hashkey "http://sc2replaystats.com/upload_replay.php"`;
	print $response;

	# update originalList to newList
	open(my $fh, '>>', "../data/currentPaths/originalList.txt");
	print $fh $_."\n";
	close $fh;
}

sleep(120);
`./checkForFile.pl`;
