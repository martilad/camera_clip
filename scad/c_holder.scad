/**
 * One holder for clip
 * @author Ladislav Martínek
 */
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
                translate(
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