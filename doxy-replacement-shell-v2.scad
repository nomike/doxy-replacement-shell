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

/*
    This design creates a replacement shell for the original Doxy wand massager.

    # Verbal description to introduce the terms used in this design
    
    The design is divided into multiple segments.

    Starting from the cable end, there is a small section, containing a small hole to hold the cable
    and the kink-protection. This bottom sections widens until it gets to the middle section.
    The middle section contains a screw holder used to hold the two halves of the shell together
    and get's narrower again.

    Following that, there is the grip cone which houses the buttons, the PCB and one screw holder
    for holding the PCB in place. The grip cone gets wider towards the top and is followed by the
    top straight section. The top straight section has a consistent outer diamter. It contains the
    second screw holder used to hold the two halves of the shell together. Towards the end it houses
    the motor and has a short thinner section to hold the rubber ring around the motor shaft in
    place.

    I defined the end where the cable is connected to be the bottom and the top to be the end with
    the head of the massager.

    Furthermore there are two halves. One with the buttons and one without called button half and
    nonbutton half respectively.

    On each half there is a small ridge, an inner one on the button half and and outer one the
    nonbutton half. The ridge is what keeps both halves aligned.

    The parts where screws are screwed into are called screw holders. They have angled supports
    to make them more sturdy. The main problem with the original shell is, that these screw holders
    break off after a while, which is the whole reason I am designing this replacement shell.
    Those supports should address this issue.

    The screw holder at the top has the support removed at the top to make room for the motor.

    Both screw holders holding the PCB are cut off on one side to make room for the silicon button
    inlet.

    # Printing instructions

    I printed the shell on a Prusa MK4 with PLA with a 0.4mm nozzle and 0.2mm and 0.28mm layer
    height. I used snug supports, which came off very easily. Be sure to add support inhibitors on
    the bottom of the botto and PCB screw holders on the button half. These are not necessary and
    are exceptionally hard to remove.

    I also cranked up the perimeters to 50, to make sure there is no infil. I wanted the pice to be
    as sturdy as possible and with this design this hardly had any effect on material usage or print
    time.

    Both shells should obviously be printed with the flat side down. Printing them in a standing
    position might be an option, but that would have been too large for my printer. Due to the
    lengthwise stress the massager is likely to experince during use, I assume that this would also
    reduce sturdiness due to possible layer-separation.

    # Assembly instructions

    There are two screws to take apart the original shell.
    Once you have it open, you cam remove the third internal screw which holds the PCB in place.
    With this screw removed, you can take out the PCB with the buttons and the motor.
    The motor is heavy. so be careful not to break any cables of rip them of their solder points.

    When taking out the PCB, gently push the buttons from the outside. There are small silcone tabs
    which are threaed through holes in the PCB which are quite cumbersome to be put back in place
    and easily break off when doing so. It's not a big deal if they are damaged, but try to avoid
    the hassle.

    The motor is also supported by some foam rubber pads glued into the shells. Carefully try to
    remove them and transfer them to the new shell. If you damage them somehow, you can get
    replacements in art and craft stores.

    One of the original design goals was to keep using the original screws and componments and
    except for the two printed halves not having to add anything extra. Unfortunately, I wasn't able
    to get the top screw to thread nicely info the button half. It is a M3 machine screw however,
    so I added a hole for a M3 nut to be inserted. So that's the one extra part you need to get.

    Insert the nut into the hole in the button half and screw the screw from the original shell in
    it. The screw has a long hexagonal head with a M3 screw thread inside. I used a hex-nut
    screwdriver to secure it in place.

    Next you can add the cable, PCB, motor assembly. Secure the PCB on the cable end with the short
    plastic screw from the original desigm. This screw threads directly into the printed plastic, so
    do not overtighten it!

    Ensure that the rubber ring on the motor shaft is stuck to the top bit of the shell.

    I advise to make a knot in the cable as a strain relieve. Make sure the kink-protection is
    alligned correctly.

    Once everything is in place, you can add the other half on top. Double check that no wires are
    being pinched.

    Put the aluminum ring back on the top to fix the two halves together. This is intenionally a
    tight fix to prevent the whole thing from rattling.

    Then screw in the remaining two screws again trying not to overtighten them. The plastic screw
    goes into the bottom hole. The long M3 screw goes into the top.
*/

epsilon = 0.001;  // A small value to prevent z-fighting/overlapping faces.

// Controls the detail of curved objects. Rendering time increases with higher values.
// Set it to 128 for the final rendering. When you're testing the design, you could set this to 32.
$fn = 128; 


// This defines the shaft segments, as outlined in the verbal description above.
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

// The height of the ridge.
ridge_height = 1.0;

// Defines the dimensions of the control buttons.
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

/*
 * Calculates the sum of the heights of the shaft segments from 'from' to 'to'.
 * 
 * @param shaft_segments The shaft segments to calculate the sum of the heights from.
 * @param from The index of the first shaft segment to include in the sum.
 * @param to The index of the last shaft segment to include in the sum.
 * @param _sum The sum of the heights of the shaft segments. Used internally for recursion.
 * 
 * @return The sum of the heights of the shaft segments from 'from' to 'to'.
 */

