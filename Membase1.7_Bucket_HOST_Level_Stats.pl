use strict;
use warnings;
my ($host,$date,$bucket,$flag,$value,$flag1,$value1,$host1);
my $file_name = $ARGV[0];
open(FILE,"<", $file_name) or die "Couldn't open file\n";
while(<FILE>) {
   chomp($_);
   if($_ =~ /INFO REPORT.*?(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/) {
      $date = $1;
   }
   if($_ =~ /\{\'ns_1@([^']+)\',/) {
      $host = $1;
   }
   if($_ =~ /cpu_utilization_rate,|swap_total,|swap_used,|total_memory,|free_memory,|system_total_memory,/) {
      $_ =~ s/\[|\{|\}|\s|\t//g;
      ($flag,$value) = split(",",$_);
      print $date.",".$host.","."HOST_LEVEL_STATS,".$flag.",".$value."\n";
   }
   if($_ =~ /ns_1@([^:]+):.*?Stats for bucket "([^"]+)"/) {
      $host1 = $1;
      $bucket = $2;
   }
   if($_ =~ /auth_cmds|auth_errors|bucket_conns|bytes|bytes_read|bytes_written|cmd_get|cmd_set|connection_structures|curr_connections|curr_items |daemon_connections|evictions|limit_maxbytes|reclaimed|total_connections|total_items /) {
      ($flag1,$value1) = split("  +",$_);
      print $date.",".$host1.",".$bucket.",".$flag1.",".$value1."\n";
   }

}
close(FILE) or warn "Couldn't close file\n";
