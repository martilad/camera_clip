/**
 * Base module fro generating clip
 * @author Ladislav Martínek
 */
module base_module (
    base_round,
    bottom_round,
    top_round,
	height,
    height_top,
    height_middle,
    width_top,
    width_middle,
    width_bottom,
    thickness_top, 
    thickness_middle, 
    thickness_bottom, 
    mnf
) { 
    // difference for rounding
    base_round_difference = 2 * base_round;
    height = height - base_round_difference;
    width_top = width_top - base_round_difference;
    width_middle = width_middle - base_round_difference;
    width_bottom = width_bottom - base_round_difference;
    bottom_round = bottom_round - base_round_difference;
    top_round = top_round - base_round_difference;
    height_bottom = height - height_top - height_middle;
    
    thickness_top = thickness_top - base_round_difference;
    thickness_middle = thickness_middle - base_round_difference;
    thickness_bottom = thickness_bottom - base_round_difference;
    
    translate([base_round, base_round, base_round]) // move to xyz start
        minkowski(){
            hull(){
                // top part with round for hull
                
                // right base cylinder
                translate(
                    [
                        height - top_round/2, 
                        (width_middle - width_top)/2 + top_round/2, 
                        0
                    ]
                )
                cylinder(
                    h = thickness_top, 
                    r1 = top_round/2,  
                    r2 = top_round/2, 
                    $fn = mnf
                );
   
                // left base cylinder
                translate(
                    [
                        height - top_round/2, 
                        (width_middle - width_top)/2 - top_round/2 + width_top, 
                        0
                    ]
                )
                cylinder(
                    h = thickness_top, 
                    r1 = top_round/2,  
                    r2 = top_round/2, 
                    $fn = mnf
                );
                
                //middle box
                translate([height_bottom, 0, 0])
                    cube([height_middle, width_middle, thickness_middle]);
                
                
                // bottom part with round for hull
                
                // right base cylinder
                translate(
                    [
                        bottom_round/2, 
                        (width_middle - width_bottom)/2 + bottom_round/2, 
                        0
                    ]
                )
                cylinder(
                    h = thickness_bottom, 
                    r1 = bottom_round/2,  
                    r2 = bottom_round/2, 
                    $fn = mnf
                );
               
                // left base cylinder
                translate(
                    [
                        bottom_round/2, 
                        (width_middle - width_bottom)/2 - bottom_round/2 + width_bottom,
                        0
                    ]
                )
                cylinder(
                    h = thickness_bottom, 
                    r1 = bottom_round/2,  
                    r2 = bottom_round/2, 
                    $fn = mnf
                );
            };
            sphere(r = base_round);
       };
}