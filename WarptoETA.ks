declare parameter eta0, margin.

print "Waiting for node".  
set rt to eta0.    // remaining time
set t0 to Time:seconds.//timing start
until rt <= margin {
    set rt to eta0-Time:seconds+t0.    // remaining time
    //boost-warp


    //warping....
	set maxwarp to 5.
	if rt < 50000   { set maxwarp to 4. }
	if rt < 5000   { set maxwarp to 3. }
	if rt < 500    { set maxwarp to 2. }
	if rt < 100     { set maxwarp to 1. }
	if rt < 30    { set maxwarp to 0. }
	if rt < 6 
    {
        print "warp completed".
        break. 
    }

    set WARP to maxwarp.
    print "    Remaining time:  " + rt at (0,5).  
    print "       Warp factor:  " + WARP at (0,6).  
}