// Parameters for Kelly Kettle simulacrum
kettle_base_diameter = 200;     // Diameter of the Kelly Kettle base (mm)
kettle_flue_diameter = 80;      // Diameter of the flue (mm)
kettle_flue_height = 150;       // Height of the flue (mm)

// Parameters for AirBox
air_box_width = 200;            // Width of the Air Box (mm)
air_box_height = 100;           // Height of the Air Box (mm)
wall_thickness = 3;             // Thickness of Air Box walls (mm)

// Parameters for Airflow Regulator
base_diameter = 150;            // Diameter of the regulator plates (mm)
plate_thickness = 1;            // Thickness of each regulator plate (mm)
air_channel_width = 20;         // Width of airflow channels (mm)
num_air_channels = 6;           // Number of airflow channels
rotation_limit = 45;            // Maximum rotation of regulator plates (degrees)

// Main function: Integration of all components
module integrated_model() {
    // Visualize the Kelly Kettle
    kelly_kettle();

    // Add the airflow regulator
    translate([0, 0, kettle_flue_height])
    air_regulator_system();

    // Add the Air Box
    translate([0, 0, kettle_flue_height + 2 * (plate_thickness + 0.5)])
    air_box_attachment();
}

// Simulacrum of the Kelly Kettle
module kelly_kettle() {
    // Base
    cylinder(r=kettle_base_diameter / 2, h=20, center=false);

    // Flue
    translate([0, 0, 20])
    cylinder(r=kettle_flue_diameter / 2, h=kettle_flue_height, center=false);
}

// Airflow regulator system (reused from previous design)
module air_regulator_system() {
    translate([0, 0, 0])
    base_plate();
    
    translate([0, 0, plate_thickness + 0.5])
    middle_plate();
    
    translate([0, 0, 2 * (plate_thickness + 0.5)])
    top_plate();
}

// Base Plate
module base_plate() {
    difference() {
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel();
        }
    }
}

// Middle Plate
module middle_plate() {
    difference() {
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.8);
        }
    }
}

// Top Plate
module top_plate() {
    difference() {
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i + rotation_limit / 2])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.6);
        }
    }
}

// Square air channel for regulator plates
module square_air_channel(size_factor=1) {
    square([air_channel_width * size_factor, air_channel_width * size_factor], center=true);
}

// AirBox (reused from previous design)
module air_box_attachment() {
    difference() {
        translate([0, 0, 0])
        cube([air_box_width, air_box_width, air_box_height], true);

        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([air_box_width - 2 * wall_thickness, air_box_width - 2 * wall_thickness, air_box_height - wall_thickness], true);

        translate([0, 0, -air_box_height / 2])
        cylinder(r=kettle_flue_diameter / 2, h=air_box_height + wall_thickness, center=true);
    }
}

// Render the integrated model
integrated_model();

