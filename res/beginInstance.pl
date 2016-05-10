#!/usr/bin/perl

open(my $fh, '>', "../data/currentPaths/originalList.txt");
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
    	# only update array if folders have 1 or 2 in name
		if(($_ =~ m/1/) || ($_ =~ m/2/))
		{
			$pathing = $accountDIR . "/" . $_;
    		push(@withinAccounts, $pathing);
		}
    }
}

foreach(@withinAccounts)
{
	#print "$_\r\n";
	# full path to replay folder
	$replayFolderPath = $_ . "/Replays/Multiplayer/";
	$replayFolderReplays = `ls '${mainPath}$replayFolderPath'`;
	my @replayNames = split "\n", $replayFolderReplays;
	foreach(@replayNames)
	{
		open(my $fh, '>>', "../data/currentPaths/originalList.txt");
		print $fh $mainPath.$replayFolderPath.$_."\n";
		close $fh;
	}
}
## execute recurring checker
`./checkForFile.pl`;