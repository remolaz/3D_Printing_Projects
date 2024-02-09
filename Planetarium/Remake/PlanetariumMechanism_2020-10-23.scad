/*
Project written by Patrick Gaston, 9/2020. It is based on the planetarium model of Ken Condal, posted by him online at http://www.zeamon.com/download/ZeamonOrrery.pdf.

Refactored and tweaked by HackerJack42.  Switched to the english fork of "Getriebe.scad" named "Gears.scad" by Chris Spencer.  https://github.com/chrisspen/gears

This project requires "Getriebe.scad", (https://www.thingiverse.com/thing:1604369) created by Dr Jörg Janssen, distributed under "Creative Commons - Attribution, Non Commercial, Share Alike" in 6/2016. "Getriebe.scad" must be in the same directory as this file.

Assembly guide: https://youtu.be/gCyWxUscdN0
*/

include <Gears.scad>;

/* [Hidden] */
rez_lo = 32;
rez_mid = 64;
rez_hi = 96;
epsilon = 0.02;
modul = 1;

thickness_finger_wheel = 5;  //No real reason to hide this.  It affects the placement of the wheel relative to the top of the housing.



/* [Colors] */
color_clutch = "BurlyWood";
color_planet_arm = "RosyBrown";
color_idler_arm = "MediumPurple";
color_gear_pegless = "LightSeaGreen";
color_gear_pegged = "CornflowerBlue";
color_gear_idler = "Thistle";
color_bearing_unattached = "Violet";



/* [Calendar Settings] */
calendar_font = "Liberation Sans";
calendar_font_size = 8;
calendar_thickness_letters = 1; //vertical extrusion
calendar_thickness_small_marks = 1;
calendar_thickness_big_marks = 1;
calendar_width_small_marks = 0.6;
calendar_width_big_marks = 1.2;
calendar_height_small_marks = 4;
calendar_height_big_marks = 6;
calendar_radius_words = 63;
calendar_radius_marks = 64;
calendar_month_name = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
calendar_month_days = [365, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];



/* [Tolerances and Main Sizes] */
//Scale the model in X and Y, but not Z.  NOTE: Vertical screw hole sizes are not corrected.
model_scale = 100; //[50:5:150]
model_scale_percent = model_scale / 100;
//For press-fit, non-rotating parts
slop_radial_tight = 0.12; //[0:0.01:0.5]
//For parts meant to fit snug, but be able to rotate
slop_radial_slide = 0.16; //[0:0.01:0.5]
//For rotating parts
slop_radial_loose = 0.20; //[0:0.01:0.5]

slop_radial_tight_adjusted = slop_radial_tight / model_scale_percent; //[0:0.01:0.5]
slop_radial_slide_adjusted = slop_radial_slide / model_scale_percent; //[0:0.01:0.5]
slop_radial_loose_adjusted = slop_radial_loose / model_scale_percent; //[0:0.01:0.5]

//Adjustment for imprecise Z height on printed objects
printer_z_comp = 0.1; //[-0.3:0.05:0.3]
//Experimental value to compensate for inexact tooth meshing. Adds to calculated length.
idler_length_correction = 0.4; //[0:0.05:0.5]
//Base measurement for gears, arms, and idlers.
thickness_gear = 5.0; //[3.0:0.1:6]
thickness_bearing = 2.0; //[1.0:0.1:5]
thickness_axle_wall = 3.0; //[2.5:0.1:5]
//Adjusts the radii of each gear in the base.  This affects the size and spacing of the base.
base_gear_mesh_compensation = 0.05; //[0:0.05:0.5]



/* [Settings - Base] */
radius_wheel_large = radius_contact(136) + base_gear_mesh_compensation;
radius_wheel_small = radius_contact(22) + base_gear_mesh_compensation;



radius_finger_wheel = 40;
radial_space_beyond_contact_radius = 5;
mounting_hole_clearance_diameter = 3.5;
mounting_hole_thread_minor_diameter = 2.6;
radius_to_mounting_holes = 24;



base_thickness_floor = 2;
base_thickness_wall  = 2;
base_thickness_roof  = 5;
base_height_total    = 32;

main_axle_base_height = 40;




/* [Settings - Upper Mechanism] */
planet_arm_peg_cone_height = 3*thickness_gear;
planet_arm_screw_block_width = 10;
//Size of screw hole.  Sized for M3 screws.
planet_arm_screwhole_diameter = 2.80;
radius_platform = 30;
radius_planet_peg = 2;
radius_planet_peghole = radius_planet_peg + slop_radial_slide_adjusted;
radius_clutch_rim = 4; //How far beyond clutch hole the clutched arm should extend radially
radius_idler_axle = 5;
//Must be larger than the planet peg or it won't rotate.
radius_moon_axle = 2.7;

slot_width = 3;
slot_depth = 2;
peg_width = slot_width - 2*slop_radial_loose_adjusted;
peg_depth = slot_depth - slop_radial_tight_adjusted;

//Percent of axle radius that is flattened to prevent free rotation
offset_gear_grip = 0.8;

//Mercury Drive and Main Shaft diameters are derived from this.  Changing this will change ALL parts.
sun_axle_radius = 2.0;




stack_start = base_height_total + main_axle_base_height;

//Combined height of a gear and a bearing
layer_height = thickness_gear + thickness_bearing + printer_z_comp;


mercury_axle_radius = sun_axle_radius + thickness_axle_wall;  //NOTE: The slop should be added/subtracted where it's used.  ID or OD.
mercury_axle_height = stack_start + 21*layer_height;

outer_axle_radius = mercury_axle_radius + thickness_axle_wall;  //NOTE: The slop should be added/subtracted where it's used.  ID or OD.
outer_axle_height = 19*layer_height;

outer_shaft_radius = 1.5*outer_axle_radius + radius_clutch_rim + slop_radial_slide_adjusted;

echo ("Axle Radius: ", outer_shaft_radius * model_scale_percent);
echo ("Axle Height: ", outer_axle_height);


//-------------------------------------------------------

/* [Render - Misc Objects] */
Render_All_Pegs                  = false;
Render_VisualPlanets             = false;

Render_Idler_Axle                = false;
Render_Printable_Planets         = false;

/* [Render - Base and Stand] */
Render_Floor                     = false;
Render_MainDriveGear             = false;
Render_FingerDriveGear           = false;
Render_FingerWheelAxle           = false;
Render_FingerWheelSupport        = false;
Render_FingerWheel               = false;
Render_Housing                   = false;
Render_Main_Axle                 = false;
Render_Sun_Axle                  = false;
Render_Mercury_Axle              = false;

/* [Render - Saturn] */
Render_SaturnPlanetArm           = false;
Render_SaturnPeg                 = false;
Render_SaturnGearIn106T          = false;
Render_BearingOnSaturnGearIn106T = false;

/* [Render - Jupiter] */
Render_JupiterIdlerArm           = false;
Render_JupiterGearOut85T         = false;
Render_JupiterPlanetArm          = false;
Render_JupiterPeg                = false;
Render_JupiterGearIn106T         = false;
Render_JupiterIdlerIn44T         = false;
Render_JupiterIdlerOut22T        = false;

/* [Render - Mars] */
Render_MarsIdlerArm              = false;
Render_MarsGearOut56T            = false;
Render_MarsPlanetArm             = false;
Render_MarsPeg                   = false;
Render_MarsGearIn106T            = false;
Render_MarsIdlerIn73T            = false;
Render_MarsIdlerOut22T           = false;

/* [Render - Earth] */
Render_EarthIdlerArm             = false;
Render_EarthGearOut92            = false;
Render_EarthPlanetArm            = false;
Render_EarthPeg                  = false;
Render_EarthGearIn47T            = false;
Render_EarthIdlerIn36T           = false;
Render_EarthIdlerOut22T          = false;

/* [Render - Moon] */
Render_MoonGear11T               = false;
Render_MoonArm                   = false;
Render_MoonPeg                   = false;

/* [Render - Calendar] */
Render_CalendarGear              = false;
Render_CalendarIdlerIn31T        = false;
Render_CalendarIdlerOut23T       = false;

/* [Render - Venus] */
Render_VenusGearOut39T           = false;
Render_VenusPlanetArm            = false;
Render_VenusPeg                  = false;
Render_VenusGearIn42T            = false;