function sum_shaft_segment_heights(shaft_segments, from, to, _sum=0) = 
    from==to ?
    _sum + shaft_segments[from][4] :
    sum_shaft_segment_heights(shaft_segments, from+1, to, _sum + shaft_segments[from][4]);


/*
 * Calculates the maximum value of a specific dimension of the shaft segments.
 * 
 * @param array The array of shaft segments to calculate the maximum value from.
 * @param position The position of the dimension to calculate the maximum value from.
 * @param idx The index of the current shaft segment. Used internally for recursion.
 * @param max The current maximum value. Used internally for recursion.
 * 
 * @return The maximum value of the specific dimension of the shaft segments.
 */
function get_max_dimension(array, position, _idx=0, _max=0) = 
    _idx == len(array) ?
    _max :
    get_max_dimension(array, position, _idx + 1, max(array[_idx][position], _max));


/*
 * Calculates the index of the shaft segment based on the z_offset.
 * 
 * @param shaft_segments The shaft segments to calculate the index from.
 * @param z_offset The z offset to calculate the index for.
 * @param _idx The index of the current shaft segment. Used internally for recursion.
 * @param _sum The sum of the heights of the shaft segments. Used internally for recursion.
 * 
 * @return The index of the shaft segment based on the z_offset.
 */
function get_shaft_segment_index(shaft_segments, z_offset, _idx=0, _sum=0) =
    _sum + shaft_segments[_idx][4] >= z_offset ?
    _idx :
    get_shaft_segment_index(shaft_segments, z_offset, _idx + 1, _sum + shaft_segments[_idx][4]);


/*
 * Calculates the starting height of a shaft segment.
 * 
 * @param shaft_segments The shaft segments to calculate the starting height from.
 * @param idx The index of the shaft segment to calculate the starting height for.
 * @param _i The index of the current shaft segment. Used internally for recursion.
 * @param _sum The sum of the heights of the shaft segments. Used internally for recursion.
 * 
 * @return The starting height of the shaft segment.
 */
function get_shaft_segment_start_height(shaft_segments, idx, _i=0, _sum=0) =
    idx == _i ?
    _sum :
    get_shaft_segment_start_height(shaft_segments, idx, _i + 1, _sum + shaft_segments[_i][4]);


// caculate head end screw holder
grip_cone_start = sum_shaft_segment_heights(shaft_segments, 0, 5);
grip_cone_end = sum_shaft_segment_heights(shaft_segments, 0, 6);

grip_cone_length = grip_cone_end - grip_cone_start;
grip_cone_overlap = top_screw_holder_offset - screw_holder_diameter - screw_holder_filet_diameter - grip_cone_start;

grip_cone_overlap_percent = grip_cone_overlap / grip_cone_length;

grip_cone_reduction = shaft_segments[6][1] - shaft_segments[6][3];
foo_offset = shaft_segments[6][1] - grip_cone_overlap_percent * grip_cone_reduction;
display_gap = 1;

// Screw holders and their supports protrude out of the shell. This flag enables code which removes
// thes protrusion. This however massively slows down preview rendering and makes viewport
// manipulation very slow. Therefore cleaning could be disabled during development.
// For the final renderin, be sure to set this to true.
clean_outer_surface = false;

render_buttonhalf = true;
render_nonbuttonhalf = true;

max_diameter = max(get_max_dimension(shaft_segments, 0), get_max_dimension(shaft_segments, 2));

/*
 * Module: outer_ridge
 * 
 * Parameters:
 * - outer_radius1: The outer radius of the first end of the ridge.
 * - inner_radius1: The inner radius of the first end of the ridge.
 * - outer_radius2: The outer radius of the second end of the ridge.
 * - inner_radius2: The inner radius of the second end of the ridge.
 * - ridge_height: The height of the ridge.
 * - height: The z-height of the segment.
 * 
 * Description:
 * This module creates a ridge on a shaft segment with a rectangular cross-section.
 * The ridges are used to align the two halves of the shell.
 */
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

/*
 * Module: inner_ridge
 * 
 * Parameters:
 * - outer_radius1: The outer radius of the first end of the ridge.
 * - inner_radius1: The inner radius of the first end of the ridge.
 * - outer_radius2: The outer radius of the second end of the ridge.
 * - inner_radius2: The inner radius of the second end of the ridge.
 * - ridge_height: The height of the ridge.
 * - height: The z-height of the segment.
 * 
 * Description:
 * This module creates a ridge on a shaft segment with a rectangular cross-section.
 * The ridges are used to align the two halves of the shell.
 */
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

/*
 * Module: draw_shaft_segments
 *
 * Parameters:
 * - shaft_segments: The shaft segments to draw.
 * - outer_ridge: Flag to determine if an outer or inner ridge should be drawn.
 * - hollow: Flag to determine if the shaft segments should be hollow.
 * - _idx: The index of the current shaft segment. Used internally for recursion.
 *
 * Description:
 * This module draws the shaft segments of the shell. The clean_outer_surface code calls this with
 * thw hollow flag set to false.
 */
