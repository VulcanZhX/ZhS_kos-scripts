//for inclined GTO circulized into GEO,AN at Apogee,2 burns for GEO Constellation contract(4 Sats).

function calOrbHm
{
    set Rm to -1*earth:orbit:position.
    set Vm to ship:velocity:orbit.
    return VCRS(Rm,Vm).
}

function calTgtv
{
    parameter T_tgt.
    set sma1 to (sqrt(constant:G*earth:mass)*T_tgt/(2*constant:pi))^(2/3).
    set ecc1 to (ship:apoapsis+r_earth)/sma1-1.
    set Hm_tgt to sqrt(constant:G*earth:mass*(ship:apoapsis+r_earth)*(1-ecc1)).
    return Hm_tgt/(ship:orbit:apoapsis+r_earth).
}

//cal v1-x,v1-y.
function caldvxy
{
    parameter finc,v0,v1,v2.
    set k to v0*sin(finc)/(v0*cos(finc)-v2).

    //equation parameter
    set equ0 to k^2+1.
    set equ1 to -2*(k^2)*v2.
    set equ2 to (k^2)*(v2^2)-v1^2.
    
    //equation solution
    set vx to (-equ1+sqrt(equ1^2-4*equ0*equ2))/(2*equ0).
    set vy to k*(vx-v2). 

    //return sqrt(vx^2+vy^2).
    return list(vx,vy).
}

function calnodedv
{
    parameter v_orglist,v_tgtlist.
    set dvx to v_tgtlist[0]-v_orglist[0].
    set dvy to v_tgtlist[1]-v_orglist[1].
    set inc_org to arctan(v_orglist[1]/v_orglist[0]).
    set dv_nml_down to (dvx*tan(inc_org)-dvy)/(sin(inc_org)*tan(inc_org)+cos(inc_org)).
    set dv_pro to (dvx-dv_nml_down*sin(inc_org))/cos(inc_org).
    return list(dv_pro,dv_nml_down).
}

CLEARSCREEN.
//set tgt_lng to waypoint("Geostationary Weather Satellite"):geoposition:lng.//test.

set r_earth to earth:radius.
set inc to ship:orbit:inclination.
set v_geo to sqrt(constant:G*earth:mass/(ship:orbit:apoapsis+r_earth)).//3074.7m/s at 35786km,v2
set Hm0 to calOrbHm().
set v_ap to sqrt(Hm0*Hm0)/(ship:orbit:apoapsis+r_earth).
set v_aplist to list(v_ap*cos(inc),v_ap*sin(inc)).
set period_v_step to 0.75*target:orbit:period.// resonant orbit (3/4)

set v_step to calTgtv(period_v_step).
set dv1_list to caldvxy(inc,v_ap,v_step,v_geo).
set node1_list to calnodedv(v_aplist,dv1_list).
set myNode1 to Node(Time:seconds+ETA:apoapsis,0,-1*node1_list[1],node1_list[0]).
add myNode1.

print "parking time:"+period_v_step/3600+ "h"at(0,3).
print "node dv:"+myNode1:deltav+" m/s"at(0,4).