/* [Render - Mercury] */
Render_MercuryIdlerArm           = false;
Render_MercuryGearOut28T         = false;
Render_MercuryPlanetArm          = false;
Render_MercuryPeg                = false;
Render_MercuryCap                = false;
Render_MercuryIdlerIn33T         = false;
Render_MercuryIdlerOut19T        = false;




peg_sun     =  28*(layer_height) + stack_start ; //sun_axle_height;
peg_mercury =   6*(layer_height);
peg_venus   =  10*(layer_height);
peg_moon    =  12*(layer_height);
peg_earth   =  14*(layer_height);
peg_mars    =  18*(layer_height);
peg_jupiter =  22*(layer_height);
peg_saturn  =  26*(layer_height);

peg_sun_difference = peg_sun - peg_saturn - stack_start;

peg_heights = [
    peg_mercury,
    peg_venus,
    peg_moon,
    peg_earth,
    peg_sun,
    peg_saturn,
    peg_jupiter,
    peg_mars
];

if ( Render_All_Pegs ) {
    scale([1,model_scale_percent,model_scale_percent]) {
        All_Pegs();
    }
}

if ( Render_VisualPlanets ) {
        planet_base_height = base_thickness_floor + peg_sun - peg_sun_difference;
        color("Yellow") {
            translate([0,0,planet_base_height + peg_sun_difference]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([0,0,0]) {
                        sphere(r = 15);   // Sun
                    }
                }
            }
        }

        color("lime") {
            translate([0,0,planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([166,0,0]) {
                        sphere(r = 10);   // Saturn
                    }
                }
            }
        }

        color("orange") {
            translate([0,0, planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([140,0,0]) {
                        sphere(r = 12);   // Jupiter
                    }
                }
            }
        }

        color("red") {
            translate([0,0, planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([115,0,0]) {
                        sphere(r = 7);    // Mars
                    }
                }
            }
        }

        color("blue") {
            translate([0,0, planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([idler_length_correction + radius_contact(147) + radius_contact(11),0,0]) {
                        sphere(r = 8);     // Earth
                    }
                }
            }
        }

        color("white") {
            translate([0,0, planet_base_height + (layer_height)]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([15 + idler_length_correction + radius_contact(147) + radius_contact(11),0,0]) {
                        sphere(r = 4);    // Moon
                    }
                }
            }
        }

        color("LemonChiffon") {
            translate([0,0, planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([51,0,0]) {
                        sphere(r = 7);    // Venus
                    }
                }
            }
        }

        color("DarkSlateGray") {
            translate([0,0, planet_base_height]) {
                scale([model_scale_percent,model_scale_percent,model_scale_percent]) {
                    translate([29,0,0]) {
                        sphere(r = 6);    // Mercury
                    }
                }
            }
        }
}

if ( Render_Sun_Axle ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([0,0,base_thickness_floor]) {
            planet_peg(peg_height = peg_sun);
        }
    }
}

if ( Render_Mercury_Axle ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([0,0,base_thickness_floor+5]) {
            mercury_axle();
        }
    }
}

if ( Render_Idler_Axle ) {
    //Short axles that connect any 2 idler gears in a set
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([0,0,0]) {
            idler_axle();
        }
    }
}

if ( Render_Printable_Planets ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([0,0,0]) {
            printable_planets();
        }
    }
}

if ( Render_Housing ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color("DimGrey") {
            translate([0,0,0]) {
                Housing();
            }
        }
    }
}

if ( Render_Floor ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color("DarkGrey") {
            translate([0,0,0]) {
                Floor();
            }
        }
    }
}

if ( Render_Main_Axle ) {
    //Main support axle for majority of planets and idlers.
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([0,0,base_height_total]) {
            Main_Axle();
        }
    }
}

if ( Render_FingerWheel ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color("SaddleBrown") {
            translate([radius_wheel_large + radius_wheel_small, 0,base_height_total - base_thickness_roof - thickness_finger_wheel]) {
                mirror([1,0,0]) {
                    FingerWheel();
                }
            }
        }
    }
}

if ( Render_FingerWheelSupport ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color("LightGrey") {
            translate([radius_wheel_large + radius_wheel_small,0,base_thickness_floor]) {
                FingerWheelSupport();
            }
        }
    }
}

if ( Render_MainDriveGear ) {
    //Main drive wheel
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegged) {
            translate([0,0,base_thickness_floor + 10]) {
                make_gear_extended(tooth_count = 136, spoke_count = 6, count_pegs = 0, width_spoke_inner = 20, width_spoke_outer = 10, thickness_outer_rim = 10, radius_central_cylinder = mercury_axle_radius + slop_radial_slide_adjusted, radius_axis = mercury_axle_radius + slop_radial_slide_adjusted, radius_bearing = 0, gear_type = "spur", include_axle_grip = true);
            }
        }
    }
}

if ( Render_FingerDriveGear ) {
    //Minor wheel
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegged) {
            translate([radius_wheel_large + radius_wheel_small,0, base_thickness_floor + 10]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 22, spoke_count = 0, count_pegs = 0, width_spoke_inner = 20, width_spoke_outer = 10, thickness_outer_rim = 10, radius_central_cylinder = radius_idler_axle + slop_radial_slide_adjusted, radius_axis = radius_idler_axle + slop_radial_slide_adjusted, radius_bearing = 0, gear_type = "spur", include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_FingerWheelAxle ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([radius_wheel_large + radius_wheel_small,0,base_thickness_floor]) {
            mirror([1,0,0]) {
                FingerWheelAxle();
            }
        }
    }
}

//--------------------SATURN--------------------SATURN--------------------SATURN--------------------

if ( Render_SaturnPlanetArm ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            translate([0,0, stack_start]) {
                rotate([0,0,0]) {
                    planet_arm(radius_large_hole = 1.5*outer_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 166, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear); //old length 181
                }
            }
        }
    }
}

if ( Render_SaturnPeg ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([166, 0, stack_start + thickness_bearing]) {
            planet_peg(peg_height = peg_saturn);
        }
    }
}

if ( Render_SaturnGearIn106T ) {
    //SaturnPlanetClutch. Should be fused with SaturnGearIn106T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_clutch) {
            translate([0,0, stack_start]) {
                clutch_single(radius_clutch_outer = 1.5*outer_axle_radius, radius_clutch_inner = outer_axle_radius + slop_radial_loose_adjusted, thickness_clutch = layer_height, has_bearing = false);
            }
        }

        //SaturnGearIn106T. Should be fused with SaturnPlanetClutch. Mirrored because it will be printed upside down once clutch attached.
        color(color_gear_pegless) {
            translate([0,0,stack_start + layer_height]) {
                mirror([1, 0, 0]) {
                    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0);
                }
            }
        }
    }
}

if ( Render_BearingOnSaturnGearIn106T ) {
    //Bearing, sits on top of SaturnGearIn106T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_bearing_unattached) {
            translate([0,0,stack_start + 2*(thickness_gear) + thickness_bearing + printer_z_comp]) {
                bearing(radius_inner = outer_axle_radius + slop_radial_loose_adjusted, radius_outer = outer_shaft_radius);
            }
        }
    }
}

//--------------------JUPITER--------------------JUPITER--------------------JUPITER--------------------
if ( Render_JupiterIdlerArm ) {
    //JupiterIdlerArm from 85T to 44T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_idler_arm) {
            translate([0,0,stack_start + 2*(layer_height)]) {
                idler_arm(radius_large_hole = outer_axle_radius + slop_radial_tight_adjusted, radius_small_hole = radius_idler_axle + slop_radial_loose_adjusted, length_arm = idler_length_correction + radius_contact(85) + radius_contact(44), radius_bearing = outer_shaft_radius); //Old length 65.983
            }
        }
    }
}

if ( Render_JupiterGearOut85T ) {
    //JupiterGearOut85T. Should be printed fused with JupiterGearOutClutch.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            translate([0,0,stack_start + 3*(layer_height)]) {
                make_gear_extended(tooth_count = 85, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0);
            }
        }

        //JupiterGearOutClutch. Should be printed fused with JupiterGearOut85T
        color(color_clutch) {
            translate([0,0, stack_start + 3*(layer_height) + thickness_gear]) {
                clutch_double(radius_clutch_outer = 1.5*outer_axle_radius, radius_clutch_inner = outer_axle_radius + slop_radial_loose_adjusted);
            }
        }
    }
}

