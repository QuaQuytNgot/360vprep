#! /bin/perl -w
use strict;

my $vname = "Diving_10s";                     	#change here
my $yuv = "yuv_file/${vname}.yuv";		#change here
my $W_yuv = 3840;                               
my $H_yuv = 1920;                             	   
my $No_tile_W = 4;                              #change here 
my $No_tile_H = 3;                              #change here 
my $No_tile = $No_tile_W * $No_tile_H;           
my $W_tile = $W_yuv / $No_tile_W;                
my $H_tile = $H_yuv / $No_tile_H;                
my $No_FR_P = 300;                               
my $frame_rate = 30;                             

my $outFolder_yuv = "${vname}/erp_${No_tile_W}x${No_tile_H}/tile_yuv/";
my $outFolder_log = "${vname}/erp_${No_tile_W}x${No_tile_H}/tile_log/";

unless (-e $outFolder_yuv) {
    system "mkdir -p $outFolder_yuv";
}
unless (-e $outFolder_log) {
    system "mkdir -p $outFolder_log";
}

for my $row (0 .. $No_tile_H - 1) {
    for my $col (0 .. $No_tile_W - 1) {
        my $x = $col * $W_tile;                  # x location of tile
        my $y = $row * $H_tile;                  # y location of tile
        my $tile_name = "${outFolder_yuv}tile_${row}_${col}_${W_tile}x${H_tile}.yuv";
        my $cmd = "ffmpeg -y -f rawvideo -s ${W_yuv}x${H_yuv} -r ${frame_rate} -i ${yuv} -filter:v \"crop=${W_tile}:${H_tile}:${x}:${y}\" -frames ${No_FR_P} -c:v rawvideo -pix_fmt yuv420p ${tile_name}";
        print "$cmd\n";
        system $cmd;
    }
}
