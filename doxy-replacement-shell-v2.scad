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

$fn = 128; // increase before final render
wall_thickness = 2.5;

shaft_segments = [
    [22.5, 10, 22.5, 10, 2.6],          // [0] Front plate with motor shaft cutout
    [22.5, 20, 22.5, 20, 2.4],          // [1] Motor shaft section
    [24, 20, 24, 20, 2.5],              // [2] Moter rubber ring pre-cutout
    [24, 21.5, 24, 21.5, 2.5],          // [3] Motor rubber ring cutout
    [24, 20, 24, 20, 2.5],              // [4] Moter rubber ring post-cutout
    [24, 21.5, 24, 21.5, 50],           // [5] Top straight section 
    [24, 21.5, 16.5, 14, 107],          // [6] Grip cone
    [16.5, 14, 18.8, 16.3, 26],         // [7] Middle section
    [18.8, 16.3, 10.58, 8.08, 38.36],   // [8] Bottom section
    [10.58, 6, 10, 6, 2.64]             // [9] Bottom opening
];
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

ridge_height = 1.0;

button_radius = 7.75;
button_offset = 94.4;
button_gap = 18;
button_count = 3;

screw_holder_diameter = 10;
screw_holder_inner_diameter = 4.0;
screw_holder_inner_diameter_button_half = 3.2;
screw_holder_filet_diameter = 3.2;
screw_holder_fn = 128;
screw_holder_screwhead_insert_wall_thickness = 0.5;
screw_holder_screwhead_insert_offset = 6;
screw_holder_screwhead_insert_depth = 10;
screw_holder_screwhead_insert_diameter = 7;

top_screw_holder_height = 11;
top_screw_holder_offset = 74;

pcb_screw_holder_z_offset = 155.8;
pcb_screw_holder_x_offset = -15.35;
pcb_screw_holder_height = -pcb_screw_holder_x_offset - 10.0;

bottom_screw_holder_z_offset = 190;
bottom_screw_holder_x_offset = -15;
bottom_screw_holder_height = 0 - bottom_screw_holder_x_offset + ridge_height;
epsilon = 0.001;

function sum_shaft_segment_heights(shaft_segments, from, to, sum=0) = 
    from==to ?
    sum + shaft_segments[from][4] :
    sum_shaft_segment_heights(shaft_segments, from+1, to, sum + shaft_segments[from][4]);

// caculate head end screw holder
grip_cone_start = sum_shaft_segment_heights(shaft_segments, 0, 5);
grip_cone_end = sum_shaft_segment_heights(shaft_segments, 0, 6);

grip_cone_length = grip_cone_end - grip_cone_start;
grip_cone_overlap = top_screw_holder_offset - screw_holder_diameter - screw_holder_filet_diameter - grip_cone_start;

grip_cone_overlap_percent = grip_cone_overlap / grip_cone_length;

grip_cone_reduction = shaft_segments[6][1] - shaft_segments[6][3];
foo_offset = shaft_segments[6][1] - grip_cone_overlap_percent * grip_cone_reduction;



module outer_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height) {
        polyhedron(points = [
                [outer_radius1,ridge_height,0], // 0
                [outer_radius2,0,height], // 1
                [(outer_radius2 + inner_radius2) / 2,0,height], // 2
                [(outer_radius1 + inner_radius1) / 2,0,0], // 3
                [outer_radius1,0,0], // 4
                [(outer_radius2 + inner_radius2) / 2,ridge_height,height], // 5
                [(outer_radius1 + inner_radius1) / 2,ridge_height,0], // 6
                [outer_radius2,ridge_height,height], // 7
            ],
            faces = [
                [1,2,3,4],       // bottom
                [2,5,6,3],       // right
                [5,7,0,6],       // top
                [7,1,4,0],       // left
                [3,6,0,4],       // front
                [5,2,1,7]        // back
            ],
            convexity = 10
        );
}

module inner_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height) {
        polyhedron(points = [
                [(outer_radius1 + inner_radius1) / 2,ridge_height,0], // 0
                [(outer_radius2 + inner_radius2) / 2,0,height], // 1
                [inner_radius2,0,height], // 2
                [inner_radius1,0,0], // 3
                [(outer_radius1 + inner_radius1) / 2,0,0], // 4
                [inner_radius2,ridge_height,height], // 5
                [inner_radius1,ridge_height,0], // 6
                [(outer_radius2 + inner_radius2) / 2,ridge_height,height], // 7
            ],
            faces = [
                [1,2,3,4],       // bottom
                [2,5,6,3],       // right
                [5,7,0,6],       // top
                [7,1,4,0],       // left
                [3,6,0,4],       // front
                [5,2,1,7]        // back
            ],
            convexity = 10
        );
}

module draw_shaft_segments(shaft_segments, outer_ridge, idx=0) {
    outer_radius1 = shaft_segments[idx][0];
    inner_radius1 = shaft_segments[idx][1];
    outer_radius2 = shaft_segments[idx][2];
    inner_radius2 = shaft_segments[idx][3];
    height = shaft_segments[idx][4] + epsilon;
    difference() {
        cylinder(h=height, r1=outer_radius1, r2=outer_radius2);
        translate([0, 0, -epsilon]) cylinder(h=height + 2 * epsilon, r1=inner_radius1, r2=inner_radius2);
        translate([0, -max(outer_radius1, outer_radius2) - epsilon, -epsilon]) cube([max(outer_radius1, outer_radius2) + epsilon, 2 * max(outer_radius1, outer_radius2)  + 2 * epsilon, height + 2 * epsilon]);
    }