if ( Render_JupiterPlanetArm ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            rotate([0,0,0]) {
                translate([0,0, stack_start + 4*(layer_height)]) {
                    planet_arm(radius_large_hole = 1.5*outer_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 140, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
                }
            }
        }
    }
}

if ( Render_JupiterPeg ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([140, 0, stack_start + 4*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_jupiter);
        }
    }
}

if ( Render_JupiterGearIn106T ) {
    //JupiterGearIn106T. Female, receives male clutch octagon.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            mirror([0, 0, 0]) {
                translate([0,0,stack_start + 5*(layer_height)]) {
                    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = 1.5*outer_axle_radius + slop_radial_tight_adjusted, radius_bearing = outer_shaft_radius, axis_rez = 8);
                }
            }
        }
    }
}

if ( Render_JupiterIdlerIn44T ) {
    //JupiterIdlerIn44T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(85) + radius_contact(44),0,stack_start + 3*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 44, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = 0, include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_JupiterIdlerOut22T ) {
    //JupiterIdlerOut22T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(85) + radius_contact(44), 0, stack_start + layer_height]) {
                rotate([0,0,180]) {
                    //Jupiter's idler out is NOT mirrored, because Saturn's gear in IS mirrored.
                    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, include_axle_grip = true);
                }
            }
        }
    }
}

//--------------------MARS--------------------MARS--------------------MARS--------------------
if ( Render_MarsIdlerArm ) {
    //MarsIdlerArm from 56T to 73T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_idler_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 6*(layer_height)]) {
                    idler_arm(radius_large_hole = outer_axle_radius + slop_radial_tight_adjusted, radius_small_hole = radius_idler_axle + slop_radial_loose_adjusted, length_arm = idler_length_correction + radius_contact(56) + radius_contact(73), radius_bearing = outer_shaft_radius); //old length 65.983
                }
            }
        }
    }
}

if ( Render_MarsGearOut56T ) {
    //MarsGearOut56T. Should be printed fused with MarsGearOutClutch.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            translate([0,0,stack_start + 7*(layer_height)]) {
                make_gear_extended(tooth_count = 56, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0);
            }
        }

        //MarsGearOutClutch. Should be printed fused with MarsGearOut56T
        color(color_clutch) {
            translate([0,0, stack_start + 7*(layer_height) + thickness_gear]) {
                clutch_double(radius_clutch_outer = 1.5*outer_axle_radius, radius_clutch_inner = outer_axle_radius + slop_radial_loose_adjusted);
            }
        }
    }
}

if ( Render_MarsPlanetArm ) {
    //MarsPlanetArm
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            rotate([0,0,0]) {
                translate([0,0, stack_start + 8*(layer_height)]) {
                    planet_arm(radius_large_hole = 1.5*outer_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 115, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
                }
            }
        }
    }
}

if ( Render_MarsPeg ) {
    //MarsPeg
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([115, 0, stack_start + 8*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_mars);
        }
    }
}

if ( Render_MarsGearIn106T ) {
    //MarsGearIn106T. Female, receives male clutch octagon.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            mirror([0, 0, 0]) {
                translate([0,0,stack_start + 9*(layer_height)]) {
                    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = 1.5*outer_axle_radius + slop_radial_tight_adjusted, radius_bearing = outer_shaft_radius, axis_rez = 8);
                }
            }
        }
    }
}

if ( Render_MarsIdlerIn73T ) {
    //MarsIdlerIn73T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(56) + radius_contact(73),0,stack_start + 7*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 73, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = 0, include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_MarsIdlerOut22T ) {
    //MarsIdlerOut22T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(56) + radius_contact(73), 0, stack_start + 5*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, include_axle_grip = true);
                }
            }
        }
    }
}

//--------------------EARTH--------------------EARTH--------------------EARTH--------------------
if ( Render_EarthIdlerArm ) {
    //EarthIdlerArm from 92T to 36T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_idler_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 10*(layer_height)]) {
                    idler_arm(radius_large_hole = outer_axle_radius + slop_radial_tight_adjusted, radius_small_hole = radius_idler_axle + slop_radial_loose_adjusted, length_arm = idler_length_correction + radius_contact(92) + radius_contact(36), radius_bearing = outer_shaft_radius); //old length 65.983
                }
            }
        }
    }
}

if ( Render_EarthGearOut92 ) {
    //EarthGearOut92. Should be printed fused with EarthGearOutClutch.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            translate([0,0,stack_start + 11*(layer_height)]) {
                make_gear_extended(tooth_count = 92, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0);
            }
        }

        //EarthGearOutClutch. Should be rendered fused with EarthGearOut92T
        color(color_clutch) {
            translate([0,0,stack_start + 11*(layer_height) + thickness_gear]) {
                clutch_double(radius_clutch_outer = 1.5*outer_axle_radius, radius_clutch_inner = outer_axle_radius + slop_radial_loose_adjusted);
            }
        }
    }
}

if ( Render_EarthPlanetArm ) {
    //EarthPlanetArm
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 12*(layer_height)]) {
                    earth_arm(radius_large_hole = 1.5*outer_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_idler_axle, length_arm = idler_length_correction + radius_contact(147) + radius_contact(11), radius_rim = radius_clutch_rim, thickness_arm = thickness_gear); //Old length: 81.1
                }
            }
        }
    }
}

if ( Render_EarthPeg ) {
    //EarthPeg
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0,stack_start + 12*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_earth);
        }
    }
}

if ( Render_MoonGear11T ) {
    //MoonGear11T. Render fused with MoonClutch
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0,stack_start + 14*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 11, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_moon_axle + slop_radial_slide_adjusted + radius_clutch_rim, radius_axis = radius_planet_peg + slop_radial_loose_adjusted, radius_bearing = 0, include_axle_grip = false);
                }
            }
        }

        //MoonClutch
        color(color_bearing_unattached) {
            translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0,stack_start + 14*(layer_height) + thickness_gear]) {
                difference() {
                    cylinder(r = radius_moon_axle + 1.65 - slop_radial_slide_adjusted, h = thickness_gear + 2*thickness_bearing, $fn = rez_mid);
                    translate([0,0,-epsilon]) {
                        cylinder(r = radius_planet_peg + slop_radial_loose_adjusted, h = thickness_gear + 2*thickness_bearing + 2*epsilon, $fn = rez_mid);
                    }
                }
            }
        }
    }
}

if ( Render_MoonArm ) {
    //MoonArm
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            translate([idler_length_correction + radius_contact(147) + radius_contact(11),0,stack_start + 15*(layer_height)]) {
                rotate([0,0,0]) {
                    planet_arm(radius_large_hole = radius_moon_axle + 1.65 + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 15, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
                }
            }
        }
    }
}

if ( Render_MoonPeg ) {
    //MoonPeg
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([15 + idler_length_correction + radius_contact(147) + radius_contact(11), 0,stack_start + 15*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_moon);
        }
    }
}

if ( Render_EarthGearIn47T ) {
    //EarthGearIn47T. Female, receives male clutch octagon.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            mirror([0, 0, 0]) {
                translate([0,0,stack_start + 13*(layer_height)]) {
                    make_gear_extended(tooth_count = 47, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = 1.5*outer_axle_radius + slop_radial_tight_adjusted, radius_bearing = outer_shaft_radius, axis_rez = 8);
                }
            }
        }
    }
}

if ( Render_EarthIdlerIn36T ) {
    //EarthIdlerIn36T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(92) + radius_contact(36),0,stack_start + 11*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 36, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = 0, include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_EarthIdlerOut22T ) {
    //EarthIdlerOut22T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(92) + radius_contact(36), 0,stack_start + 9*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, include_axle_grip = true);
                }
            }
        }
    }
}

//--------------------CALENDAR--------------------CALENDAR--------------------CALENDAR-----------

if ( Render_CalendarGear ) {
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegged) {
            translate([0,0,stack_start + 14*(layer_height)]) {

                difference() {
                    union() {
                        make_gear_extended(tooth_count = 147, spoke_count = 5, count_pegs = 3, width_spoke_inner = 34, width_spoke_outer = 12.25, thickness_outer_rim = 20, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_tight_adjusted, radius_bearing = outer_shaft_radius);
                        translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,thickness_gear]) {
                            cylinder(r = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, h = thickness_bearing - epsilon, $fn = rez_mid);
                        }

                        translate([0,0,thickness_gear]) {
                            DrawCalendarMarks();
                        }
                    }
                    translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,-epsilon]) {//Old X translate = 36.57
                        cylinder(r = radius_idler_axle + slop_radial_loose_adjusted, h = layer_height + 2*epsilon, $fn = rez_mid);
                    }
                }
            }
        }
    }
}

