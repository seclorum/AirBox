// Parameters for the sheath
sheath_outer_diameter = 220;     // Outer diameter of the sheath (mm)
sheath_wall_thickness = 3;       // Thickness of the sheath walls (mm)
sheath_height = 400;             // Total height of the sheath (mm)
spout_gap_width = 30;            // Width of the spout gap (mm)
spout_gap_height = 20;           // Height of the spout gap (mm)
fire_input_gap_width = 80;       // Width of the fire input gap (mm)
fire_input_gap_height = 40;      // Height of the fire input gap (mm)

// Kelly Kettle parameters
kettle_base_diameter = 200;      // Diameter of the Kelly Kettle base (mm)
kettle_flue_diameter = 80;       // Diameter of the flue (mm)
kettle_flue_height = 150;        // Height of the flue (mm)

// Parameters for integrated components
air_box_width = 200;             // Width of the Air Box (mm)
air_box_height = 100;            // Height of the Air Box (mm)
plate_thickness = 1;             // Thickness of airflow regulator plates (mm)

base_diameter = kettle_flue_diameter + 20; // Adjusted to be 20mm larger than the flue


// Main function
module sheathed_kelly_kettle() {
    // Kelly Kettle Simulacrum
    kelly_kettle();

    // Integrated Air Regulator and AirBox
    translate([0, 0, kettle_flue_height])
    air_regulator_system();
    
    translate([0, 0, kettle_flue_height + 2 * (plate_thickness + 0.5)])
    air_box_attachment();

    // Outer Sheath
    outer_sheath();
}

// Kelly Kettle Simulacrum
module kelly_kettle() {
    // Base of the kettle
    cylinder(r=kettle_base_diameter / 2, h=20, center=false);

    // Flue
    translate([0, 0, 20])
    cylinder(r=kettle_flue_diameter / 2, h=kettle_flue_height, center=false);
}

// Airflow Regulator System
module air_regulator_system() {
    translate([0, 0, 0])
    base_plate();

    translate([0, 0, plate_thickness + 0.5])
    middle_plate();

    translate([0, 0, 2 * (plate_thickness + 0.5)])
    top_plate();
}

// Base Plate for Airflow Regulator
module base_plate() {
    difference() {
        cylinder(r=kettle_flue_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / 6 : 360 - 360 / 6]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel();
        }
    }
}

// Middle Plate for Airflow Regulator
module middle_plate() {
    difference() {
        cylinder(r=kettle_flue_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / 6 : 360 - 360 / 6]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.8);
        }
    }
}

// Top Plate for Airflow Regulator
module top_plate() {
    difference() {
        cylinder(r=kettle_flue_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / 6 : 360 - 360 / 6]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.6);
        }
    }
}

// Square Air Channel
module square_air_channel(size_factor=1) {
    square([20 * size_factor, 20 * size_factor], center=true);
}

// AirBox Attachment
module air_box_attachment() {
    difference() {
        translate([0, 0, 0])
        cube([air_box_width, air_box_width, air_box_height], true);

        translate([sheath_wall_thickness, sheath_wall_thickness, sheath_wall_thickness])
        cube([air_box_width - 2 * sheath_wall_thickness, air_box_width - 2 * sheath_wall_thickness, air_box_height - sheath_wall_thickness], true);

        translate([0, 0, -air_box_height / 2])
        cylinder(r=kettle_flue_diameter / 2, h=air_box_height + sheath_wall_thickness, center=true);
    }
}

// Outer Sheath
module outer_sheath() {
    difference() {
        // Main cylindrical body of the sheath
        cylinder(r=sheath_outer_diameter / 2, h=sheath_height, center=false);

        // Hollow interior
        translate([0, 0, sheath_wall_thickness])
        cylinder(r=(sheath_outer_diameter - 2 * sheath_wall_thickness) / 2, h=sheath_height - sheath_wall_thickness, center=false);

        // Fire input gap
        translate([-fire_input_gap_width / 2, sheath_outer_diameter / 2 - 20, 20])
        cube([fire_input_gap_width, 20, fire_input_gap_height], center=false);

        // Spout gap
        translate([-spout_gap_width / 2, sheath_outer_diameter / 2 - 20, 300])
        cube([spout_gap_width, 20, spout_gap_height], center=false);
    }
}

// Render the model
sheathed_kelly_kettle();

