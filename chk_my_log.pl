#!/usr/local/bin/perl -w

use strict;
use Term::ANSIColor;
use Spreadsheet::XLSX;
#use HTML::Entities;
use List::Util qw[min max];
use Cwd;

sub showUsage {	print colored("Usage:   perl $0 <DIR>\n", 'green'),
			                  "Example: perl $0 log/RTL_NO/\n"};

#========================================================================================================
# Main Process
#========================================================================================================

if ($#ARGV < 0) {
   showUsage();
   exit 0;
}

my $creattime = localtime();
my $currentpath = getcwd();

printf("Time:            %s\n", $creattime);
printf("Path:            %s\n", $currentpath);
printf("Script:          %s\n", $0);
printf("Input Directory: %s\n", $ARGV[0]);

my $parse_dir = $ARGV[0];
my $line;
my $err_cnt;
my $date;
my $year;
my $month;
my $day;
my $hour;
my $minute;

printf "===============================================================================================================\n";
printf " LOG                                                         | Error count       | Last Run                    \n";
printf "===============================================================================================================\n";

foreach my $fp (glob("$parse_dir/*.log")) {
    $err_cnt = 0;     
    $date = "YYYY/MM/DD, hr:mi";     
    open my $fh, "<", $fp or die "Can't read log: $fp";
    while (<$fh>) {
        $line = $_;
        if( $line =~ /Error/) {
            $err_cnt += 1;
        }

       #  TOOL:	ncsim(64)	15.20-s049: Exiting on Oct 01, 2024 at 18:22:29 CST  (total: 00:00:10)
        if($line =~ /Exiting on (\w{3}) (\d{2}), (\d{4}) at (\d{2}):(\d{2})/) {
            #print "End line\n"; 
            if($1 eq "Jan") {
                $month = "01";
            }
            elsif($1 eq "Feb") {
                $month = "02";
            }
            elsif($1 eq "Mar") {
                $month = "03";
            }
            elsif($1 eq "Apr") {
                $month = "04";
            }
            elsif($1 eq "May") {
                $month = "05";
            }
            elsif($1 eq "Jun") {
                $month = "06";
            }
            elsif($1 eq "Jul") {
                $month = "07";
            }
            elsif($1 eq "Aug") {
                $month = "08";
            }
            elsif($1 eq "Sep") {
                $month = "09";
            }
            elsif($1 eq "Oct") {
                $month = "10";
            }
            elsif($1 eq "Nov") {
                $month = "11";
            }
            elsif($1 eq "Dec") {
                $month = "12";
            }

            $day = $2;
            $year = $3;
            $hour = $4;
            $minute = $5;

            #$date = "YYYY/MM/DD, hr:mi";     
            $date = "$year/$month/$day, $hour:$minute";
        }
    }
    if ($err_cnt == 0) {
        print(sprintf(" %-60s| %-18s| %-24s\n", $fp, $err_cnt, $date));
    }
    else {
        print(colored (sprintf(" %-60s| %-18s| %-24s\n", $fp, $err_cnt, $date), "RED"));
    }
}