if ( Render_CalendarIdlerIn31T ) {
    //CalendarIdlerIn31T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,stack_start + 15*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 31, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = 0, include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_CalendarIdlerOut23T ) {
    //CalendarIdlerOut23T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(39) + radius_contact(31), 0,stack_start + 13*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 23, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, include_axle_grip = true);
                }
            }
        }
    }
}

//--------------------VENUS--------------------VENUS--------------------VENUS--------------------
//Venus has no idler arm, as this role is filled by the calendar gear's idler hole.

if ( Render_VenusGearOut39T ) {
    //VenusGearOut39T. Should be printed fused with VenusGearOutClutch.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            translate([0,0,stack_start + 15*(layer_height)]) {
                make_gear_extended(tooth_count = 39, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = outer_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0);
            }
        }

        //VenusGearOutClutch. Should be printed fused with VenusGearOut39T
        color(color_clutch) {
            translate([0,0,stack_start + 15*(layer_height) + thickness_gear]) {
                clutch_double(radius_clutch_outer = 1.5*outer_axle_radius, radius_clutch_inner = outer_axle_radius + slop_radial_loose_adjusted);
            }
        }
    }
}

if ( Render_VenusPlanetArm ) {
    //VenusPlanetArm
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 16*(layer_height)]) {
                    planet_arm(radius_large_hole = 1.5*outer_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 51, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
                }
            }
        }
    }
}

if ( Render_VenusPeg ) {
    //VenusPeg
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([51, 0,stack_start + 16*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_venus);
        }
    }
}

if ( Render_VenusGearIn42T ) {
    //VenusGearIn42T. Female, receives male clutch octagon. NOTE: Zeamon uses 41T, causing
    //poor gear meshing but more accurate Mercury orbit (0.45 Earth days longer vs 1.66 Earth days
    //shorter than actual.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            mirror([0, 0, 0]) {
                translate([0,0,stack_start + 17*(layer_height)]) {
                    make_gear_extended(tooth_count = 42, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = 1.5*outer_axle_radius + slop_radial_tight_adjusted, radius_bearing = outer_shaft_radius, axis_rez = 8);
                }
            }
        }
    }
}

//--------------------MERCURY--------------------MERCURY--------------------MERCURY--------------------
//Note, only the idler is locked to outer axle. Rest are on Mercury axle.
if ( Render_MercuryIdlerArm ) {
    //MercuryIdlerArm, from 28T to 33T
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_idler_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 18*(layer_height)]) {
                    idler_arm(radius_large_hole = outer_axle_radius + slop_radial_tight_adjusted, radius_small_hole = radius_idler_axle + slop_radial_loose_adjusted, length_arm = idler_length_correction + radius_contact(28) + radius_contact(33), radius_bearing = outer_shaft_radius); //old length_arm = 31.28
                }
            }
        }
    }
}

if ( Render_MercuryGearOut28T ) {
    //MercuryGearOut28T. Should be printed fused with MercuryGearOutClutch.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_pegless) {
            translate([0,0,stack_start + 19*(layer_height)]) {
                make_gear_extended(tooth_count = 28, spoke_count = 0, count_pegs = 0, radius_central_cylinder = outer_shaft_radius, radius_axis = mercury_axle_radius + slop_radial_loose_adjusted, radius_bearing = 0, include_axle_grip = true);
            }
        }

        //MercuryGearOutClutch. Should be printed fused with MercuryGearOut28T
        color(color_clutch) {
            translate([0,0,stack_start + 19*(layer_height) + thickness_gear]) {
                clutch_double(radius_clutch_outer = 1.5*mercury_axle_radius, radius_clutch_inner = mercury_axle_radius + slop_radial_loose_adjusted, radius_bearing = 1.5*mercury_axle_radius + slop_radial_loose_adjusted + radius_clutch_rim);
                //Grip
                translate([offset_gear_grip * (mercury_axle_radius + slop_radial_loose_adjusted),-(mercury_axle_radius + slop_radial_loose_adjusted),0]) {
                    cube([(1-offset_gear_grip)*(mercury_axle_radius + slop_radial_loose_adjusted), 2*(mercury_axle_radius + slop_radial_loose_adjusted), 2*layer_height + thickness_bearing - printer_z_comp - epsilon]);
                }
            }
        }
    }
}

if ( Render_MercuryPlanetArm ) {
    //MercuryPlanetArm
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_planet_arm) {
            rotate([0,0,0]) {
                translate([0,0,stack_start + 20*(layer_height)]) {
                    planet_arm(radius_large_hole = 1.5*mercury_axle_radius + slop_radial_slide_adjusted, radius_small_hole = radius_planet_peghole, length_arm = 29, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
                }
            }
        }
    }
}

if ( Render_MercuryPeg ) {
    //MercuryPeg
    scale([model_scale_percent,model_scale_percent,1]) {
        translate([29, 0,stack_start + 20*(layer_height) + thickness_bearing]) {
            planet_peg(peg_height = peg_mercury);
        }
    }
}

if ( Render_MercuryCap ) {
    //Cap on Mercury assembly
    scale([model_scale_percent,model_scale_percent,1]) {
        color("DarkSeaGreen") {
            //mirror([0,0,1])
            translate([0,0,stack_start + 21*(layer_height)]) {
                difference() {
                    cylinder(r = 1.5*mercury_axle_radius + slop_radial_slide_adjusted + radius_clutch_rim, h = thickness_gear + 2*thickness_bearing, $fn = rez_mid);
                    cylinder(r = 1.5*mercury_axle_radius + slop_radial_tight_adjusted, h = layer_height, $fn = 8);
                    cylinder(r = sun_axle_radius + slop_radial_loose_adjusted, h = thickness_gear + 2*thickness_bearing + epsilon, $fn = rez_lo);
                }
            }
        }
    }
}

if ( Render_MercuryIdlerIn33T ) {
    //MercuryIdlerIn33T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(28) + radius_contact(33),0,stack_start + 19*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 33, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = 0, include_axle_grip = true);
                }
            }
        }
    }
}

if ( Render_MercuryIdlerOut19T ) {
    //MercuryIdlerOut19T.
    scale([model_scale_percent,model_scale_percent,1]) {
        color(color_gear_idler) {
            translate([idler_length_correction + radius_contact(28) + radius_contact(33), 0,stack_start + 17*(layer_height)]) {
                mirror([1,0,0]) {
                    make_gear_extended(tooth_count = 19, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = outer_shaft_radius, radius_axis = radius_idler_axle + slop_radial_tight_adjusted, radius_bearing = radius_idler_axle + slop_radial_loose_adjusted + radius_clutch_rim, include_axle_grip = true);
                }
            }
        }
    }
}


//_____________________________________________________________________________________________________
//_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____
//_____________________________________________________________________________________________________
module FingerWheelAxle() {
    difference() {
        cylinder(r = radius_idler_axle, h = 25, $fn = rez_hi);

        //Side cut for gear axis grip and printability
        translate([0.8 * radius_idler_axle, -radius_idler_axle, - epsilon]) {
            cube([radius_idler_axle-(0.8 * radius_idler_axle), 2*radius_idler_axle,25 + 2*epsilon]);
        }

        //Bevels
        rotate_extrude() {
            translate([radius_idler_axle, 0]) {
                circle(r = 0.5, $fn = 4);
            }
        }

        translate([0,0,25]) {
            rotate_extrude() {
                translate([radius_idler_axle, 0]) {
                    circle(r = 0.5, $fn = 4);
                }
            }
        }
    }
}

