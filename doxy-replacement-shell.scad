/*
Doxy replacement Shell

Copyright 2024 nomike[AT]nomike[DOT]com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// How to make things smoother:
// <kintel> Traditionally, the easiest way is to draw half the outline in SVG and rotate_extrude() it in OpenSCAD
// <kintel> you can also do interesting tricks using offset(), but again, that needs to be done in 2D space
// <kintel> ..or finally, minkowski() {your_model(); sphere();} is often a decent trick

$fn = 32; // increase before final render
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

grip_cone_width = 107;
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
screw_holder_screwhead_insert_wall_thickness = 0.5;
screw_holder_screwhead_insert_depth = 10;

top_screw_holder_height = 11;
top_screw_holder_offset = 74;

pcb_screw_holder_z_offset = 153;
pcb_screw_holder_x_offset = -16;

bottom_screw_holder_z_offset = 190;
bottom_screw_holder_x_offset = -15;

difference() {
    union() {
        difference() {
            union() {
                difference() {
                    union() {
                        difference() { // Front plate with motor shaft cutout
                            cylinder(h=motor_shaft_cutout_width, r=aluminium_ring_section_radius);
                            cylinder(h=motor_shaft_cutout_width, r=motor_shaft_cutout_radius);
                        }
                        difference() { // Motor rubber ring cutout
                            translate([0,0,motor_shaft_cutout_width]) cylinder(h=aluminium_ring_section_with - motor_shaft_cutout_width, r=aluminium_ring_section_radius);
                            translate([0,0,motor_shaft_cutout_width]) cylinder(h=aluminium_ring_section_with - motor_shaft_cutout_width, r=aluminium_ring_section_radius - wall_thickness);
                        }
                        difference() { // Top section
                            translate([0,0,aluminium_ring_section_with]) cylinder(h=top_width, r=top_radius);
                            translate([0,0,aluminium_ring_section_with]) cylinder(h=motor_anchor_width, r=aluminium_ring_section_radius - wall_thickness);
                            translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=top_width - motor_anchor_width, r=top_radius - wall_thickness);
                            translate([0,0,aluminium_ring_section_with + motor_anchor_slit_offeset]) cylinder(h=motor_anchor_slit_width, r=top_radius - wall_thickness);
                        }
                        difference() { // Grip cone
                            translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius, r2=grip_cone_bottom_radius);
                            translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - wall_thickness, r2=grip_cone_bottom_radius - wall_thickness);
                        }
                        difference() { // Middle section cone
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius, r2=middle_section_cone_radius);
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - wall_thickness, r2=middle_section_cone_radius - wall_thickness);
                        }
                        difference() { // Bottom section cone
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width, r1=middle_section_cone_radius, r2 = bottom_section_cone_radius);
                            translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width - bottom_opening_width, r1=middle_section_cone_radius - wall_thickness, r2 = bottom_section_cone_radius - wall_thickness);
                        }
                        if(button_half) { // Screw holders for button half
                            difference() {
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_radius);
                                translate([0 - top_radius + wall_thickness, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_inner_radius);
                            }
                            difference() {
                                translate([pcb_screw_holder_x_offset, 0, pcb_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_radius);
                                translate([pcb_screw_holder_x_offset, 0, pcb_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_inner_radius);
                            }
                            difference() {
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_radius);
                                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=top_screw_holder_height, r=screw_holder_inner_radius);
                            }
                        } else { // Screw holders for other half
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

                    } else { // screw holes
                                translate([0 - top_radius, 0, top_screw_holder_offset]) rotate([0,90,0]) cylinder(h=screw_holder_screwhead_insert_depth, r=screw_holder_radius - screw_holder_screwhead_insert_wall_thickness);
                                translate([bottom_screw_holder_x_offset - wall_thickness, 0, bottom_screw_holder_z_offset]) rotate([0,90,0]) cylinder(h=screw_holder_screwhead_insert_depth, r=screw_holder_radius - screw_holder_screwhead_insert_wall_thickness);
                    }
                }
                if(button_half) { // inner button ridges
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
        if(button_half) { // connection ridge on the inside for button half
            difference() {
                union() {
                    difference() { // top section
                        translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=top_width - motor_anchor_width, r=top_radius - (wall_thickness / 2));
                        translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=motor_anchor_width, r=aluminium_ring_section_radius - wall_thickness);
                        translate([0,0,aluminium_ring_section_with + (motor_anchor_width * 2)]) cylinder(h=top_width - (motor_anchor_width * 2), r=top_radius - wall_thickness);
                    }
                    difference() { // grip cone
                        translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - (wall_thickness / 2), r2=grip_cone_bottom_radius - (wall_thickness / 2));
                        translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - wall_thickness, r2=grip_cone_bottom_radius - wall_thickness);
                    }
                    difference() { // middle section cone
                        translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - (wall_thickness / 2), r2=middle_section_cone_radius - (wall_thickness / 2));
                        translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - wall_thickness, r2=middle_section_cone_radius - wall_thickness);
                    }
                    difference() { // bottom section cone
                        translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width, r1=middle_section_cone_radius - (wall_thickness / 2), r2 = bottom_section_cone_radius - (wall_thickness / 2));
                        translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width - bottom_opening_width, r1=middle_section_cone_radius - wall_thickness, r2 = bottom_section_cone_radius - wall_thickness);
                    }
                }
                translate([-32, -30, 0]) cube([30, 60, 1000]); // cut in half
            }
        }   
    }
    if(!button_half) { // connection ridge on the outside for other half
        difference() {
            union() {
                difference() { // top section
                    translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=top_width - motor_anchor_width, r=top_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + motor_anchor_width]) cylinder(h=motor_anchor_width, r=aluminium_ring_section_radius - wall_thickness);
                    translate([0,0,aluminium_ring_section_with + (motor_anchor_width * 2)]) cylinder(h=top_width - (motor_anchor_width * 2), r=top_radius - wall_thickness);
                }
                difference() { // grip cone
                    translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - (wall_thickness / 2), r2=grip_cone_bottom_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width]) cylinder(h=grip_cone_width, r1=top_radius - wall_thickness, r2=grip_cone_bottom_radius - wall_thickness);
                }
                difference() { // middle section cone
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - (wall_thickness / 2), r2=middle_section_cone_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width]) cylinder(h=middle_section_cone_width, r1=grip_cone_bottom_radius - wall_thickness, r2=middle_section_cone_radius - wall_thickness);
                }
                difference() { // bottom section cone
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width, r1=middle_section_cone_radius - (wall_thickness / 2), r2 = bottom_section_cone_radius - (wall_thickness / 2));
                    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width]) cylinder(h=bottom_section_cone_width - bottom_opening_width, r1=middle_section_cone_radius - wall_thickness, r2 = bottom_section_cone_radius - wall_thickness);
                }
            }
            translate([-32, -30, 0]) cube([30, 60, 1000]); // cut in half
        }
    }   
    translate([0,0,aluminium_ring_section_with + top_width + grip_cone_width + middle_section_cone_width + bottom_section_cone_width - bottom_opening_width]) cylinder(h=bottom_opening_width, r=bottom_opening_radius); // cable cutout
    translate([1, -30, 0]) cube([30, 60, 1000]); // cut in half
}
