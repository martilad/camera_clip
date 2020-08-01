/**
 * Complet grid horizontal
 * @author Ladislav Martínek
 */
module grid (
    thickness_middle,
    thickness_bottom,
    height_bottom,
    width_middle,
    width_bottom,
    grip_size,
    grip_margin_top,
    grip_margin_bottom,
    grip_depth,
    mfn,
) {
    height_bottom = height_bottom - grip_margin_top;
    deg_grip = atan((thickness_middle - thickness_bottom) / height_bottom);
    
    for (i = [0:1:round((height_bottom - grip_margin_bottom)/(grip_size*2))]) { 
        
        translate(
            [
                -i*grip_size*2, 
                0, 
                -((thickness_middle - thickness_bottom) - tan(deg_grip)*(height_bottom - i * grip_size*2))
            ]
        )
        hull () {
            translate([height_bottom - grip_size, 0, thickness_middle - grip_depth ])
            rotate([0, -deg_grip, 0])
            cylinder(h = grip_depth, d1 = 0,  r2 = grip_size, $fn = mfn);
                
            translate([height_bottom - grip_size, width_middle, thickness_middle - grip_depth ])
            rotate([0, -deg_grip, 0])
            cylinder(h = grip_depth, d1 = 0,  r2 = grip_size, $fn = mfn);
        }   
    }
}

/**
 * Vertical grid lines
 * @author Ladislav Martínek
 */
module vertical_grid_line (
    thickness_middle,
    thickness_bottom,
    height_bottom,
    width_middle,
    width_bottom,
    grip_line_size,
    grid_size,
    grip_margin_top,
    grip_margin_bottom,
    grip_depth,
) {
    // 1 rounding constant from grid margin
    height_bottom_ext = (round(height_bottom/grid_size)+1)*grid_size;
    
    deg_grip = atan((thickness_middle - thickness_bottom) / height_bottom);
    rotate([0, -deg_grip, 0])
    translate([grip_margin_bottom - grid_size, 0, thickness_bottom-grip_depth])
    // 1 compute error constatn no problem have box heigher
    cube([height_bottom_ext - grip_margin_top - grip_margin_bottom, grip_line_size, grip_depth + 1]); 
}