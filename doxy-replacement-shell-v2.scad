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


shaft_segments = [                      // outer_radius1, inner_radius1, outer_radius2, inner_radius2, height
    [22.0, 10, 22.0, 10, 2.6],          // [0] Front plate with motor shaft cutout
    [22.0, 20, 22.0, 20, 2.4],          // [1] Motor shaft section
    [24, 20, 24, 20, 2.5],              // [2] Moter rubber ring pre-cutout
    [24, 21.5, 24, 21.5, 2.5],          // [3] Motor rubber ring cutout
    [24, 20, 24, 20, 2.5],              // [4] Moter rubber ring post-cutout
    [24, 21.5, 24, 21.5, 50],           // [5] Top straight section 
    [24, 21.5, 16.5, 14, 107],          // [6] Grip cone
    [16.5, 14, 18.8, 16.3, 26],         // [7] Middle section
    [18.8, 16.3, 10.58, 8.08, 38.36],   // [8] Bottom section
    [10.58, 6, 10, 6, 2.64]             // [9] Bottom opening
];

top_width = 55;         // TODO: Calculate this from the shaft_segments
grip_cone_width = 107;  // TODO: Calculate this from the shaft_segments

ridge_height = 1.0;

button_radius = 8.05;
button_offset = 94.4;
button_gap = 18;
button_count = 3;

screw_holder_diameter = 10;
screw_holder_inner_diameter = 4.0;
screw_holder_inner_diameter_button_half = 3.0;
screw_holder_filet_diameter = 3.2;
screw_holder_fn = 128;
screw_holder_screwhead_insert_offset_cable = 3.5;
screw_holder_screwhead_insert_offset_pcb = 6;
screw_holder_screwhead_insert_offset_head = 2.5;
screw_holder_screwhead_insert_diameter = 7;
screw_holder_support_width = 5;

top_screw_holder_offset = 74;

pcb_screw_holder_z_offset = 155.8;
pcb_screw_holder_x_offset = -15.35;
pcb_screw_holder_height = -pcb_screw_holder_x_offset - 10.0;
silicon_button_piece_thickness = 1;

bottom_screw_holder_z_offset = 190;
bottom_screw_holder_x_offset = -17;
epsilon = 0.001;

function sum_shaft_segment_heights(shaft_segments, from, to, sum=0) = 
    from==to ?
    sum + shaft_segments[from][4] :
    sum_shaft_segment_heights(shaft_segments, from+1, to, sum + shaft_segments[from][4]);

function get_max_dimension(array, position, idx=0, max=0) = 
    idx == len(array) ?
    max :
    get_max_dimension(array, position, idx + 1, max(array[idx][position], max));

function get_shaft_segment_index(shaft_segments, z_offset, idx=0, sum=0) =
    sum + shaft_segments[idx][4] >= z_offset ?
    idx :
    get_shaft_segment_index(shaft_segments, z_offset, idx + 1, sum + shaft_segments[idx][4]);


function get_shaft_segment_start_height(shaft_segments, idx, i=0, sum=0) =
    idx == i ?
    sum :
    get_shaft_segment_start_height(shaft_segments, idx, i + 1, sum + shaft_segments[i][4]);


// caculate head end screw holder
grip_cone_start = sum_shaft_segment_heights(shaft_segments, 0, 5);
grip_cone_end = sum_shaft_segment_heights(shaft_segments, 0, 6);

grip_cone_length = grip_cone_end - grip_cone_start;
grip_cone_overlap = top_screw_holder_offset - screw_holder_diameter - screw_holder_filet_diameter - grip_cone_start;

grip_cone_overlap_percent = grip_cone_overlap / grip_cone_length;

grip_cone_reduction = shaft_segments[6][1] - shaft_segments[6][3];
foo_offset = shaft_segments[6][1] - grip_cone_overlap_percent * grip_cone_reduction;
display_gap = 1;

clean_outer_surface = false;

render_buttonhalf = true;
render_nonbuttonhalf = true;

