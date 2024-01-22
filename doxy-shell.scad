// How to make things smoother:
// <kintel> Traditionally, the easiest way is to draw half the outline in SVG and rotate_extrude() it in OpenSCAD
// <kintel> you can also do interesting tricks using offset(), but again, that needs to be done in 2D space
// <kintel> ..or finally, minkowski() {your_model(); sphere();} is often a decent trick

$fn = 20;
wall_thickness = 2.5;

motor_shaft_cutout_width = 2.6;
motor_shaft_cutout_radius = 10;

aluminium_ring_section_with = 5;
aluminium_ring_section_radius = 22.5;
aluminium_ring_section_inner_overlap = 2.5;

top_radius = 24;
top_width = 55;

motor_anchor_width = 7.5;
motor_anchor_slit_width = 2.5;
motor_anchor_slit_offeset = 2.5;

grip_cone_width = 93;
grip_cone_bottom_radius = 16.5;

middle_section_cone_width = 26;
middle_section_cone_radius = 18.8; 

bottom_section_cone_width = 40;
bottom_section_cone_radius = 10;

bottom_opening_width = 2.64;
bottom_opening_radius = 6;

button_radius = 8;
button_offset = 95;
button_gap = 17;
button_count = 3;

button_half = true;


screw_holder_radius = 4;
screw_holder_inner_radius = 1.35;

top_screw_holder_heigth = 11;
top_screw_holder_offset = 74;

pcb_screw_holder_z_offset = 150;
pcb_screw_holder_x_offset = -16;

bottom_screw_holder_z_offset = 190;
bottom_screw_holder_x_offset = -15;

difference() {
    union() {
        difference() {
            union() {
                difference() {
                    union() {
                        difference() {
                            cylinder(h=motor_shaft_cutout_width, r=aluminium_ring_section_radius);
                            cylinder(h=motor_shaft_cutout_width, r=motor_shaft_cutout_radius);
                        }
                        difference() {
                            translate([0,0,motor_shaft_cutout_width]) cylinder(h=aluminium_ring_section_with - motor_shaft_cutout_width, r=aluminium_ring_section_radius);
                            translate([0,0,motor_shaft_cutout_width]) cylinder(h=aluminium_ring_section_with - motor_shaft_cutout_width, r=aluminium_ring_section_radius - wall_thickness);
                        }
                        difference() {
                            translate([0,0,aluminium_ring_section_with]) cylinder(h=top_width, r=top_radius);
                            translate([0,0,aluminium_ring_section_with]) cylinder(h=motor_anchor_width, r=aluminium_ring_section_radius - wall_thickness);
                            translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=top_width - motor_anchor_width, r=top_radius - wall_thickness);
                            translate([0,0,aluminium_ring_section_with + motor_anchor_slit_offeset]) cylinder(h=motor_anchor_slit_width, r=top_radius - wall_thickness);
                        }
                        difference() {
                            translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius, r2=grip_cone_bottom_radius);
                            translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - wall_thickness, r2=grip_cone_bottom_radius - wall_thickness);
                        }
                        difference() {
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius, r2=middle_section_cone_radius);
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - wall_thickness, r2=middle_section_cone_radius - wall_thickness);
                        }
                        difference() {
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width, r1=middle_section_cone_radius, r2 = bottom_section_cone_radius);
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width - bottom_opening_width, r1=middle_section_cone_radius - wall_thickness, r2 = bottom_section_cone_radius - wall_thickness);
                        }
                        if(button_half) {
                            difference() {
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_radius);
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_inner_radius);
                            }
                            difference() {
                                translate([pcb_screw_holder_x_offset, 0, pcb_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_radius);
                                translate([pcb_screw_holder_x_offset, 0, pcb_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_inner_radius);
                            }
                            difference() {
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_radius);
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_heigth, r=screw_holder_inner_radius);
                            }
                        } else {
                            difference() {
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_radius + wall_thickness, r=screw_holder_radius);
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_radius + wall_thickness, r=screw_holder_inner_radius);
                            }
                            difference() {
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_radius + wall_thickness, r=screw_holder_radius);
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_radius + wall_thickness, r=screw_holder_inner_radius);
                            }
                        }
                    }
                    
                    // Holes for the buttons
                    if(button_half) {
                        for (i = [0 : button_count - 1]) {
                            button_z = button_offset + button_radius + i * button_gap;
                            translate([0 - top_radius, 0, button_z]) rotate([0,90,0])  cylinder(h=30, r=button_radius);
                        }

                    }
                }
                if(button_half) {
                    for (i = [0 : button_count - 1]) {
                            button_z = button_offset + button_radius + i * button_gap;
                            grip_cone_z = aluminium_ring_section_with + top_width;
                            grip_cone_z2 = aluminium_ring_section_with + top_width + grip_cone_width;

                            button_percent = (button_z - grip_cone_z) / (grip_cone_z2 - grip_cone_z);
                            button_x_offset = top_radius - ((top_radius - grip_cone_bottom_radius) * button_percent);
                            difference() {
                                translate([0 - button_x_offset + 1, 0, button_z]) rotate([0,90,0])  cylinder(h=4, r=button_radius + 1);
                                translate([0 - button_x_offset - 5, 0, button_z]) rotate([0,90,0])  cylinder(h=60, r=button_radius);
                            }
                    }

                }
            }

            translate([0, -30, 0]) cube([30, 60, 1000]); // cut in half for easier modelling
        }
        difference() {
            union() {
                difference() {
                    translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - (wall_thickness / 2), r2=grip_cone_bottom_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - wall_thickness, r2=grip_cone_bottom_radius - wall_thickness);
                }
                difference() {
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - (wall_thickness / 2), r2=middle_section_cone_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - wall_thickness, r2=middle_section_cone_radius - wall_thickness);
                }
                difference() {
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width, r1=middle_section_cone_radius - (wall_thickness / 2), r2 = bottom_section_cone_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width - bottom_opening_width, r1=middle_section_cone_radius - wall_thickness, r2 = bottom_section_cone_radius - wall_thickness);
                }
                difference() {
                    translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=top_width - motor_anchor_width, r=top_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=motor_anchor_width, r=aluminium_ring_section_radius - wall_thickness);
                    translate([0,0,aluminium_ring_section_with + (motor_anchor_width * 2)]) cylinder(h=top_width - (motor_anchor_width * 2), r=top_radius - wall_thickness);
                }
            }
            translate([-32, -30, 0]) cube([30, 60, 1000]); // cut in half for easier modelling
        }
    }
    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width + bottom_section_cone_width - bottom_opening_width]) cylinder(h=bottom_opening_width, r=bottom_opening_radius); // cable cutout
    translate([1, -30, 0]) cube([30, 60, 1000]); // cut in half for easier modelling
}
