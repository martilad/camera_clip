include <base_module.scad>
include <c_holder.scad>
include <grid.scad>

module clip (
    base_round = 0.4,
    bottom_round=10,
    top_round=4,
	height = 71,
    height_top = 10,
    height_middle = 15,
	width_top = 30,
    width_middle = 33,
    width_bottom = 27,
	thickness_top = 3,
    thickness_middle = 5,
	thickness_bottom = 3,
    grid_size = 1.1,
    grid_line_size = 4,
    grid_line_count = 4,
    grid_margin_top = 6,
    grid_margin_bottom = 2.7,
    grid_margin_sides = 3,
    grid_depth = 1.5,
    mfn = 10, 
    c_holder_diameter_inside = 3,
    c_holder_outside = 1.8,
    c_holder_width = 3.6, 
    c_holder_height = 9,
    c_holder_pitch = 26.7,
    c_holder_lenght = 14,
    c_holder_immersed = 1.9, 
    c_holder_borders = 0,
    c_holder_diameter = 10, 
    top_immersed = 0,
    top_immersed_sphere_radius = 15,
    top_immersed_width = 12
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
                    thickness_bottom, mfn
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
        };
        // double sphere hole in back base module 
        hull () {
            translate(
                [
                    height - height_top/2 - height_middle/4, 
                    width_middle/2 - top_immersed_width/2, 
                    -top_immersed_sphere_radius+top_immersed
                ]
            )
            sphere(r = top_immersed_sphere_radius);
            
            translate(
                [
                    height - height_top/2 - height_middle/4, 
                    width_middle/2 + top_immersed_width/2, 
                    -top_immersed_sphere_radius+top_immersed
                ]
            )
            sphere(r = top_immersed_sphere_radius);
        }
        // do grid to bottom
        grid(
            thickness_middle, thickness_bottom, height_bottom, width_middle, 
            width_bottom, grid_size, grid_margin_top, 
            grid_margin_bottom, grid_depth, mfn
        );
        
        // do grid lines
        spacing = ((width_bottom - 2 * grid_margin_sides - 1 * grid_line_size) - ((grid_line_count - 1) * grid_line_size))/(grid_line_count - 1);
        
        
        for (i = [0:1:grid_line_count - 1]) { 
            translate(
                [
                    0, 
                    (width_middle - width_bottom)/2 + grid_margin_sides + i * (grid_line_size + spacing), 
                    0
                ]
            )
            vertical_grid_line(
                thickness_middle, thickness_bottom, height_bottom, width_middle, 
                width_bottom, grid_line_size, grid_size, grid_margin_top, 
                grid_margin_bottom, grid_depth
            );
        };
    };
}

clip();