max_diameter = max(get_max_dimension(shaft_segments, 0), get_max_dimension(shaft_segments, 2));

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

module draw_shaft_segments(shaft_segments, outer_ridge, hollow=true, idx=0) {
    outer_radius1 = shaft_segments[idx][0];
    inner_radius1 = shaft_segments[idx][1];
    outer_radius2 = shaft_segments[idx][2];
    inner_radius2 = shaft_segments[idx][3];
    height = shaft_segments[idx][4] + epsilon;
    difference() {
        cylinder(h=height, r1=outer_radius1, r2=outer_radius2);
        if (hollow) {
            translate([0, 0, -epsilon]) cylinder(h=height + 2 * epsilon, r1=inner_radius1, r2=inner_radius2);
        }
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
        translate([0, 0, height - epsilon]) draw_shaft_segments(shaft_segments, outer_ridge, hollow, idx + 1);
    }
}

module screw_holder_support(cylinder_diameter, height) {
    translate([(cylinder_diameter / 2) - 1, 0, 0])
    difference() {
        translate([0, -screw_holder_support_width / 2, 0]) cube([height, screw_holder_support_width, height]);
        translate([0, -screw_holder_support_width / 2 - epsilon, sqrt(pow(height, 2))]) rotate([0, 45, 0]) cube([sqrt(2 * pow(height, 2)), screw_holder_support_width + 2 * epsilon, sqrt(2 * pow(height, 2))]);
    }
}


module screw_thingy(diameter, z_offset, add=0, center_offset=0) {
    shaft_segment_index = get_shaft_segment_index(shaft_segments, z_offset);
    shaft_segment_start_height = get_shaft_segment_start_height(shaft_segments, shaft_segment_index);
    shaft_segment_end_height = shaft_segment_start_height + shaft_segments[shaft_segment_index][4];
    shaft_segment_offset = z_offset - shaft_segment_start_height;

    shaft_segment_offset_percent = shaft_segment_offset / shaft_segments[shaft_segment_index][4];
    x_offset = shaft_segments[shaft_segment_index][0] - shaft_segment_offset_percent * (shaft_segments[shaft_segment_index][0] - shaft_segments[shaft_segment_index][2])
        + shaft_segments[shaft_segment_index][1] - shaft_segments[shaft_segment_index][0] + ridge_height;

    translate([ridge_height - center_offset, 0, z_offset]) rotate([0, -90, 0]) cylinder(d=diameter, h=x_offset + 2.5 + add - center_offset);
}

module screw_thingy_support(diameter, z_offset, add=0, center_offset=0, width=5, screw_hole_support_angles=[0, 90, 180, 270]) {
    shaft_segment_index = get_shaft_segment_index(shaft_segments, z_offset);
    shaft_segment_start_height = get_shaft_segment_start_height(shaft_segments, shaft_segment_index);
    shaft_segment_end_height = shaft_segment_start_height + shaft_segments[shaft_segment_index][4];
    shaft_segment_offset = z_offset - shaft_segment_start_height;

    shaft_segment_offset_percent = shaft_segment_offset / shaft_segments[shaft_segment_index][4];
    x_offset = shaft_segments[shaft_segment_index][0] - shaft_segment_offset_percent * (shaft_segments[shaft_segment_index][0] - shaft_segments[shaft_segment_index][2])
        + shaft_segments[shaft_segment_index][1] - shaft_segments[shaft_segment_index][0] + ridge_height;

    translate([ridge_height - (x_offset + 2.5 + add) - epsilon, 0, z_offset]) rotate([0, 90, 0]) { // TODO: Calculate or parameterize harcoded values
        for(i = screw_hole_support_angles) {
            rotate([0, 0, i]) screw_holder_support(diameter, x_offset + 2.5 + add - center_offset); // TODO: Calculate or parameterize harcoded values
        }
    }
}

