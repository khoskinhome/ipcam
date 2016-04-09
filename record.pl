#!/usr/bin/perl
use strict;
use warnings;
use 5.14.2;

use POSIX qw/strftime/;


=pod 

    script to be cron to run hourly.

=cut

my $cams = {
    'ipcam04' => {
        url => 'rtsp://ipcam04.khaos:554/ucast/11',
    }
};

my $cam_store_root = '/home/khoskin/crap';

for my $cam ( keys %$cams ) {
 
    my $tstmp_day  = strftime( '%F' , gmtime );
    my $tstmp_hour = strftime( '%H' , gmtime );
    my $tstmp_hourmin = strftime( '%H%M', gmtime );

    my $path = "$cam_store_root/$cam/$tstmp_day/$tstmp_hour";

    my $fileprefix = "$cam-$tstmp_day-$tstmp_hourmin";

    if ( ! -d $path ){
        my $mkcmd = "mkdir -p $path";
        print $mkcmd."\n";
        system($mkcmd) or die "can't $mkcmd";
    }

    chdir $path or die "can't chdir to $path";

    my $url = $cams->{$cam}{url};

    # script is to be run hourly, hence -d == 3660 , so the following command will
    # record 61 mins, split up into (-P 300) 5 min files.
    my $rec_cmd = "openRTSP -D 1 -B 10000000 -b 10000000 -4 -Q -F $fileprefix -d 3600 -P 300 $url &";
    print "$rec_cmd\n";
    system($rec_cmd);

}


#-U 20160409T202200Z \
#-E 20160409T202100Z \

#-c \