module FingerWheelSupport() {
    difference() {
        union() {
            //translate([0,0,15.25]) {
            translate([0,0,10.25 + thickness_gear]) {
                cylinder(r = radius_finger_wheel/2, h = 9.5 - thickness_gear, $fn = rez_mid);
            }
            rotate([0,0,67.5]) {
                rotate_extrude(angle = 45, $fn = rez_mid) {
                    translate([radius_finger_wheel - 9,0]) {
                        square([8,19.75]);
                    }
                    translate([0,10.25 + thickness_gear]) {
                        square([radius_finger_wheel - (9.5 - thickness_gear), 9.5 - thickness_gear]);
                    }
                }
            }
            rotate([0,0,247.5]) {
                rotate_extrude(angle = 45, $fn = rez_mid) {
                    translate([radius_finger_wheel - 9,0]) {
                        square([8,19.75]);
                    }
                    translate([0,10.25 + thickness_gear]) {
                        square([radius_finger_wheel - (9.5 - thickness_gear), 9.5 - thickness_gear]);
                    }
                }
            }
        }
        cylinder(r = radius_idler_axle + slop_radial_loose_adjusted, h = 30, $fn = rez_hi); //Central axle hole
        rotate([0,0,90]) {
            translate([radius_finger_wheel - 5,0,-epsilon]) {
                cylinder(d = mounting_hole_thread_minor_diameter, h = 40, $fn = 8);
            }
        }
        rotate([0,0,270]) {
            translate([radius_finger_wheel - 5,0,-epsilon]) {
                cylinder(d = mounting_hole_thread_minor_diameter, h = 40, $fn = 8);
            }
        }
    }
}

module FingerWheel() {
    difference() {
        cylinder(r = radius_finger_wheel - 1, h = thickness_finger_wheel, $fn = rez_mid);

        //Axle hole
        translate([0,0,-epsilon]) {
            cylinder(r = radius_idler_axle + slop_radial_tight_adjusted, h = thickness_finger_wheel + 2*epsilon, $fn = rez_hi);
        }

        //Finger divots
        for (d = [1:5]) {
            scale([1,1,0.5]) {
                rotate([0,0,(d-0.5)*360/5]) {
                    translate([radius_finger_wheel * 0.6,0,9]) {
                        sphere(r = 8);
                    }
                }
            }
        }

        //Lateral recess for reduced friction
        rotate_extrude($fn = rez_mid) {
            translate([radius_finger_wheel * 0.6 + 8 + 1, thickness_finger_wheel - 1]) {
                square([10,2]);
            }
        }
    }

    //grip
    translate([0.8*(radius_idler_axle + slop_radial_tight_adjusted),-radius_idler_axle,0]) {
        cube([radius_idler_axle, 2*radius_idler_axle,thickness_finger_wheel]);
    }

    //Cap
    translate([0,0,thickness_finger_wheel]) {
        linear_extrude(height = thickness_finger_wheel*0.75, scale = 0.5) {
            circle(r = 2*radius_idler_axle, $fn = rez_mid);
        }
    }

    //Arrow
    translate([radius_finger_wheel * 0.5, -2, thickness_finger_wheel]) {
        cube([7, 4, 1.5]);
    }
    translate([radius_finger_wheel * 0.5 + 8, 0, thickness_finger_wheel]) {
        cylinder(r = 4, h = 1.5, $fn = 3);
    }
}

