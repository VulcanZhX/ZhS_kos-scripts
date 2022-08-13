//Parking orbit solver for above lunar plane launches.
CLEARSCREEN.
set launchLat to SHIP:GEOPOSITION:LAT. 
set launchLong to SHIP:GEOPOSITION:LNG.

set moon to body("Minmus").
set eartharth to body("Kerbin").
set moonIncl to Minmus:ORBIT:INCLINATION.
set moonLAN to Minmus:ORBIT:LAN.
set moonArgP to Minmus:ORBIT:ARGUMENTOFPERIAPSIS.
set moonEcc to Minmus:ORBIT:ECCENTRICITY.
set moonSMA to Minmus:ORBIT:SEMIMAJORAXIS.

set earthrotangvel to 360/eartharth:ROTATIONPERIOD.
set Vlan to ship:orbit:LAN. 
print "Launching to Lunar intercept plane." at (0,4).
print "Vessel initial LAN: " + round(Vlan)  at (0,5).

set t0 to TIME:seconds.

if Vlan<moonLAN+90  {set launchTime to (moonLAN-Vlan+90)/earthrotangvel.}   
else {set launchTime to (moonLAN-Vlan+450)/earthrotangvel.}

print "launchTime" +round(launchTime) at(0,9).
set tminus to 1.
until tminus < 0 
{
    set maxwarp to 5.
    if tminus < 2000   { set maxwarp to 4. }
    if tminus < 200    { set maxwarp to 2. }
    if tminus < 20     { set maxwarp to 1. }
    if tminus < 4    { set maxwarp to 0. }
    print "Time Warp:  " + WARP at (0,7).  
    set WARP to maxwarp.

    set tminus to launchTime - TIME:seconds+ t0.
    print "T-minus " + floor(tminus) + " seconds." at (0,6).
    print "Vessel_LAN " + floor(ship:orbit:lan) + " deg." at (0,7).
    wait 0.2.
}
print "GO!" at(0,8).