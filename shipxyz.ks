CLEARSCREEN.
set t0 to TIME:seconds.
set runtimez to 8*10^4.
set tminus to 1.
until tminus < 0 
{
    set maxwarp to 6.
    if tminus < 5000   { set maxwarp to 5. }
    if tminus < 1000    { set maxwarp to 3. }
    if tminus < 50     { set maxwarp to 1. }
    if tminus < 10    { set maxwarp to 0. }
    print "Time Warp:  " + WARP at (0,7).  
    set WARP to maxwarp.

    set tminus to runtimez - TIME:seconds+ t0.
    print "T-minus " + floor(tminus) + " seconds." at (0,6).
    print "Ship-PosX:" + kerbin:orbit:position:x+"         "at (0,7).
    print "Ship-PosY:" + kerbin:orbit:position:y+"         "at (0,8).
    print "Ship-PosZ:" + kerbin:orbit:position:z+"         "at (0,9).
    wait 0.2.
}