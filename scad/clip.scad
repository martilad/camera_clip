/**
 * clip
 * parametrized modul for creating clip for <???>
 * @param x - size
 * @author Ladislav Martínek
 */
 
module base_module (
    base_round=10,
	height,
    height_top,
    height_middle,
    width_top,
    width_middle,
    width_bottom,
    thickness_top, 
    thickness_middle, 
    thickness_bottom
) { 
    // difference for rounding
    base_round_difference = 2 * base_round;
    height = height - base_round_difference;
    width_top = width_top - base_round_difference;
    width_middle = width_middle - base_round_difference;
    width_bottom = width_bottom - base_round_difference;
    height_bottom = height - height_top - height_middle;
    
    thickness_top = thickness_top - base_round_difference;
    thickness_middle = thickness_middle - base_round_difference;
    thickness_bottom = thickness_bottom - base_round_difference;
    
    translate([base_round, base_round, base_round]) // move to xyz start
        minkowski() {
            hull(){
                //base minimum
                //cube([height,width,thickness_top]);
               
                // top box
                translate([height, (width_middle - width_top) / 2, 0])
                cube([0.001, width_top, thickness_top]);
                
                //middle box
                translate([height_bottom, 0, 0])
                    cube([height_middle, width_middle, thickness_middle]);
                
                // bottom box
                translate([0, (width_middle - width_bottom) / 2, 0])
                cube([0.001, width_bottom, thickness_bottom]);
            };
            sphere(r = base_round);
    }
}

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

module c_holder (
    base_round,
    c_holder_diameter_inside,
    c_holder_diameter_outside,
    c_holder_width, 
    c_holder_height,
    c_holder_lenght,
    c_holder_immersed
) {
    diameter = c_holder_diameter_inside + 2 * c_holder_diameter_outside;
    minkowski() {
        difference () {
            hull () {
                cylinder(
                    h = c_holder_width - 2* base_round, 
                    r1 = diameter / 2 - base_round, 
                    r2 = diameter / 2 - base_round, 
                    center = false
                );
            
                #translate(
                    [
                        c_holder_height - diameter / 2 - 0.0001 - base_round, 
                        -c_holder_lenght / 2  + base_round, 
                        0
                    ]
                )
                rotate([90, 0, 90])
                cube(
                    [
                        c_holder_lenght-2*base_round, 
                        c_holder_width-2*base_round, 
                        0.0001
                    ]
                );
            }
            cylinder(
                h = c_holder_width, 
                r1 = c_holder_diameter_inside / 2 + base_round, 
                r2 = c_holder_diameter_inside / 2 + base_round, 
                center = false
            );
        }
        sphere(r = base_round);
    }
}

module clip (
    base_round = 0.4,
	height = 72,
    height_top = 13,
    height_middle = 15,
	width_top = 39,
    width_middle = 35,
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
    mfn = 5, 
    c_holder_diameter_inside = 3,
    c_holder_outside = 1,
    c_holder_width = 4, 
    c_holder_height = 8,
    c_holder_pitch = 26.7,
    c_holder_lenght = 8,
    c_holder_immersed = 1, 
    c_holder_borders = 1
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
    
    // calculate bottom base on height, top and middle
    height_bottom = height - height_top - height_middle;
    thickness_min = min(thickness_top, thickness_middle, thickness_bottom);
    
    diameter = c_holder_diameter_inside + 2 * c_holder_outside;
    
    union () {
        difference () {
            base_module(
                base_round, height, height_top, height_middle,
                width_top, width_middle, width_bottom, thickness_top, thickness_middle, 
                thickness_bottom
            );
            
            translate(
                [
                    height_bottom+height_middle/2, 
                    width_middle-c_holder_borders, 
                    thickness_middle+diameter/2-c_holder_immersed
                ]
            )
            rotate([0, 90, -90])
            cylinder(h = width_middle-2*c_holder_borders, 
                     r1 = diameter/2, 
                     r2 = diameter/2, 
                     center = false);
        }
        
        
        
        
        translate(
            [
                height_bottom+height_middle/2, 
                c_holder_pitch, 
                thickness_middle-c_holder_immersed
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
            c_holder_width, c_holder_height,
            c_holder_lenght, c_holder_immersed
        );
        
        
        
        //26.5 mezi 
        
        translate(
            [
                height_bottom+height_middle/2, 
                0, 
                thickness_middle-c_holder_immersed
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
            c_holder_width, c_holder_height,
            c_holder_lenght, c_holder_immersed
        );
        
       
        
        
        
        
        
        
        
        
        
        
        %grid(
            thickness_middle-thickness_min, height_bottom, grip_size, 
            grip_margin_top, grip_margin_bottom, grip_margin_sides,
            grip_spacing, grip_depth, grid_sides
        );
    }
}

clip();