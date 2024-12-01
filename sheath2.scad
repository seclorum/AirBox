// Parameters for the adjustable flue sheath
sheath_outer_diameter = 240;      // Outer diameter of the sheath (mm)
sheath_height = 400;             // Total height of the sheath (mm)
wall_thickness = 5;              // Wall thickness (mm)
inner_airbox_diameter = 150;     // Diameter of the internal air box (mm)
inner_airbox_height = 120;       // Height of the internal air box (mm)
flue_channel_diameter = 80;      // Diameter of the flue channel (mm)
steam_channel_diameter = 40;     // Diameter of the steam channel (mm)
fuel_access_width = 100;         // Width of the fuel access opening (mm)
fuel_access_height = 80;         // Height of the fuel access opening (mm)
spout_gap_width = 40;            // Width of the spout access opening (mm)
spout_gap_height = 30;           // Height of the spout access opening (mm)

kettle_flue_diameter = 80;       // Diameter of the flue (mm)

base_diameter = kettle_flue_diameter + 20; // Adjusted to be 20mm larger than the flue
// Parameters for the rotating control
rotating_input_diameter = 100;    // Diameter of the rotating input disk (mm)
rotating_input_thickness = 10;    // Thickness of the rotating control disk (mm)

// Main function
module adjustable_flue_sheath_with_openings() {
    // Outer sheath with integrated air box and access openings
    difference() {
        // Main rounded sheath
        cylinder(r=sheath_outer_diameter / 2, h=sheath_height, center=false);

        // Hollow interior
        translate([0, 0, wall_thickness])
        cylinder(r=(sheath_outer_diameter - 2 * wall_thickness) / 2, h=sheath_height - wall_thickness, center=false);

        // Internal air box
        translate([0, 0, sheath_height - inner_airbox_height])
        cylinder(r=inner_airbox_diameter / 2, h=inner_airbox_height, center=false);

        // Fuel access opening
        translate([0, sheath_outer_diameter / 4, fuel_access_height / 2])
        rounded_rectangle(fuel_access_width, fuel_access_height, wall_thickness);

        // Spout access opening
        translate([0, sheath_outer_diameter / 4, sheath_height - inner_airbox_height - spout_gap_height / 2])
        rounded_rectangle(spout_gap_width, spout_gap_height, wall_thickness);

        // Flue and steam channel paths
        flue_channel();
        steam_channel();
    }

    // Rotating control mechanism
    translate([0, 0, sheath_height - inner_airbox_height / 2])
    rotating_control();
}

// Rotating control mechanism
module rotating_control() {
    difference() {
        // Main control disk
        cylinder(r=rotating_input_diameter / 2, h=rotating_input_thickness, center=false);

        // Slots for air/steam control
        for (i = [0 : 60 : 360 - 60]) {
            rotate([0, 0, i])
            translate([rotating_input_diameter / 4, 0, 0])
            cylinder(r=5, h=rotating_input_thickness + 1, center=true);
        }
    }
}

// Fire-flue channel
module flue_channel() {
    translate([0, 0, flue_channel_offset()])
    cylinder(r=flue_channel_diameter / 2, h=sheath_height, center=false);
}

// Steam channel
module steam_channel() {
    translate([0, 0, steam_channel_offset()])
    cylinder(r=steam_channel_diameter / 2, h=sheath_height, center=false);
}

// Rounded rectangle helper function
module rounded_rectangle(width, height, thickness) {
    difference() {
        // Outer rounded rectangle
        minkowski() {
            square([width - thickness, height - thickness], center=true);
            circle(r=thickness / 2);
        }

        // Hollow interior
        translate([0, 0, -1])
        minkowski() {
            square([width - 2 * thickness, height - 2 * thickness], center=true);
            circle(r=(thickness / 2) - 1);
        }
    }
}

// Helpers to calculate offsets
function flue_channel_offset() = sheath_height - 80;
function steam_channel_offset() = sheath_height - 40;

// Render the adjustable flue sheath with openings
adjustable_flue_sheath_with_openings();
