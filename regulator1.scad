// Parameters for customization
base_diameter = 150;          // Diameter of the plates (mm)
pivot_diameter = 10;          // Diameter of the central pivot (mm)
plate_thickness = 1;          // Thickness of each stainless steel plate (mm)
air_channel_width = 20;       // Width of airflow channels (mm)
num_air_channels = 6;         // Number of airflow channels
rotation_limit = 45;          // Maximum rotation of middle and top plates (degrees)

// Main function
module air_regulator_system() {
    translate([0, 0, 0])
    base_plate();
    
    translate([0, 0, plate_thickness + 0.5])
    middle_plate();
    
    translate([0, 0, 2 * (plate_thickness + 0.5)])
    top_plate();
}

// Base Plate: Fixed component with open channels
module base_plate() {
    difference() {
        // Circular base
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);

        // Airflow channels
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel();
        }
    }
}

// Middle Plate: Rotatable component with partially overlapping channels
module middle_plate() {
    difference() {
        // Circular middle plate
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);

        // Adjustable airflow slots
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.8); // Slightly narrower slots
        }
    }

    // Add rotation indicator
    rotate([0, 0, rotation_limit / 2])
    translate([0, 0, plate_thickness + 0.5])
    cylinder(r=pivot_diameter / 2, h=2, center=true); // Central pivot hole
}

// Top Plate: Rotatable component with fine control slots
module top_plate() {
    difference() {
        // Circular top plate
        cylinder(r=base_diameter / 2, h=plate_thickness, center=true);

        // Smaller control slots for precise airflow adjustment
        for (i = [0 : 360 / num_air_channels : 360 - 360 / num_air_channels]) {
            rotate([0, 0, i + rotation_limit / 2])
            translate([base_diameter / 4, 0, 0])
            square_air_channel(size_factor=0.6); // Even narrower slots
        }
    }

    // Add rotation indicator
    rotate([0, 0, -rotation_limit / 2])
    translate([0, 0, plate_thickness + 0.5])
    cylinder(r=pivot_diameter / 2, h=2, center=true); // Central pivot hole
}

// Module for creating square air channels
module square_air_channel(size_factor=1) {
    square([air_channel_width * size_factor, air_channel_width * size_factor], center=true);
}

// Main program call
air_regulator_system();

