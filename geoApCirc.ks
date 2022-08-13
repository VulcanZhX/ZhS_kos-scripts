//for inclined GTO circ into GEO, LAN at Apogee.
//Zh Vulkan 2022.8.11

//vel at apogee&target vel.
CLEARSCREEN.
set r_earth to earth:radius.
set v_geo to sqrt(constant:G*earth:mass/(ship:orbit:apoapsis+r_earth)).//3074.7m/s at 35786km
set Rm to -earth:orbit:position.
set Vm to ship:velocity:orbit.
set Hm to VCRS(Rm,Vm).
set hm0 to sqrt(Hm*Hm).
set v_ap to hm0/(ship:orbit:apoapsis+r_earth).

//general orbit parameters
set inc to ship:orbit:inclination.

//calc dv value
set dvx to v_geo-v_ap*cos(inc).
set dvy to -v_ap*sin(inc).
print "dvx="+dvx at(0,1).
print "dvy="+dvy at(0,2).
print "dvcal_0="+sqrt(dvx^2+dvy^2)at(0,3).
//node scalar component
set dv_nml_down to (dvx*tan(inc)-dvy)/(sin(inc)*tan(inc)+cos(inc)).
set dv_pro to (dvx-dv_nml_down*sin(inc))/cos(inc).

//create node
set Nodetime to ETA:apoapsis.
set myNode to Node(Time:seconds+NodeTime,0,-dv_nml_down,dv_pro).
add myNode.
print "dv_nml="+(-dv_nml_down) +"m/s"at(0,4).
print "dv_pro="+dv_pro+"m/s"at(0,5).
//print "input run to execute node".
//wait 15.
//nodeEXC
//runOncePath("NodeEXCRO.ks").


