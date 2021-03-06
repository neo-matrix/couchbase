#!/usr/bin/perl
use strict;
use warnings;
## Run this script from the folder that you have downloaded the files from S3
## Donot unzip them. The script will do it.
opendir(DIR,".") or die "Couldn't open dir\n";
my @files = grep("zip",readdir(DIR));
unless (-e "/CouchbaseTroubleShooterNew.pl" || -e "/CouchbaseStatsGenerator.pl") {
   die "Copy the CouchbaseTroubleShooterNew.pl and CouchbaseStatsGenerator.pl to the / directory with the same name from github\n";
}  
foreach(@files) {                                                                                                                                                       
   system("unzip $_");                                                                                                                                                  
}                                                                                                                                                                       
my @cbfiles = grep(/cbcollect/,readdir(DIR));
foreach(@cbfiles) {
   chdir($_);
   system("perl /CouchbaseTroubleShooterNew.pl > /troubleshooteroutput_$_.txt");
   system("grep -E 'Port server memcached exited' ns_server.info.log >> /troubleshooteroutput_$_.txt");
   system("grep -E 'Could not auto-failover node|was automatically failovered' diag.log >> /troubleshooteroutput_$_.txt");
   system("perl /CouchbaseStatsGenerator.pl --s3fileName=ns_server.debug.log");
   system("mv OUTPUT_STATS.txt /OUTPUT_STATS.txt_$_.txt");
   system("rm -rf $_");
   chdir("..");
}
closedir(DIR) or warn "Couldn't close dir\n";