    // Ridge

    if (outer_ridge) {
        rotate([0, 0, -90]) outer_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height);
        translate([ridge_height, 0, 0]) rotate([0, 0, 90]) outer_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height);
    } else {
        rotate([0, 0, -90]) inner_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height);
        translate([ridge_height, 0, 0]) rotate([0, 0, 90]) inner_ridge(outer_radius1, inner_radius1, outer_radius2, inner_radius2, ridge_height, height);
    }
    if(idx < len(shaft_segments) - 1) {
        translate([0, 0, height - epsilon]) draw_shaft_segments(shaft_segments, outer_ridge, idx + 1);
    }
}

module screw_hole(screw_diameter, cylinder_diameter, height, fillet_diameter, screwhead_insert_diameter, screwhead_insert_depth, screwhead_insert=false, fillet_fn=$fn) {
    if(screwhead_insert) {
        translate([0, 0, -epsilon - 10]) cylinder(d=screwhead_insert_diameter, h=height - screwhead_insert_depth, $fn=fillet_fn);
    } else {
        union() {
            difference() {
                cylinder(d=cylinder_diameter, h=height, $fn=fillet_fn);
                translate([0, 0, -epsilon]) cylinder(d=screw_diameter, h=height + 2 * epsilon, $fn=fillet_fn);
            }
            rotate_extrude(angle=365, $fn=fillet_fn) translate([cylinder_diameter / 2, 0, 0]) difference() {
                square([fillet_diameter, fillet_diameter]); 
                translate([fillet_diameter, fillet_diameter]) circle(r=fillet_diameter, $fn=fillet_fn);
            }
            for(i = [0, 180]) {
                rotate([0, 0, i])foo(cylinder_diameter, height);
            }
        }
    }
}

module foo(cylinder_diameter, height) {
    structural_support_width = 5;
    translate([(cylinder_diameter / 2) - 1, 0, 0])
    difference() {
        translate([0, -structural_support_width / 2, 0]) cube([height, structural_support_width, height]);
        translate([0, -structural_support_width / 2 - epsilon, sqrt(pow(height, 2))]) rotate([0, 45, 0]) cube([sqrt(2 * pow(height, 2)), structural_support_width + 2 * epsilon, sqrt(2 * pow(height, 2))]);
    }
}


module nonbutton_half() {
    difference() {
        union() {
            // Shaft segments
            translate([0, 0, -epsilon]) draw_shaft_segments(shaft_segments, true);

            // screw holder at the cable end of the grip
            translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter, screw_holder_diameter, 0 - bottom_screw_holder_x_offset + ridge_height, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, false, screw_holder_fn);

            // screw holder at the head end of the grip
            translate([0 - foo_offset, 0, top_screw_holder_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter, screw_holder_diameter, foo_offset + ridge_height, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, false, screw_holder_fn);
        }
        
        // screw holder at the cable end of the grip
        translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter, screw_holder_diameter, 0 - bottom_screw_holder_x_offset + ridge_height, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, true, screw_holder_fn);

        // screw holder at the head end of the grip
        translate([0 - foo_offset, 0, top_screw_holder_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter, screw_holder_diameter, foo_offset + ridge_height, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, true, screw_holder_fn);
    }
}

module button_half() {
    union() {
        difference() {
            union() {
                // Shaft segments
                translate([0, 0, -epsilon]) draw_shaft_segments(shaft_segments, false);

                // screw holder at the cable end of the grip
                translate([bottom_screw_holder_x_offset, 0, bottom_screw_holder_z_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter_button_half, screw_holder_diameter, 0 - bottom_screw_holder_x_offset, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, false, screw_holder_fn);

                // screw holder for the PCB screw

                translate([pcb_screw_holder_x_offset, 0, pcb_screw_holder_z_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter_button_half, screw_holder_diameter, pcb_screw_holder_height, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, false, screw_holder_fn);

                // screw holder at the head end of the grip
                translate([0 - foo_offset, 0, top_screw_holder_offset]) rotate([0, 90, 0]) screw_hole(screw_holder_inner_diameter_button_half, screw_holder_diameter, 7.4, screw_holder_filet_diameter, screw_holder_screwhead_insert_diameter, screw_holder_screwhead_insert_offset, false, screw_holder_fn);
            }
            
            // buttons
            for (i = [0 : button_count - 1]) {
                button_z = button_offset + button_radius + i * button_gap;
                translate([0 - top_radius, 0, button_z]) rotate([0,90,0])  cylinder(h=30, r=button_radius);
            }
        }
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

display_gap = 50;
color("Aquamarine") translate([0, -display_gap/2, 0]) nonbutton_half();
color("MediumVioletRed") translate([0, display_gap/2, 0]) button_half();
