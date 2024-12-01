// Kelly Kettle Air Box Attachment for Air-Frying, Broiling, and Steaming
// Parameters for customization
flue_diameter = 80;    // Diameter of the Kelly Kettle flue opening (mm)
flue_height = 150;     // Height of the Kelly Kettle flue that the attachment fits over (mm)
air_box_width = 200;   // Width of the Air Box (mm)
air_box_height = 100;  // Height of the Air Box (mm)
steam_spout_diameter = 20; // Diameter of the steam spout opening (mm)
vent_diameter = 10;    // Diameter of adjustable vents for temperature control (mm)
wall_thickness = 3;    // Thickness of the Air Box walls (mm)

// Main function
module air_box_attachment() {
    // Outer shell of the Air Box
    difference() {
        // Main air box volume
        translate([0, 0, flue_height])
        cube([air_box_width, air_box_width, air_box_height], true);

        // Hollowing the box
        translate([wall_thickness, wall_thickness, flue_height + wall_thickness])
        cube([air_box_width - 2 * wall_thickness, air_box_width - 2 * wall_thickness, air_box_height - wall_thickness], true);

        // Flue opening
        translate([0, 0, flue_height / 2])
        cylinder(r=flue_diameter / 2, h=air_box_height + flue_height, center=true);

        // Steam spout opening
        translate([air_box_width / 4, 0, flue_height + air_box_height / 2])
        cylinder(r=steam_spout_diameter / 2, h=wall_thickness + 1, center=true);
    }

    // Adjustable vents on the sides
    for (i = [0:90:270]) {
        rotate([0, 0, i])
        translate([air_box_width / 2 - wall_thickness - vent_diameter, 0, flue_height + air_box_height / 2])
        vent_control();
    }
}

// Module for the adjustable vent control
module vent_control() {
    // Base vent hole
    difference() {
        cylinder(r=vent_diameter / 2, h=wall_thickness + 10, center=true);

        // Vent slider (slot for adjustment)
        translate([-vent_diameter / 2, -1, -5])
        cube([vent_diameter, 2, 20]);
    }
}

// Main program call
air_box_attachment();