module draw_shaft_segments(shaft_segments, outer_ridge, hollow=true, _idx=0) {
    outer_radius1 = shaft_segments[_idx][0];
    inner_radius1 = shaft_segments[_idx][1];
    outer_radius2 = shaft_segments[_idx][2];
    inner_radius2 = shaft_segments[_idx][3];
    height = shaft_segments[_idx][4] + epsilon;
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
    // Recurse to the next segment
    if(_idx < len(shaft_segments) - 1) {
        translate([0, 0, height - epsilon]) draw_shaft_segments(shaft_segments, outer_ridge, hollow, _idx + 1);
    }
}

/*
 * Module: screw_holder_support
 *
 * Parameters:
 * - cylinder_diameter: The diameter of the cylinder to support.
 * - height: The height of the cylinder to support.
 *
 * Description:
 * The weak spot of the original shell are the screw holders which snap off easily,
 * These supports are meant to mitigate this issue.
 */
module screw_holder_support(cylinder_diameter, height) {
    translate([(cylinder_diameter / 2) - 1, 0, 0])
    difference() {
        translate([0, -screw_holder_support_width / 2, 0]) cube([height, screw_holder_support_width, height]);
        translate([0, -screw_holder_support_width / 2 - epsilon, sqrt(pow(height, 2))]) rotate([0, 45, 0]) cube([sqrt(2 * pow(height, 2)), screw_holder_support_width + 2 * epsilon, sqrt(2 * pow(height, 2))]);
    }
}



/*
 * Module: screw_thingy
 * 
 * Parameters:
 * - diameter: The diameter of the screw.
 * - z_offset: The vertical offset for the screw.
 * - add: (Optional) Additional height to be added to the screw. Default is 0.
 * - center_offset: (Optional) Offset to center the screw. Default is 0.
 * 
 * Description:
 * The two halves of the shell are held together by screws. On the button half there are cylinders
 * whicj the screws are being screwed into. On the nonbotton-half the screws are inserted.
 * 
 * This module can be used to create those structures and also the holes within them which take
 * the screw threads or the screw heads.
 * 
 * 
 * Internal Variables:
 * - shaft_segment_index: Index of the current shaft segment based on the z_offset.
 * - shaft_segment_start_height: Starting height of the current shaft segment.
 * - shaft_segment_end_height: Ending height of the current shaft segment.
 * - shaft_segment_offset: Offset within the current shaft segment.
 * - shaft_segment_offset_percent: Percentage offset within the current shaft segment.
 * - x_offset: Calculated horizontal offset for the screw.
 * 
 * Transformations:
 * - The screw is translated by [ridge_height - center_offset, 0, z_offset].
 * - The screw is rotated by [0, -90, 0].
 * - The screw is rendered as a cylinder with diameter 'diameter' and height 'x_offset + 2.5 + add - center_offset'.
 */
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

/*
 * Module: screw_thingy_support
 *
 * Parameters:
 * - diameter: The diameter of the screw.
 * - z_offset: The vertical offset for the screw.
 * - add: (Optional) Additional height to be added to the screw. Default is 0.
 * - center_offset: (Optional) Offset to center the screw. Default is 0.
 * - width: (Optional) The width of the support. Default is 5.
 * - screw_hole_support_angles: (Optional) The angles at which the screw holes are placed. Default is [0, 90, 180, 270].
 *
 * Description:
 *
 * Creates supports for a screw thingy. These supports protrude out of the shell and need to be
 * cleaned off later in the code. On top screw holder the top support has to be ommited to make room
 * for the motor, thus the angles are parameterized.
 */
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


/*
 * Module: screw_thingy_cutoff
 *
 * Parameters:
 * - diameter: The diameter of the screw.
 * - z_offset: The vertical offset for the screw.
 * - add: (Optional) Additional height to be added to the screw. Default is 0.
 * - center_offset: (Optional) Offset to center the screw. Default is 0.
 * - cutoff_width: (Optional) The width of the cutoff. Default is 1.
 *
 * Description:
 *
 * Creates a cutoff for a screw thingy. This cutoff is used to make room for the silicon buttons.
 */
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

/*
 * Module: button_holes
 *
 * Description:
 * This module creates the holes for the buttons.
 */
module button_holes() {
    for (i = [0 : button_count - 1]) {
        button_z = button_offset + button_radius + i * button_gap;
        translate([0 - shaft_segments[5][0], 0, button_z]) rotate([0,90,0])  cylinder(h=30, r=button_radius);
    }
}

/*
 * Module: button_hole_ridges
 *
 * Description:
 * This module creates ridges around the button holes.
 */
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


/*
 * Module: nonbutton_half
 *
 * Description:
 * This module creates the nonbutton half of the shell.
 */
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

/*
 * Module: button_half
 *
 * Description:
 * This module creates the button half of the shell.
 */
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
    translate([0, -display_gap - max_diameter, 0]) nonbutton_half();
}
if (render_buttonhalf) {
    translate([0, display_gap + max_diameter, 0]) button_half();
}