module Floor() {
    echo ("Drive Gear Radius  = ", radius_wheel_large);
    echo ("Finger Gear Radius = ", radius_wheel_small);
    echo ("Total Base Gear Spacing = ", radius_wheel_large + radius_wheel_small );
    difference() {
        union() {
            //Main circle
            cylinder(r = 2 + radius_wheel_large + radial_space_beyond_contact_radius - slop_radial_loose_adjusted, h = base_thickness_floor, $fn = rez_hi);

            //Minor circle
            translate([radius_wheel_large + radius_wheel_small,0,0]) {
                cylinder(r = 2 + radius_finger_wheel + radial_space_beyond_contact_radius - slop_radial_loose_adjusted, h = base_thickness_floor, $fn = rez_hi);
            }

            //Screw blocks on top of floor
            for (i = [1:3]) {
                rotate([0,0,i * 120 + 60]) {
                    translate([0,0,base_thickness_floor -epsilon]) {
                        difference() {
                            rotate([0,0,-3]) {
                                rotate_extrude(angle = 6, $fn = rez_hi) {
                                    translate([radius_wheel_large + epsilon,0]) {
                                        square([radial_space_beyond_contact_radius - slop_radial_tight_adjusted,2 - epsilon]);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            translate([radius_wheel_large + radius_wheel_small,0,base_thickness_floor]) {
                difference() {
                    rotate([0,0,-6]) {
                        rotate_extrude(angle = 12, $fn = rez_hi) {
                            translate([radius_finger_wheel + epsilon,0]) {
                                square([radial_space_beyond_contact_radius - slop_radial_tight_adjusted,2]);
                            }
                        }
                    }
                }
            }
        }

        //Screw holes on rim______________________________________________
        for (i = [1:3]) {
            rotate([0,0,i * 120 + 60]) {
                translate([radius_wheel_large + radial_space_beyond_contact_radius/2,0,-epsilon]) {
                    cylinder(d = mounting_hole_clearance_diameter, h = 10, $fn = rez_lo);
                }
            }
        }
        translate([radius_wheel_large + radius_wheel_small + radius_finger_wheel + radial_space_beyond_contact_radius/2,0,-1]) {
            cylinder(d = mounting_hole_clearance_diameter, h = 10, $fn = rez_lo);
        }


        //Screw holes for finger wheel support bracket
        translate([radius_wheel_large + radius_wheel_small,0,-epsilon]) {
             rotate([0,0,90]) {
                translate([radius_finger_wheel - 5,0,0]) {
                    cylinder(d = mounting_hole_clearance_diameter, h = 10, $fn = rez_lo);
                }
            }
            rotate([0,0,270]) {
                translate([radius_finger_wheel - 5,0,0]) {
                    cylinder(d = mounting_hole_clearance_diameter, h = 10, $fn = rez_lo);
                }
            }
        }
    }

    //Fingerwheel axle cup
    translate([radius_wheel_large + radius_wheel_small,0,base_thickness_floor]) {
        difference() {
             cylinder(r = radius_idler_axle + slop_radial_loose_adjusted + base_thickness_wall, h = 10, $fn = rez_mid);
             cylinder(r = radius_idler_axle + slop_radial_loose_adjusted, h = 10 + epsilon, $fn = rez_mid);
        }
    }

    //Mercury and sun axle bottom cup
    translate([0,0,base_thickness_floor]) {
        difference() {
            cylinder(r = mercury_axle_radius + slop_radial_loose_adjusted + base_thickness_wall, h = 10, $fn = rez_mid);
            cylinder(r = sun_axle_radius + slop_radial_slide_adjusted, h = 5 + epsilon, $fn = 8); //Sun axle hole
            translate([0,0,5]) {
                cylinder(r = mercury_axle_radius + slop_radial_loose_adjusted, h = 5 + epsilon, $fn = rez_mid);
            }
        }
    }

    //Skid supports for main wheel
    skid_size = 20; // This measurement is in degrees of rotation.
    skid_number = 3;
    for (s = [1:skid_number]) {
        translate([0,0,base_thickness_floor]) {
            rotate([0,0, s*(360 / skid_number)]) {
                rotate([0,0,-(skid_size / 2)]) {
                    rotate_extrude(angle = skid_size, $fn = rez_mid) {
                        translate([radius_wheel_large - 9,0,0]) {
                            square([base_thickness_wall*2, 9.75]);
                        }
                    }
                }
            }
        }
    }
}

module Housing() {
    echo ("Drive Gear Radius  = ", radius_wheel_large);
    echo ("Finger Gear Radius = ", radius_wheel_small);
    echo ("Total Base Gear Spacing = ", radius_wheel_large + radius_wheel_small );
    difference() {
        union() {
            //Main gear housing
            rotate_extrude($fn = rez_hi) {
                difference() {
                    square([radius_wheel_large + radial_space_beyond_contact_radius + base_thickness_wall, base_height_total]);
                    translate([radius_wheel_large + radial_space_beyond_contact_radius + base_thickness_wall, base_height_total]) {
                        circle(r = 4, $fn = 4);
                    }
                }

                //Footing detail
                translate([radius_wheel_large + radial_space_beyond_contact_radius + base_thickness_wall, 0]) {
                    polygon([[0,0], [4,0], [4,2], [2,4], [2,6], [0,8]]);
                }
            }

            //Minor gear housing
            translate([radius_wheel_large + radius_wheel_small,0]) {
                rotate_extrude($fn = rez_hi) {
                    difference() {
                         square([radius_finger_wheel + radial_space_beyond_contact_radius + base_thickness_wall, base_height_total]);
                         translate([radius_finger_wheel + radial_space_beyond_contact_radius + base_thickness_wall, base_height_total]) {
                            circle(r = 4, $fn = 4);
                        }
                    }

                    //Footing detail
                    translate([radius_finger_wheel + radial_space_beyond_contact_radius + base_thickness_wall, 0]) {
                        polygon([[0,0], [4,0], [4,2], [2,4], [2,6], [0,8]]);
                    }
                }
            }
        }

        //Main gear negative
        translate([0,0,-epsilon]) {
            rotate_extrude($fn = rez_hi) {
                difference() {
                    square([radius_wheel_large + radial_space_beyond_contact_radius, base_height_total - base_thickness_roof]);
                    translate([radius_wheel_large + radial_space_beyond_contact_radius, base_height_total - base_thickness_roof]) {
                        circle(r = 4, $fn = 4);
                    }
                }
                translate([radius_wheel_large + radial_space_beyond_contact_radius, 0]) {
                    square([2,2]);
                }
            }
        }

        //Minor gear negative
        translate([radius_wheel_large + radius_wheel_small,0,-epsilon]) {
            rotate_extrude($fn = rez_hi) {
                difference() {
                    square([radius_finger_wheel + radial_space_beyond_contact_radius, base_height_total - base_thickness_roof]);
                    translate([radius_finger_wheel + radial_space_beyond_contact_radius, base_height_total - base_thickness_roof]) {
                        circle(r = 4, $fn = 4);
                    }
                }
                translate([radius_finger_wheel + radial_space_beyond_contact_radius, 0]) {
                    square([2,2]);
                }
            }
        }

        //Top hole for finger wheel access
        translate([radius_wheel_large + radius_wheel_small, 0, base_height_total - base_thickness_roof - 2*epsilon]) {
            rotate_extrude($fn = rez_hi) {
                difference() {
                    square([radius_finger_wheel,base_thickness_roof + 3*epsilon]);
                    translate([radius_finger_wheel,0]) {
                        circle(r = 5, $fn = 4);
                    }
                }
            }
        }

        //Hole for Mercury axle
        translate([0,0,base_height_total - base_thickness_roof - 2*epsilon]) {
            cylinder(r = mercury_axle_radius + slop_radial_loose_adjusted, h = base_thickness_roof + 3*epsilon, $fn = rez_mid);
        }

        //Outer axle mounting holes
        for (i = [1:3]) {
            rotate([0,0,i*360/3]) {
                translate([radius_to_mounting_holes, 0, base_height_total - base_thickness_roof - 2*epsilon]) {
                    cylinder(d = mounting_hole_clearance_diameter, h = base_thickness_roof + 3*epsilon, $fn = rez_lo);
                }
            }
        }
    }

    //Stuff added back, after case hollowed out
    //Floor mounting screw catchers
    for (i = [1:3]) {
        rotate([0,0,i * 120 + 60]) {
            translate([0,0,(base_thickness_floor + 2) - 2*epsilon]) {
                difference() {
                    rotate([0,0,-3]) {
                        rotate_extrude(angle = 6, $fn = rez_hi) {
                            translate([radius_wheel_large + epsilon,0,0]) {
                                difference() {
                                    square([radial_space_beyond_contact_radius + 1,10]);
                                    translate([0,10]) {
                                        circle(r = radial_space_beyond_contact_radius, $fn = 4);
                                    }
                                }
                            }
                        }
                    }

                    translate([radius_wheel_large + radial_space_beyond_contact_radius/2,0,-epsilon]) {
                        cylinder(d = mounting_hole_thread_minor_diameter, h = 10, $fn = 8);
                    }
                }
            }
        }
    }

    translate([radius_wheel_large + radius_wheel_small,0,base_thickness_floor + 2]) {
        difference() {
            rotate([0,0,-6]) {
                rotate_extrude(angle = 12, $fn = rez_hi) {
                    translate([radius_finger_wheel + epsilon,0]) {
                        difference() {
                            square([radial_space_beyond_contact_radius + 1,10]);
                            translate([0,10]) {
                                circle(r = radial_space_beyond_contact_radius, $fn = 4);
                            }
                        }
                    }
                }
            }

            translate([radius_finger_wheel + radial_space_beyond_contact_radius/2,0]) {
                cylinder(d = mounting_hole_thread_minor_diameter, h = 10, $fn = 8);
            }
        }
    }

    //Finger dial marks for days
    for (d = [1:14]) {
        translate([radius_wheel_large + radius_wheel_small, 0, base_height_total - base_thickness_roof]) {
            rotate([0,0,-1.5 + d*360/14]) {
                rotate_extrude(angle = 3) {
                    translate([radius_finger_wheel - 5,0]) {
                        polygon([[0,0],[base_thickness_roof / tan(60),base_thickness_roof],[6,base_thickness_roof],[6,0]]);
                    }
                }
            }
        }
    }

    //Upper tube for Mercury axle
    //#translate([0,0,base_height_total - 15]) {
    translate([0,0,base_height_total - (20 - thickness_gear)]) {
        difference() {
            cylinder(r = mercury_axle_radius + slop_radial_loose_adjusted + base_thickness_wall, h = (20 - thickness_gear) - base_thickness_roof, $fn = rez_mid);
            translate([0,0,-epsilon]) {
                cylinder(r = mercury_axle_radius + slop_radial_loose_adjusted, h = (20 - thickness_gear) - base_thickness_roof + 2*epsilon, $fn = rez_mid);
            }
        }
    }

    //Outer axle mounting nut holders
    for (i = [1:3]) {
        rotate([0,0,i*360/3]) {
            translate([radius_to_mounting_holes, 0, base_height_total - base_thickness_roof - 3]) {
                difference() {
                    cylinder(r = 5.5 / model_scale_percent, h = 3, $fn = rez_lo);
                    translate([0,0,-epsilon]) {
                        cylinder(r = 3.5 / model_scale_percent, h = 3 + 2*epsilon, $fn = 6);
                    }
                }
            }
        }
    }
}

module idler_arm(radius_large_hole, radius_small_hole, radius_large_body = outer_shaft_radius, length_arm, thickness_arm = thickness_gear, count_pegs = 3, radius_bearing = 0) {
    linear_extrude(height = thickness_arm) {
        difference() {
            union() {
                //inner pegged body
                circle(r = radius_large_body, $fn = rez_mid);

                //outer body
                translate([length_arm, 0, 0]) {
                    circle(r = radius_small_hole + radius_clutch_rim, $fn = rez_mid);
                }
                polygon(points=[[0,radius_large_body],
                    [length_arm,radius_small_hole + radius_clutch_rim],
                    [length_arm,-(radius_small_hole + radius_clutch_rim)],
                    [0,-radius_large_body]]);
            }
            circle(r = radius_large_hole, $fn = rez_hi);
            translate([length_arm,0,0]) {
                circle(r = radius_small_hole, $fn = rez_mid);
            }
        }
    }

    //inner bearing
    if (radius_bearing > 0) {
        translate([0,0,thickness_gear-epsilon]) {
            bearing(radius_inner = radius_large_hole, radius_outer = outer_shaft_radius);
        }
    }

    //outer bearing
    translate([length_arm, 0, thickness_gear-epsilon]) {
        difference() {
            cylinder(r = radius_small_hole + radius_clutch_rim, h = thickness_bearing, $fn = rez_mid);
            translate([0,0,-epsilon]) {
                cylinder(r = radius_small_hole, h = thickness_bearing + 2*epsilon, $fn = rez_mid);
            }
        }
    }

    if (count_pegs > 0) {
        thickness_peg = radius_bearing > 0? thickness_gear + thickness_bearing : thickness_gear;
        for (current_peg = [1:count_pegs]) {
            rotate([0,0, (current_peg - 1) * 360/count_pegs]) {
                translate([radius_large_hole - peg_depth,-peg_width/2,0]) {
                    cube([peg_depth, peg_width, thickness_peg-epsilon]);
                }
            }
        }
    }
}

module bearing(radius_inner, radius_outer) {
    difference() {
        cylinder(r = radius_outer, h = thickness_bearing, $fn = rez_mid);
        translate([0,0,-epsilon]) {
            cylinder(r = radius_inner, h = thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }
}

module clutch_single(radius_clutch_outer, radius_clutch_inner, thickness_clutch = thickness_gear, has_bearing = true) {
    difference() {
        union() {
            //Inserted part
            cylinder(r = radius_clutch_outer, h = thickness_clutch, $fn = rez_hi);
            //Bearing
            if ( has_bearing ) {
                translate([0,0,thickness_clutch]) {
                    cylinder(r = outer_shaft_radius, h = thickness_bearing, $fn = rez_mid);
                }
            }
        }
        translate([0,0,-epsilon]) {
            cylinder(r = radius_clutch_inner, h = thickness_clutch + thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }
}

module clutch_double(radius_clutch_outer, radius_clutch_inner, radius_bearing = outer_shaft_radius) {
    difference() {
        union() {
            //Part inserted into planet arm
            translate([0,0,thickness_bearing]) {
                cylinder(r = radius_clutch_outer, h = layer_height, $fn = rez_hi);
            }

            //Bearing
            cylinder(r = radius_bearing, h = thickness_bearing, $fn = rez_mid);

            //Part inserted into gear
            translate([0,0,thickness_gear + 2*thickness_bearing]) {
                cylinder(r = radius_clutch_outer - slop_radial_tight_adjusted, h = layer_height - epsilon, $fn = 8);
            }
        }
        translate([0,0,-epsilon]) {
            cylinder(r = radius_clutch_inner, h = 2*layer_height + thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }
}

module planet_arm(radius_large_hole, radius_small_hole, length_arm, radius_rim, thickness_arm = thickness_gear) {
    translate([0,0,epsilon]) {
        difference() {
            union() {
                //inner clutched body
                cylinder(r = radius_large_hole + radius_rim, h = layer_height - printer_z_comp - 2*epsilon,$fn = rez_mid);

                //outer body, holds planet peg
                translate([length_arm, 0, 0]) {
                    cylinder(r = radius_small_hole + radius_rim, h = thickness_gear, $fn = rez_lo);
                }

                //Arm polygon
                linear_extrude(height = thickness_arm) {
                    polygon(points=[[0,radius_large_hole + radius_rim],
                        [length_arm,radius_small_hole + radius_rim],
                        [length_arm,-(radius_small_hole + radius_rim)],
                        [0,-(radius_large_hole + radius_rim)]]);
                }

                //Cone, holds planet peg
                translate([length_arm, 0, thickness_gear]) {
                    difference() {
                        linear_extrude(height = planet_arm_peg_cone_height, scale = (radius_small_hole + 1)/(radius_small_hole + radius_rim)) {
                            circle(radius_small_hole + radius_rim, $fn = rez_lo);
                        }
                        translate([0,0,-epsilon]) {
                            cylinder(r = radius_small_hole, h = thickness_gear + planet_arm_peg_cone_height + 2*epsilon, $fn = rez_mid);
                        }
                    }
                }

                //Clutch screw block
                translate([-(radius_large_hole + 2*radius_rim), - planet_arm_screw_block_width/2,0]) {
                    cube([planet_arm_screw_block_width,planet_arm_screw_block_width,layer_height - printer_z_comp - 2*epsilon]);
                }
            }

            //main hole
            translate([0,0,-epsilon]) {
                cylinder(r = radius_large_hole, h = layer_height + 2*epsilon, $fn = rez_hi);
            }

            //peg hole
            translate([length_arm,0,thickness_bearing]) {
                cylinder(r = radius_small_hole, h = thickness_gear + planet_arm_peg_cone_height + 2*epsilon,$fn = rez_mid);
            }

            //screw hole
            translate([0,0, (layer_height)/2]) {
                scale([1/model_scale_percent,1/model_scale_percent,1]) {
                    rotate([0,-90,0]) {
                        cylinder(d = planet_arm_screwhole_diameter, h = radius_large_hole + 2*radius_rim + epsilon, $fn = 6);
                    }
                }
            }
        }
    }
}

module earth_arm(radius_large_hole, radius_small_hole, length_arm, radius_rim, thickness_arm = thickness_gear) {
//Special case for planet arms, owing to interaction with calendar gear
    translate([0,0,epsilon]) {
        difference() {
            union() {
                //inner clutched body
                cylinder(r = radius_large_hole + radius_rim, h = layer_height - printer_z_comp - 2*epsilon,$fn = rez_mid);

                //outer body, holds planet peg
                translate([length_arm, 0, 0]) {
                    cylinder(r = radius_small_hole + radius_rim, h = thickness_gear, $fn = rez_lo);
                }

                //Arm polygon
                linear_extrude(height = thickness_arm) {
                    polygon(points=[[0,radius_large_hole + radius_rim],
                        [length_arm,radius_small_hole + radius_rim],
                        [length_arm,-(radius_small_hole + radius_rim)],
                        [0,-(radius_large_hole + radius_rim)]]);
                }

                //cone at small end
                translate([length_arm, 0, thickness_gear]) {
                    linear_extrude(height = thickness_gear + 2*thickness_bearing, scale = (4)/(radius_small_hole + radius_rim)) {
                        circle(r = radius_small_hole + radius_rim, $fn = rez_lo);
                    }
                }

                //Clutch screw block
                translate([-(radius_large_hole + 2*radius_rim), - planet_arm_screw_block_width/2,0]) {
                    cube([planet_arm_screw_block_width, planet_arm_screw_block_width, layer_height - printer_z_comp]);
                }
            }

            //main hole
            translate([0,0,-epsilon]) {
                cylinder(r = radius_large_hole, h = layer_height + 2*epsilon, $fn = rez_hi);
            }

            //peg hole
            translate([length_arm,0,thickness_bearing]) {
                cylinder(r = radius_planet_peghole, h = 2*layer_height + 2*epsilon,$fn = rez_mid);
            }

            //screw hole
            translate([0,0, (layer_height)/2]) {
                rotate([0,-90,0]) {
                    cylinder(d = planet_arm_screwhole_diameter, h = radius_large_hole + 2*radius_rim + epsilon, $fn = 6);
                }
            }
        }
    }
}

module make_gear_extended(tooth_count, spoke_count = 0, count_pegs = 0, width_spoke_inner = 30, width_spoke_outer = 15, thickness_outer_rim = 10, radius_central_cylinder, radius_axis, radius_bearing = 0, axis_rez = rez_hi, include_axle_grip = false, gear_type = "herringbone") {
    radius_tooth_inner = ((modul * tooth_count) - 2 * (modul + (modul / 6))) / 2;
    radius_tooth_outer = ((modul * tooth_count) + modul * 2) / 2;
    echo("radius inner = ", radius_tooth_inner);
    echo("radius outer = ", radius_tooth_outer);

    difference() {
        union() {
            //Spokes
            if (spoke_count > 0) {
                for(current_spoke = [1:spoke_count]) {
                    rotate([0,0,(current_spoke-1)*360/spoke_count]) {
                        linear_extrude(height = thickness_gear) {
                            polygon(points=[[0,-width_spoke_inner/2],
                                [radius_tooth_inner - thickness_outer_rim,-width_spoke_outer/2],
                                [radius_tooth_inner - thickness_outer_rim,width_spoke_outer/2],
                                [0,width_spoke_inner/2]]);
                        }
                    }
                }
            }

            //Bearing on top
            if (radius_bearing > 0) {
                translate([0,0,thickness_gear]) {
                    cylinder(r = radius_bearing, h = thickness_bearing - epsilon, $fn = rez_mid);
                }
            }

            difference() {
                //Main gear
                if ( gear_type == "herringbone" ) {
                    herringbone_gear (modul=1, tooth_number=tooth_count, width=thickness_gear, bore=0, pressure_angle=20, helix_angle=30, optimized=false);
                } else if ( gear_type == "spur" ) {
                    spur_gear(modul=1, tooth_number=tooth_count, width=thickness_gear, bore=0, pressure_angle=20, helix_angle=30, optimized=false);
                }

                //Empty torus
                translate([0,0,-epsilon]) {
                    difference() {
                        cylinder(r = radius_tooth_inner - thickness_outer_rim, h = thickness_gear + 2*epsilon, $fn = rez_mid);
                        translate([0,0,epsilon]) {
                            cylinder(r = radius_central_cylinder, h = thickness_gear, $fn = rez_mid);
                        }
                    }
                }
            }
        }

        //Central axis hole
        translate([0,0,-epsilon]) {
        //translate([0,0,0]) {
            cylinder(r = radius_axis, h = layer_height + 2*epsilon, $fn = axis_rez);
        }
    }

    if (count_pegs > 0) {
        for (current_peg = [1:count_pegs]) {
            thickness_peg = count_pegs > 0? thickness_gear + thickness_bearing : thickness_gear;
            rotate([0,0, (current_peg - 1) * 360/count_pegs]) {
                translate([radius_axis + slop_radial_tight_adjusted - peg_depth,-peg_width/2,0]) {
                    cube([peg_depth, peg_width, thickness_peg - epsilon]);
                }
            }
        }
    }

    if ( include_axle_grip ) {
        translate([radius_axis * offset_gear_grip, -radius_axis, 0]) {
            cube([radius_axis * (1 - offset_gear_grip), 2*radius_axis,thickness_gear]);
        }
    }
}

module mercury_axle() {
    color("LightSteelBlue") {
        difference() {
            //Main cylinder outer wall
            cylinder(r = mercury_axle_radius, h = mercury_axle_height, $fn = rez_mid);

            //Main cylinder inner hollow
            translate([0,0,-epsilon]) {
                cylinder(r = mercury_axle_radius - thickness_axle_wall + slop_radial_slide_adjusted, h = mercury_axle_height + 2*epsilon, $fn = rez_mid);
            }

            //Grip
            translate([mercury_axle_radius * offset_gear_grip, -mercury_axle_radius, -epsilon]) {
                cube([mercury_axle_radius -(mercury_axle_radius * offset_gear_grip), 2*mercury_axle_radius, mercury_axle_height + 2*epsilon]);
            }
            //Bevels
            rotate_extrude() {
                translate([mercury_axle_radius,0,0]) {
                    circle(r = 0.5, $fn = 4);
                }
            }

            translate([0,0,mercury_axle_height]) {
                rotate_extrude() {
                    translate([mercury_axle_radius,0,0]) {
                        circle(r = 0.5, $fn = 4);
                    }
                }
            }
        }
    }
}




module Main_Axle() {
    color("LightSalmon") {
        difference() {
            linear_extrude(height = main_axle_base_height, scale = outer_shaft_radius/(radius_to_mounting_holes + 5)) {
                circle(r = radius_to_mounting_holes + 5, $fn = rez_hi);
            }

            //Outer axle mounting holes
            for (i = [1:3]) {
                rotate([0,0,i*360/3]) {
                    translate([radius_to_mounting_holes, 0, -epsilon]) {
                        cylinder(d = mounting_hole_clearance_diameter, h = 10, $fn = rez_lo);
                    }
                    translate([radius_to_mounting_holes, 0, 2]) {
                        cylinder(r = 5, h = main_axle_base_height, $fn = rez_mid);
                    }
                }
            }

            translate([0,0,-epsilon]) {
                cylinder(r = outer_axle_radius - thickness_axle_wall + slop_radial_loose_adjusted, h = main_axle_base_height + 2*epsilon, $fn = rez_mid);
            }
        }
    }

    color("LightGrey") {
        translate([0,0,main_axle_base_height]) {
            linear_extrude(height = outer_axle_height) {
                difference() {
                    //Main tube
                    circle(r = outer_axle_radius, $fn = rez_mid);

                    //Hollow in main tube
                    circle(r = outer_axle_radius - thickness_axle_wall + slop_radial_loose_adjusted, $fn = rez_mid);

                    //Peg slots
                    for (i = [1:3]) {
                        rotate([0,0,i * 360/3]) {
                            translate([outer_axle_radius - slot_depth, -slot_width/2]) {
                                square([slot_depth, slot_width]);
                            }
                        }
                    }
                }
            }
        }
    }
}

module idler_axle() {
    //rotate([0,180,0]) {
    difference() {
        cylinder(r = radius_idler_axle, h = 3*thickness_gear + 2*thickness_bearing, $fn = rez_hi);

        //Side cut for gear axis grip and printability
        translate([offset_gear_grip * radius_idler_axle, -radius_idler_axle]) {
            cube([radius_idler_axle, 2*radius_idler_axle,3*thickness_gear + 2*thickness_bearing]);
        }

        //Bevels
        rotate_extrude() {
            translate([radius_idler_axle, 0]) {
                circle(r = 0.5, $fn = 4);
            }
        }

        translate([0,0,3*thickness_gear + 2*thickness_bearing]) {
            rotate_extrude() {
                translate([radius_idler_axle, 0]) {
                    circle(r = 0.5, $fn = 4);
                }
            }
        }
    }
    //}
}

module All_Pegs() {
    for (current_peg = [0:7]) {
        translate([(peg_sun - peg_heights[current_peg])/2, 10*current_peg,0]) {
            rotate([0,90,0]) {
                planet_peg(peg_heights[current_peg]);
            }
        }
    }
}

module planet_peg(peg_height) {
    color("Moccasin") {
        rotate([0,0,360/16]) {
            linear_extrude(height = peg_height) {
                difference() {
                    circle(r = radius_planet_peg, $fn = 8);
                }
            }
        }
    }
}

module DrawCalendarMarks() {
    for (current_month = [0:11]) {
        rotate([0,0,calendar_month_days[current_month]/365 * 360]) {
            linear_extrude(height = calendar_thickness_big_marks) {
                translate([calendar_radius_marks,-calendar_thickness_big_marks/2]) {
                    square([calendar_height_big_marks, calendar_width_big_marks]);
                }
            }

            translate([calendar_radius_words,0,0]) {
                rotate([0,0,90]) {
                    linear_extrude(height = calendar_thickness_letters) {
                        text(text = str(calendar_month_name[current_month]), font = calendar_font, size = calendar_font_size, valign = "bottom", halign = "center");
                    }
                }
            }
        }
    }


    //Day marks
    for (current_day = [0 : 364]) {
        linear_extrude(height = calendar_thickness_small_marks) {
            rotate([0,0,(current_day / 365) * 360]) {
                translate([calendar_radius_marks + (calendar_height_big_marks - calendar_height_small_marks),-calendar_width_small_marks/2]) {
                    square([calendar_height_small_marks, calendar_width_small_marks]);
                }
            }
        }
    }
}

module printable_planets() {
    { //Saturn
        difference() { //TOP
            union() {
                sphere(r = 9, $fn = rez_mid);
                cylinder(r = 18, h = 1, $fn = rez_mid); //Rings
            }
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            rotate([0,26.7,0]) {
                translate([0,0,-2]) {
                    cylinder(r = radius_planet_peg, h = 7, $fn = rez_lo); //Peg hole
                }
            }
        }
        translate([40,0,0]) {
            difference() { //BOTTOM
                sphere(r = 9, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                rotate([0,26.7,0]) {
                    translate([0,0,-2]) {
                        cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                    }
                }
            }
        }
    }

    translate([0,35,0]) { //Jupiter
        difference() { //TOP
            sphere(r = 12, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 12, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,60,0]) { //Mars
        difference() { //TOP
            sphere(r = 7, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 7, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,80,0]) { //Earth
        difference() { //TOP
            sphere(r = 8, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 8, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,100,0]) { //Moon
        difference() { //TOP
            sphere(r = 4, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 4, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,120,0]) { //Venus
        difference() { //TOP
            sphere(r = 7, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 7, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,140,0]) { //Mercury
        difference() { //TOP
            sphere(r = 6, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([30,0,0]) {
            difference() { //BOTTOM
                sphere(r = 6, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }

    translate([0,-40,0]) { //Sun
        difference() { //TOP
            sphere(r = 15, $fn = rez_mid);
            translate([0,0,-50]) {
                cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
            translate([0,0,-epsilon]) {
                cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
        }
        translate([40,0,0]) {
            difference() { //BOTTOM
                sphere(r = 15, $fn = rez_mid);
                translate([0,0,-50]) {
                    cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
                }
                translate([0,0,-epsilon]) {
                    cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
                }
            }
        }
    }
}

//Next function returns gear contact ratio for setting spacing of interacting gears
function radius_contact(tooth_count, modul = 1) = ((((modul * tooth_count) - 2 * (modul + (modul / 6))) / 2) + (((modul * tooth_count) + modul * 2) / 2)) / 2;

function RandomColor() = [(rands(0.4,1,1)[0]), (rands(0.4,1,1)[0]), (rands(0.4,1,1)[0]), 1];
