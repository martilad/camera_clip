include <base_module.scad>
include <c_holder.scad>

module grid (
    thickness_diff_middle,
    height_bottom,
    grip_size,
    grip_margin_top,
    grip_margin_bottom,
    grip_margin_sides,
    grip_spacing,
    grip_depth,
    grid_sides,
) {
    
    for (a =[3:0.5:5]) {
        echo(a);   
    }
    
    deg_grip = atan((thickness_diff_middle) / height_bottom);
    translate([-5, -5, 0])
    rotate([-deg_grip, -deg_grip, deg_grip])
    cylinder(h = grip_depth, d1 = 0,  r2 = grip_size, $fn = grid_sides);
}



module clip (
    base_round = 0.4,
    bottom_round=10,
    top_round=5,
	height = 72,
    height_top = 13,
    height_middle = 15,
	width_top = 32,
    width_middle = 32,
    width_bottom = 25,
	thickness_top = 5,
    thickness_middle = 6,
	thickness_bottom = 4,
    grip_size = 2,
    grip_margin_top = 1,
    grip_margin_bottom = 1,
    grip_margin_sides = 1,
    grip_spacing = 1,
    grip_depth = 2,
    grid_sides = 8,
    mfn = 17, 
    c_holder_diameter_inside = 3,
    c_holder_outside = 1.5,
    c_holder_width = 5, 
    c_holder_height = 7,
    c_holder_pitch = 26.7,
    c_holder_lenght = 15,
    c_holder_immersed = 2, 
    c_holder_borders = 0,
    c_holder_diameter = 10, 
    top_immersed = 1.5,
    top_immersed_sphere_radius = 10,
    top_immersed_width = 5
) {
    // number of fragments for curves
    $fn = mfn;
    
    // check arguments values
    assert(
        thickness_middle >= thickness_top, 
        "middle thickness have to be equal or bigger then middle one"
    );
    assert(
        thickness_bottom <= thickness_middle, 
        "bottom thickness have to be equal or bigger then middle one"
    );
    assert(
        base_round < min(thickness_top, thickness_middle, thickness_bottom), 
        "base_round have to be smaller than minimum to create else remove some parts"
    );
    assert(
        base_round * 2 < c_holder_outside, 
        "base_round doubled have to be smaller than outside diameter to possibility apply minkovsky to rounding"
    );
    assert(
        top_immersed < thickness_top, 
        "not do hole to top part"
    );
        
    // calculate bottom base on height, top and middle
    height_bottom = height - height_top - height_middle;
    thickness_min = min(thickness_top, thickness_middle, thickness_bottom);
    
    difference () {
        union () {
            
            // base module with immersed middle line
            difference () {
                base_module(
                    base_round, bottom_round, top_round, height, height_top, height_middle,
                    width_top, width_middle, width_bottom, thickness_top, thickness_middle, 
                    thickness_bottom, mnf
                );
                
                translate(
                    [
                        height_bottom + height_middle/2, 
                        width_middle - c_holder_borders, 
                        thickness_middle + c_holder_diameter/2 - c_holder_immersed
                    ]
                )
                rotate([0, 90, -90])
                cylinder(
                    h = width_middle-2*c_holder_borders, 
                    r1 = c_holder_diameter/2, 
                    r2 = c_holder_diameter/2, 
                    center = false
                );
            }
            
            
            
            // right c_holder
            translate(
                [
                    height_bottom+height_middle/2, 
                    (width_middle - c_holder_pitch)/2 + c_holder_width, 
                    thickness_middle - c_holder_immersed - base_round
                ]
            )
            translate(
                [
                    0, 
                    -base_round, 
                    c_holder_height-c_holder_diameter_inside/2 - c_holder_outside
                ]
            )
            rotate([0, 90, -90])
            c_holder (
                base_round, c_holder_diameter_inside, c_holder_outside,
                c_holder_width, c_holder_height + base_round,
                c_holder_lenght, c_holder_immersed
            );
            
             
            // left c_holder
            translate(
                [
                    height_bottom+height_middle/2, 
                    width_middle/2 + c_holder_pitch/2, 
                    thickness_middle - c_holder_immersed - base_round
                ]
            )
            translate(
                [
                    0, 
                    -base_round, 
                    c_holder_height-c_holder_diameter_inside/2 - c_holder_outside
                ]
            )
            rotate([0, 90, -90])
            c_holder (
                base_round, c_holder_diameter_inside, c_holder_outside,
                c_holder_width, c_holder_height + base_round,
                c_holder_lenght, c_holder_immersed
            );
            
           
            
            
            
            
            
            
            
            
            
            
            %grid(
                thickness_middle-thickness_min, height_bottom, grip_size, 
                grip_margin_top, grip_margin_bottom, grip_margin_sides,
                grip_spacing, grip_depth, grid_sides
            );
        };
        hull () {
            translate(
                [
                    height - height_top/2, 
                    width_middle/2 - top_immersed_width/2, 
                    -top_immersed_sphere_radius+top_immersed
                ]
            )
            sphere(r = top_immersed_sphere_radius);
            
            translate(
                [
                    height - height_top/2, 
                    width_middle/2 + top_immersed_width/2, 
                    -top_immersed_sphere_radius+top_immersed
                ]
            )
            sphere(r = top_immersed_sphere_radius);
        }
    }
}

clip();