module screw_thingy_cutoff(diameter, z_offset, add=0, center_offset, cutoff_width=1) {
    shaft_segment_index = get_shaft_segment_index(shaft_segments, z_offset);
    shaft_segment_start_height = get_shaft_segment_start_height(shaft_segments, shaft_segment_index);
    shaft_segment_end_height = shaft_segment_start_height + shaft_segments[shaft_segment_index][4];
    shaft_segment_offset = z_offset - shaft_segment_start_height;

    shaft_segment_offset_percent = shaft_segment_offset / shaft_segments[shaft_segment_index][4];
    x_offset = shaft_segments[shaft_segment_index][0] - shaft_segment_offset_percent * (shaft_segments[shaft_segment_index][0] - shaft_segments[shaft_segment_index][2])
        + shaft_segments[shaft_segment_index][1] - shaft_segments[shaft_segment_index][0] + ridge_height;
    translate([ridge_height - center_offset - cutoff_width + epsilon, -diameter / 2, z_offset - diameter * (5/4)]) cube([cutoff_width, diameter, diameter]);    
}


module nonbutton_half() {
    difference() {
        union() {
            // Shaft segments
            translate([0, 0, -epsilon]) draw_shaft_segments(shaft_segments, true, true);

            // Screw holder at the cable end of the grip
            screw_thingy(screw_holder_diameter, bottom_screw_holder_z_offset);
            screw_thingy_support(screw_holder_diameter, bottom_screw_holder_z_offset);
            
            // screw holder at the head end of the grip
            screw_thingy(screw_holder_diameter, top_screw_holder_offset, 0, -9);    // TODO: Calculate or parameterize harcoded values
            screw_thingy_support(screw_holder_diameter, top_screw_holder_offset, 0, -7, 5, [90,180, 270]);  // TODO: Calculate or parameterize harcoded values
        }

        // screw holder at the cable end of the grip
        translate([epsilon, 0, 0]) screw_thingy(screw_holder_inner_diameter, bottom_screw_holder_z_offset, 1 + 2 * epsilon);    // TODO: Calculate or parameterize harcoded values
        translate([epsilon, 0, 0]) screw_thingy(screw_holder_screwhead_insert_diameter, bottom_screw_holder_z_offset, 1 + 2 * epsilon, 3.15);   // TODO: Calculate or parameterize harcoded values
        
        // screw holder at the head end of the grip
        translate([epsilon, 0, 0]) screw_thingy(screw_holder_inner_diameter, top_screw_holder_offset, 1 + 2 * epsilon, -9); // TODO: Calculate or parameterize harcoded values
        translate([epsilon, 0, 0]) screw_thingy(screw_holder_screwhead_insert_diameter, top_screw_holder_offset, 1 + 2 * epsilon, 3.85);    // TODO: Calculate or parameterize harcoded values

        if (clean_outer_surface) {
            clean_cube_height = sum_shaft_segment_heights(shaft_segments, 0, len(shaft_segments) -1) + epsilon;
            clean_cube_width = max(get_max_dimension(shaft_segments, 0), get_max_dimension(shaft_segments, 2)) * 3 + epsilon;
            echo(clean_cube_width);
            translate([0, 0, 0])  difference() {
                translate([-clean_cube_width - ridge_height, -clean_cube_width / 2, 0]) cube([clean_cube_width, clean_cube_width, clean_cube_height]);
                translate([0, 0, epsilon]) scale([1.001, 1.001, 1.001]) draw_shaft_segments(shaft_segments, true, false);
            }
        }
    }
}

module button_holes() {
    for (i = [0 : button_count - 1]) {
        button_z = button_offset + button_radius + i * button_gap;
        translate([0 - shaft_segments[5][0], 0, button_z]) rotate([0,90,0])  cylinder(h=30, r=button_radius);
    }
}

