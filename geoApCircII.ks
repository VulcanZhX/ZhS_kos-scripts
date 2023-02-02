//for (0-90deg,generally 5-45 deg)inclined GTO circ into GEO, LAN at Apogee,2-burns for GEO WeaSat contract.
//Zh Vulkan 2022.8.12

set config:IPU to 400.

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

function calTgtv
{
    parameter T_tgt.
    set sma1 to (sqrt(constant:G*earth:mass)*T_tgt/(2*constant:pi))^(2/3).
    set ecc1 to (ship:apoapsis+r_earth)/sma1-1.
    set Hm_tgt to sqrt(constant:G*earth:mass*(ship:apoapsis+r_earth)*(1-ecc1)).
    return Hm_tgt/(ship:orbit:apoapsis+r_earth).
}

function calOrbHm
{
    set Rm to -earth:orbit:position.
    set Vm to ship:velocity:orbit.
    return VCRS(Rm,Vm).
}

//awaitTime>10h,or wait for next apoapsis.
function calawaitTime
{   
    parameter ship_ap_lng.
    
    set awaitTime to (360+ship_ap_lng-tgt_lng)*240.
    if ship_ap_lng>tgt_lng
        set awaitTime to (ship_ap_lng-tgt_lng)*240.     //86400/360=240.

    if awaitTime<10*3600
        set awaitTime to -1.
    return awaitTime.
}


CLEARSCREEN.
set tgt_lng to waypoint("Geostationary Weather Satellite"):geoposition:lng.//test.

set r_earth to earth:radius.
set inc to ship:orbit:inclination.

set v_geo to sqrt(constant:G*earth:mass/(ship:orbit:apoapsis+r_earth)).//3074.7m/s at 35786km,v2
set Hm0 to calOrbHm().
set v_ap to sqrt(Hm0*Hm0)/(ship:orbit:apoapsis+r_earth).
set v_aplist to list(v_ap*cos(inc),v_ap*sin(inc)).

//warp to eta:apoapsis 0-300sec
set v_step to -1.
set period_v_step to calawaitTime(ship:longitude).//warp to near ap,testing other stuffs.

if period_v_step+1
{
    set v_step to calTgtv(period_v_step).
    set dv1_list to caldvxy(inc,v_ap,v_step,v_geo).
    set node1_list to calnodedv(v_aplist,dv1_list).
    set myNode1 to Node(Time:seconds+ETA:apoapsis,0,-1*node1_list[1],node1_list[0]).
    add myNode1.
    print "target lng:"+tgt_lng+" deg"at(0,2).
    print "parking time:"+period_v_step/3600+ "h"at(0,3).
    print "node dv:"+myNode1:deltav+" m/s"at(0,4).
}
else   
    print "ERRTIME,PLEASE WARP TO NEXT ORBIT" at(0,2).//end

//warp to eta,recal-