module button_hole_ridges() {
    for (i = [0 : button_count - 1]) {
        button_z = button_offset + button_radius + i * button_gap;
        grip_cone_z = shaft_segments[0][4] + top_width;
        grip_cone_z2 = grip_cone_z + grip_cone_width;

        button_percent = (button_z - grip_cone_z) / (grip_cone_z2 - grip_cone_z);
        button_x_offset = shaft_segments[5][0] - ((shaft_segments[5][0] - shaft_segments[6][2]) * button_percent);
        difference() {
            translate([0 - button_x_offset + 1, 0, button_z]) rotate([0,90,0])  cylinder(h=4, r=button_radius + 1); // TODO: Calculate or parameterize harcoded values
            translate([0 - button_x_offset - 5, 0, button_z]) rotate([0,90,0])  cylinder(h=60, r=button_radius);    // TODO: Calculate or parameterize harcoded values
        }
    }
}

module button_half() {
    union() {
        difference() {
            union() {
                // Shaft segments
                translate([0, 0, -epsilon]) draw_shaft_segments(shaft_segments, false, true);

                // screw holder at the cable end of the grip
                screw_thingy(screw_holder_diameter, bottom_screw_holder_z_offset);
                screw_thingy_support(screw_holder_diameter, bottom_screw_holder_z_offset);

                // screw holder for the PCB screw
                screw_thingy(screw_holder_diameter, pcb_screw_holder_z_offset, 0, 11);
                screw_thingy_support(screw_holder_diameter, pcb_screw_holder_z_offset, 0, 11);


                // screw holder at the head end of the grip
                screw_thingy(screw_holder_diameter + 4, top_screw_holder_offset, 0, 16.4);  // TODO: Calculate or parameterize harcoded values
                screw_thingy_support(screw_holder_diameter + 4, top_screw_holder_offset, 0, 16.4);  // TODO: Calculate or parameterize harcoded values

                button_hole_ridges();
            }            
            translate([epsilon, 0, 0]) screw_thingy(screw_holder_inner_diameter_button_half, bottom_screw_holder_z_offset, 2 * epsilon - 2.5);  // TODO: Calculate or parameterize harcoded values
            translate([epsilon, 0, 0]) screw_thingy(screw_holder_inner_diameter_button_half, pcb_screw_holder_z_offset, 2 * epsilon - 2.5, 11); // TODO: Calculate or parameterize harcoded values
            translate([epsilon, 0, 0]) screw_thingy(screw_holder_inner_diameter_button_half, top_screw_holder_offset, 2 * epsilon - 1.5, 16.4); // TODO: Calculate or parameterize harcoded values
            translate([epsilon, 0, 0]) screw_thingy(6.45, top_screw_holder_offset, 2 * epsilon - 1.5 + 2.5, 19.5, $fn=6);   // TODO: Calculate or parameterize harcoded values
            
            

            screw_thingy_cutoff(screw_holder_diameter + 4, top_screw_holder_offset + 20, 0, 16.4 - epsilon, silicon_button_piece_thickness);    // TODO: Calculate or parameterize harcoded values
            // Small cutoff from the PCB screw holder to make room for the silicon buttons
            screw_thingy_cutoff(screw_holder_diameter, pcb_screw_holder_z_offset, 0, 11, silicon_button_piece_thickness);   // TODO: Calculate or parameterize harcoded values
            
            button_holes();
            if (clean_outer_surface) {
                clean_cube_height = sum_shaft_segment_heights(shaft_segments, 0, len(shaft_segments) -1) + epsilon;
                clean_cube_width = max(get_max_dimension(shaft_segments, 0), get_max_dimension(shaft_segments, 2)) * 3 + epsilon;
                echo(clean_cube_width);
                translate([0, 0, 0])  difference() {
                    translate([-clean_cube_width - ridge_height, -clean_cube_width / 2, 0]) cube([clean_cube_width, clean_cube_width, clean_cube_height]);
                    translate([0, 0, epsilon]) scale([1.001, 1.001, 1.001]) draw_shaft_segments(shaft_segments, true, false);   // TODO: Figure out why this scaling is necessart,
                }
            }
        }
    }
}


if (render_nonbuttonhalf) {
    // color("Aquamarine")
    translate([0, -display_gap - max_diameter, 0]) nonbutton_half();
}
if (render_buttonhalf) {
    // color("Tomato")
    translate([0, display_gap + max_diameter, 0]) button_half();
}
