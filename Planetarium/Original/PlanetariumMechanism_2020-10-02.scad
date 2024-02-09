/*
Project written by Patrick Gaston, 9/2020. It is based on the planetarium model of Ken Condal, posted by him online at http://www.zeamon.com/download/ZeamonOrrery.pdf.

This project requires "Getriebe.scad", (https://www.thingiverse.com/thing:1604369) created by Dr Jörg Janssen, distributed under "Creative Commons - Attribution, Non Commercial, Share Alike" in 6/2016. "Getriebe.scad" must be in the same directory as this file.

Assembly guide: https://youtu.be/gCyWxUscdN0
*/

include <Getriebe.scad>;

epsilon = 0.02;
rez_lo = 32;
rez_mid = 64;
rez_hi = 96;
modul = 1;

color_clutch = "BurlyWood";
color_planet_arm = "RosyBrown";
color_idler_arm = "MediumPurple";
color_gear_pegless = "LightSeaGreen";
color_gear_pegged = "CornflowerBlue";
color_gear_idler = "Thistle";
color_bearing_unattached = "Violet";

//Calendar marks
font = "Liberation Sans";
font_size = 8;
thickness_letters = 1; //vertical extrusion
thickness_small_marks = 1;
thickness_big_marks = 1;
width_small_marks = 0.6;
width_big_marks = 1.2;
height_small_marks = 4;
height_big_marks = 6;
radius_words = 63;
radius_marks = 64;
month_name = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
month_days = [365, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]; 

slop_radial_tight = 0.3; //For press-fit, non-rotating parts
slop_radial_slide = 0.35; //For parts meant to fit snug, but be able to rotate
slop_radial_loose = 0.5; //For rotating parts
thickness_gear = 5;
thickness_bearing = 2;
thickness_axle_wall = 3;
thickness_platform = 5;
height_planet_peg_cone = 3*thickness_gear;
width_planet_arm_screw_block = 10;
radius_planet_arm_screwhole = 1.5;
radius_platform = 30;
radius_planet_peg = 2;
radius_planet_peghole = radius_planet_peg + slop_radial_tight;
radius_clutch_rim = 4; //How far beyond clutch hole the clutched arm should extend radially
radius_idler_axle = 5;
radius_moon_axle = 2.7;
extension_below_platform_sun_axle = 2*(thickness_gear + thickness_bearing);
extension_below_platform_mercury_axle = thickness_gear + thickness_bearing;
height_sun = 40 + 22*(thickness_gear + thickness_bearing);
height_sun_above_mercury_axle = 30;
width_slot = 3;
depth_slot = 2;
width_peg = width_slot - 2*slop_radial_loose;
depth_peg = depth_slot - slop_radial_tight;
offset_gear_grip = 0.8; //Percent of axle radius that is flattened to prevent free rotation
idler_length_correction = 0.5; //Experimental value to compensate for inexact tooth meshing. Adds to calculated length.

radius_sun_axle = 2.0;
height_sun_axle = height_sun + thickness_platform +extension_below_platform_sun_axle;

radius_mercury_axle = radius_sun_axle + slop_radial_loose + thickness_axle_wall;
height_mercury_axle = 221; //22*(thickness_gear + thickness_bearing) + thickness_bearing + thickness_platform + extension_below_platform_mercury_axle;

radius_outer_axle = radius_mercury_axle + slop_radial_loose + thickness_axle_wall;
height_outer_axle = 19*(thickness_gear + thickness_bearing) + thickness_bearing;

radius_outer_shaft = 1.5*radius_outer_axle + radius_clutch_rim + slop_radial_slide;
echo ("ROS: ",radius_outer_shaft);

peg_heights = [(28*(thickness_platform + thickness_bearing)) + 40 + 30, 
    6*(thickness_platform + thickness_bearing),
    10*(thickness_platform + thickness_bearing),
    12*(thickness_platform + thickness_bearing),
    14*(thickness_platform + thickness_bearing),
    18*(thickness_platform + thickness_bearing),
    22*(thickness_platform + thickness_bearing),
    26*(thickness_platform + thickness_bearing)
    ]; 
//planet_peg(peg_height);

//All_Pegs();

//Sun axle
//translate([0,0,-extension_below_platform_sun_axle - thickness_platform]) planet_peg(peg_height = height_sun_axle);

//Sun, for visualization, only
//color("Yellow") translate([0,0, height_sun]) sphere(r = 15); 

//mercury_drive(); //Large gear at base that drives entire mechanism.
//handle_gear();

//rotate([0,90,0]) 
//translate([0,0,-extension_below_platform_mercury_axle])
//    mercury_axle();

//outer_axle(); //Main support axle for majority of planets and idlers.
//idler_axle(); //Short axles that connect any 2 idler gears in a set
//printable_planets();

//Base finger wheel gear
//    make_gear_extended(tooth_count = 22, spoke_count = 0, count_pegs = 0, width_spoke_inner = 0, width_spoke_outer = 0, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);



//--------------------SATURN--------------------SATURN--------------------SATURN--------------------
/* 
//SaturnPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 1*(thickness_platform + thickness_bearing)])
    planet_arm(radius_large_hole = 1.5*radius_outer_axle + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 166, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear); //old length 181
  
//SaturnPeg
translate([181, 0, thickness_platform + 2*thickness_bearing])
    planet_peg(peg_height = height_sun - thickness_platform - 2*thickness_bearing);

//Saturn, for visualization, only
//color("lime") translate([181,0, height_sun]) sphere(r = 10); 

//SaturnPlanetClutch. Should be fused with SaturnGearIn106T
color(color_clutch)
translate([0,0, thickness_gear])
    clutch_single(radius_clutch_outer = 1.5*radius_outer_axle, radius_clutch_inner = radius_outer_axle + slop_radial_loose, thickness_clutch = thickness_gear + thickness_bearing);

//SaturnGearIn106T. Should be fused with SaturnPlanetClutch. Mirrored because it will be printed upside down once clutch attached.
color(color_gear_pegless)
mirror([1, 0, 0])
translate([0,0,2*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_loose, radius_bearing = 0);


//Bearing, sits on top of SaturnGearIn106T
color(color_bearing_unattached)
translate([0,0,2*(thickness_gear + thickness_bearing) + thickness_gear])
    bearing(radius_inner = radius_outer_axle + slop_radial_loose, radius_outer = radius_outer_shaft);
*/


//--------------------JUPITER--------------------JUPITER--------------------JUPITER--------------------
/* 
//JupiterIdlerArm from 85T to 44T   
color(color_idler_arm)
translate([0,0,3*(thickness_gear + thickness_bearing)])
    idler_arm(radius_large_hole = radius_outer_axle + slop_radial_tight, radius_small_hole = radius_idler_axle + slop_radial_loose, length_arm = idler_length_correction + radius_contact(85) + radius_contact(44), radius_bearing = radius_outer_shaft); //Old length 65.983
   
//JupiterGearOut85T. Should be printed fused with JupiterGearOutClutch.
color(color_gear_pegless)
translate([0,0,4*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 85, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_loose, radius_bearing = 0);
    
//JupiterGearOutClutch. Should be printed fused with JupiterGearOut85T
color(color_clutch)
translate([0,0, 4*(thickness_platform + thickness_bearing) + thickness_gear])
    clutch_double(radius_clutch_outer = 1.5*radius_outer_axle, radius_clutch_inner = radius_outer_axle + slop_radial_loose);    

//JupiterPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 5*(thickness_gear + thickness_bearing)])
    planet_arm(radius_large_hole = 1.5*radius_outer_axle + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 140, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);

//JupiterPeg
translate([140, 0, 5*(thickness_gear + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (5*(thickness_gear + thickness_bearing) + thickness_bearing));

//Jupiter, for visualization, only
//color("orange") translate([140,0, height_sun]) sphere(r = 12); 

//JupiterGearIn106T. Female, receives male clutch octagon.
color(color_gear_pegless)
mirror([0, 0, 0])
translate([0,0,6*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = 1.5*radius_outer_axle + slop_radial_tight, radius_bearing = radius_outer_shaft, axis_rez = 8);

//JupiterIdlerIn44T.
color(color_gear_idler)
translate([radius_contact(85) + radius_contact(44),0,4*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 44, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);
 
//JupiterIdlerOut22T.
color(color_gear_idler)
translate([radius_contact(85) + radius_contact(44), 0, 2*(thickness_gear + thickness_bearing)])
mirror([0,0,0]) //Jupiter's idler out is NOT mirrored, because Saturn's gear in IS mirrored.
    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = radius_idler_axle + slop_radial_loose + radius_clutch_rim, include_axle_grip = true);    
 */
 
//--------------------MARS--------------------MARS--------------------MARS--------------------
/*
//MarsIdlerArm from 56T to 73T
color(color_idler_arm)
rotate([0,0,0])
translate([0,0,7*(thickness_gear + thickness_bearing)])
    idler_arm(radius_large_hole = radius_outer_axle + slop_radial_tight, radius_small_hole = radius_idler_axle + slop_radial_loose, length_arm = idler_length_correction + radius_contact(56) + radius_contact(73), radius_bearing = radius_outer_shaft); //old length 65.983

//MarsGearOut56T. Should be printed fused with MarsGearOutClutch.
color(color_gear_pegless)
translate([0,0,8*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 56, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, 7thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_loose, radius_bearing = 0);
    
//MarsGearOutClutch. Should be printed fused with MarsGearOut56T
color(color_clutch)
translate([0,0, 8*(thickness_platform + thickness_bearing) + thickness_gear])
    clutch_double(radius_clutch_outer = 1.5*radius_outer_axle, radius_clutch_inner = radius_outer_axle + slop_radial_loose);    

//MarsPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 9*(thickness_platform + thickness_bearing)])
    planet_arm(radius_large_hole = 1.5*radius_outer_axle + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 115, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);

//MarsPeg
translate([115, 0, 9*(thickness_gear + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (9*(thickness_gear + thickness_bearing) + thickness_bearing));   

//Mars, for visualization, only
//color("red") translate([115,0, height_sun]) sphere(r = 7);    

//MarsGearIn106T. Female, receives male clutch octagon.
color(color_gear_pegless)
mirror([0, 0, 0])
translate([0,0,10*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 106, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = 1.5*radius_outer_axle + slop_radial_tight, radius_bearing = radius_outer_shaft, axis_rez = 8);

//MarsIdlerIn73T.
color(color_gear_pegless)
translate([radius_contact(56) + radius_contact(73),0,8*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 73, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);
    
//MarsIdlerOut22T.
color(color_gear_pegless)
translate([radius_contact(56) + radius_contact(73), 0, 6*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = radius_idler_axle + slop_radial_loose + radius_clutch_rim, include_axle_grip = true); 
*/    

//--------------------EARTH--------------------EARTH--------------------EARTH--------------------
/*
//EarthIdlerArm from 92T to 36T
color(color_idler_arm)
rotate([0,0,0])
translate([0,0,11*(thickness_gear + thickness_bearing)])
    idler_arm(radius_large_hole = radius_outer_axle + slop_radial_tight, radius_small_hole = radius_idler_axle + slop_radial_loose, length_arm = idler_length_correction + radius_contact(92) + radius_contact(36), radius_bearing = radius_outer_shaft); //old length 65.983

//EarthGearOut92. Should be printed fused with EarthGearOutClutch.
color(color_gear_pegless)
translate([0,0,12*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 92, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_loose, radius_bearing = 0);

//EarthGearOutClutch. Should be rendered fused with EarthGearOut92T
color(color_clutch)
translate([0,0, 12*(thickness_platform + thickness_bearing) + thickness_gear])
    clutch_double(radius_clutch_outer = 1.5*radius_outer_axle, radius_clutch_inner = radius_outer_axle + slop_radial_loose);    

//EarthPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 13*(thickness_platform + thickness_bearing)])
    earth_arm(radius_large_hole = 1.5*radius_outer_axle + slop_radial_slide, radius_small_hole = radius_idler_axle, length_arm = idler_length_correction + radius_contact(147) + radius_contact(11), radius_rim = radius_clutch_rim, thickness_arm = thickness_gear); //Old length: 81.1

//EarthPeg
translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0, 13*(thickness_gear + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (13*(thickness_gear + thickness_bearing) + thickness_bearing)); 

 //Earth, for visualization, only
 //color("blue") translate([idler_length_correction + radius_contact(147) + radius_contact(11),0, height_sun]) sphere(r = 8);     

//MoonGear11T. Render fused with MoonClutch
color(color_gear_pegless)
translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0, 15*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 11, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_moon_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_planet_peg + slop_radial_loose, radius_bearing = 0, include_axle_grip = false);
   
//MoonClutch
color(color_bearing_unattached)
translate([idler_length_correction + radius_contact(147) + radius_contact(11), 0, 15*(thickness_gear + thickness_bearing) + thickness_gear])
difference()
    {
     cylinder(r = radius_moon_axle + 1.65, h = thickness_gear + 2*thickness_bearing, $fn = rez_mid);
     translate([0,0,-epsilon]) 
        cylinder(r = radius_planet_peg + slop_radial_loose, h = thickness_gear + 2*thickness_bearing + 2*epsilon, $fn = rez_mid);
    }

//MoonArm 
color(color_planet_arm)
translate([idler_length_correction + radius_contact(147) + radius_contact(11),0, 16*(thickness_platform + thickness_bearing)])
rotate([0,0,0])    
    {
    planet_arm(radius_large_hole = radius_moon_axle + 1.65 + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 15, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
    }

//MoonPeg
translate([15 + idler_length_correction + radius_contact(147) + radius_contact(11), 0, 16*(thickness_platform + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (16*(thickness_gear + thickness_bearing) + thickness_bearing));  
 
 //Moon, for visualization, only
 //color("white") translate([15 + idler_length_correction + radius_contact(147) + radius_contact(11),0, height_sun]) sphere(r = 4);    

//EarthGearIn47T. Female, receives male clutch octagon.
color(color_gear_pegless)
mirror([0, 0, 0])
translate([0,0, 14*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 47, spoke_count = 5, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = 1.5*radius_outer_axle + slop_radial_tight, radius_bearing = radius_outer_shaft, axis_rez = 8);

//EarthIdlerIn36T.
color(color_gear_pegless)
translate([radius_contact(92) + radius_contact(36),0,12*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 36, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);
    
//EarthIdlerOut22T.
color(color_gear_pegless)
translate([radius_contact(92) + radius_contact(36), 0, 10*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 22, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = radius_idler_axle + slop_radial_loose + radius_clutch_rim, include_axle_grip = true);
*/
//--------------------CALENDAR--------------------CALENDAR--------------------CALENDAR-----------
/*
color(color_gear_pegged)
translate([0,0,15*(thickness_gear + thickness_bearing)])
difference()
    {
     union()
        {
         make_gear_extended(tooth_count = 147, spoke_count = 5, count_pegs = 3, width_spoke_inner = 34, width_spoke_outer = 12.25, thickness_outer_rim = 20, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_tight, radius_bearing = radius_outer_shaft);
         translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,thickness_gear])
            cylinder(r = radius_idler_axle + slop_radial_loose + radius_clutch_rim, h = thickness_bearing, $fn = rez_mid);  
           
         translate([0,0,thickness_gear]) DrawCalendarMarks();
        }
     translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,-epsilon]) //Old X translate = 36.57
        cylinder(r = radius_idler_axle + slop_radial_loose, h = thickness_gear + thickness_bearing + 2*epsilon, $fn = rez_mid);
    }

//CalendarIdlerIn31T.
color(color_gear_pegless)
translate([idler_length_correction + radius_contact(39) + radius_contact(31),0,16*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 31, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 5, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);
    
//CalendarIdlerOut23T.
color(color_gear_pegless)
translate([idler_length_correction + radius_contact(39) + radius_contact(31), 0, 14*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 23, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = radius_idler_axle + slop_radial_loose + radius_clutch_rim, include_axle_grip = true);
*/
    
//--------------------VENUS--------------------VENUS--------------------VENUS--------------------
//Venus has no idler arm, as this role is filled by the calendar gear's idler hole.
/*
//VenusGearOut39T. Should be printed fused with VenusGearOutClutch.
color(color_gear_pegless)
translate([0,0,16*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 39, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_outer_axle + slop_radial_loose, radius_bearing = 0);
    
//VenusGearOutClutch. Should be printed fused with VenusGearOut39T
color(color_clutch)
translate([0,0, 16*(thickness_platform + thickness_bearing) + thickness_gear])
    clutch_double(radius_clutch_outer = 1.5*radius_outer_axle, radius_clutch_inner = radius_outer_axle + slop_radial_loose);    
*/
//VenusPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 17*(thickness_platform + thickness_bearing)])
    planet_arm(radius_large_hole = 1.5*radius_outer_axle + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 50, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);
/*
//VenusPeg
translate([50, 0, 17*(thickness_gear + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (17*(thickness_gear + thickness_bearing) + thickness_bearing));  

//Venus, for visualization, only
//color("LemonChiffon") translate([50,0, height_sun]) sphere(r = 7); 
    

//Bearing, sits on top of VenusPlanetArm
color(color_bearing_unattached)
translate([0,0,17*(thickness_gear + thickness_bearing) + thickness_gear])
    bearing(radius_inner = 1.5*radius_outer_axle + slop_radial_loose, radius_outer = radius_outer_shaft);    

//VenusGearIn42T. Female, receives male clutch octagon. NOTE: Zeamon uses 41T, causing
//poor gear meshing but more accurate Mercury orbit (0.45 Earth days longer vs 1.66 Earth days
//shorter than actual.
color(color_gear_pegless)
mirror([0, 0, 0])
translate([0,0,18*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 42, spoke_count = 0, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = 1.5*radius_outer_axle + slop_radial_tight, radius_bearing = radius_outer_shaft, axis_rez = 8);
*/

//--------------------MERCURY--------------------MERCURY--------------------MERCURY--------------------
//Note, only the idler is locked to outer axle. Rest are on Mercury axle. 
/*
//MercuryIdlerArm, from 28T to 33T    
color(color_idler_arm)
rotate([0,0,0])
translate([0,0,19*(thickness_gear + thickness_bearing)])
    idler_arm(radius_large_hole = radius_outer_axle + slop_radial_tight, radius_small_hole = radius_idler_axle + slop_radial_loose, length_arm = idler_length_correction + radius_contact(28) + radius_contact(33), radius_bearing = radius_outer_shaft); //old length_arm = 31.28

//MercuryGearOut28T. Should be printed fused with MercuryGearOutClutch.
color(color_gear_pegless)
translate([0,0,20*(thickness_gear + thickness_bearing)])
    make_gear_extended(tooth_count = 28, spoke_count = 0, count_pegs = 0, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_mercury_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);
    
//MercuryGearOutClutch. Should be printed fused with MercuryGearOut28T
color(color_clutch)
translate([0,0, 20*(thickness_platform + thickness_bearing) + thickness_gear])
    {
     clutch_double(radius_clutch_outer = 1.5*radius_mercury_axle, radius_clutch_inner = radius_mercury_axle + slop_radial_tight, radius_bearing = 1.5*radius_mercury_axle + slop_radial_slide + radius_clutch_rim); 
     //Grip   
     translate([offset_gear_grip * (radius_mercury_axle + slop_radial_tight),-(radius_mercury_axle + slop_radial_tight),0])
        cube([(1-offset_gear_grip)*(radius_mercury_axle + slop_radial_tight), 2*(radius_mercury_axle + slop_radial_tight), 2*thickness_gear + 3*thickness_bearing]);   
    }

//MercuryPlanetArm
color(color_planet_arm)
rotate([0,0,0])
translate([0,0, 21*(thickness_platform + thickness_bearing)])
    planet_arm(radius_large_hole = 1.5*radius_mercury_axle + slop_radial_slide, radius_small_hole = radius_planet_peghole, length_arm = 29, radius_rim = radius_clutch_rim, thickness_arm = thickness_gear);    

//MercuryPeg
translate([29, 0, 21*(thickness_gear + thickness_bearing) + thickness_bearing])
    planet_peg(peg_height = height_sun - (21*(thickness_gear + thickness_bearing) + thickness_bearing));  

//Mercury, for visualization, only
//color("DarkSlateGray") translate([29,0, height_sun]) sphere(r = 6);     

//Cap on Mercury assembly
color("DarkSeaGreen")
//mirror([0,0,1])
translate([0,0, 22*(thickness_platform + thickness_bearing)])
difference()
    {
     cylinder(r = 1.5*radius_mercury_axle + slop_radial_slide + radius_clutch_rim, h = thickness_gear + 2*thickness_bearing, $fn = rez_mid);
     cylinder(r = 1.5*radius_mercury_axle + slop_radial_tight, h = thickness_gear + thickness_bearing, $fn = 8);
     cylinder(r = radius_sun_axle + slop_radial_loose, h = thickness_gear + 2*thickness_bearing + epsilon, $fn = rez_lo);        
    }

//MercuryIdlerIn33T.
color(color_gear_pegless)
translate([radius_contact(28) + radius_contact(33),0,20*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 33, spoke_count = 3, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_idler_axle + slop_radial_loose + radius_clutch_rim, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = 0, include_axle_grip = true);

//MercuryIdlerOut19T.
color(color_gear_pegless)
translate([radius_contact(28) + radius_contact(33), 0, 18*(thickness_gear + thickness_bearing)])
mirror([1,0,0])
    make_gear_extended(tooth_count = 19, spoke_count = 4, count_pegs = 0, width_spoke_inner = 15, width_spoke_outer = 7, thickness_outer_rim = 10, radius_central_cylinder = radius_outer_shaft, radius_axis = radius_idler_axle + slop_radial_tight, radius_bearing = radius_idler_axle + slop_radial_loose + radius_clutch_rim, include_axle_grip = true);
*/    

//_____________________________________________________________________________________________________
//_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____MODULES_____
//_____________________________________________________________________________________________________
    
module idler_arm(radius_large_hole, radius_small_hole, radius_large_body = radius_outer_shaft, length_arm, thickness_arm = thickness_gear, count_pegs = 3, radius_bearing = 0)
    {
     linear_extrude(height = thickness_arm)
        {
         difference()
            {
             union()
                {
                 //inner pegged body
                 circle(r = radius_large_body, $fn = rez_mid);
                 //outer body
                 translate([length_arm, 0, 0])
                    circle(r = radius_small_hole + radius_clutch_rim, $fn = rez_mid);
                 polygon(points=[[0,radius_large_body], 
                    [length_arm,radius_small_hole + radius_clutch_rim],
                    [length_arm,-(radius_small_hole + radius_clutch_rim)],
                    [0,-radius_large_body]]);
                }
             circle(r = radius_large_hole, $fn = rez_hi); 
             translate([length_arm,0,0]) 
                circle(r = radius_small_hole, $fn = rez_mid);                
            }
        }

     //inner bearing
      if (radius_bearing > 0)
        {
         translate([0,0,thickness_gear])
         bearing(radius_inner = radius_large_hole, radius_outer = radius_outer_shaft);
        }
        
     //outer bearing
     translate([length_arm, 0, thickness_gear])
     difference()
        {
         cylinder(r = radius_small_hole + radius_clutch_rim, h = thickness_bearing, $fn = rez_mid);
         translate([0,0,-epsilon])
            cylinder(r = radius_small_hole, h = thickness_bearing + 2*epsilon, $fn = rez_mid);
        }
        
     if (count_pegs > 0)
        {
         thickness_peg = radius_bearing > 0? thickness_gear + thickness_bearing : thickness_gear;
         for (current_peg = [1:count_pegs])
            {
             rotate([0,0, (current_peg - 1) * 360/count_pegs])
             translate([radius_large_hole - depth_peg,-width_peg/2,0])
                cube([depth_peg, width_peg, thickness_peg]);
            }
        }        
    }

module bearing(radius_inner, radius_outer)
    {
     difference()
        {
         cylinder(r = radius_outer, h = thickness_bearing, $fn = rez_mid);
         translate([0,0,-epsilon])
            cylinder(r = radius_inner, h = thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }

module clutch_single(radius_clutch_outer, radius_clutch_inner, thickness_clutch = thickness_gear)
    {
     difference()
        {
         union()
            {
             //Inserted part
             cylinder(r = radius_clutch_outer, h = thickness_clutch, $fn = rez_hi);
             //Bearing
             translate([0,0,thickness_clutch])
                cylinder(r = radius_outer_shaft, h = thickness_bearing, $fn = rez_mid);
            }
         translate([0,0,-epsilon])
            cylinder(r = radius_clutch_inner, h = thickness_clutch + thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }
    
module clutch_double(radius_clutch_outer, radius_clutch_inner, radius_bearing = radius_outer_shaft)
    {
     difference()
        {
         union()
            {
             //Part inserted into planet arm
             translate([0,0,thickness_bearing]) cylinder(r = radius_clutch_outer, h = thickness_gear + thickness_bearing, $fn = rez_hi);
             //Bearing
                cylinder(r = radius_bearing, h = thickness_bearing, $fn = rez_mid);
                
             //Part inserted into gear
             translate([0,0,thickness_gear + 2*thickness_bearing])
                cylinder(r = radius_clutch_outer, h = thickness_gear + thickness_bearing, $fn = 8);
            }
         translate([0,0,-epsilon])
            cylinder(r = radius_clutch_inner, h = 2*thickness_gear + 3*thickness_bearing + 2*epsilon, $fn = rez_hi);
        }
    }    

module planet_arm(radius_large_hole, radius_small_hole, length_arm, radius_rim, thickness_arm = thickness_gear)
    {
        {
         difference()
            {
             union()
                {
                 //inner clutched body
                 cylinder(r = radius_large_hole + radius_rim, h = thickness_gear + thickness_bearing,$fn = rez_mid);
                 //outer body, holds planet peg
                 translate([length_arm, 0, 0])
                    cylinder(r = radius_small_hole + radius_rim, h = thickness_gear, $fn = rez_lo);
                 //Arm polygon
                 linear_extrude(height = thickness_arm)  
                     polygon(points=[[0,radius_large_hole + radius_rim], 
                        [length_arm,radius_small_hole + radius_rim],
                        [length_arm,-(radius_small_hole + radius_rim)],
                        [0,-(radius_large_hole + radius_rim)]]);
                 //Cone, holds planet peg
                 translate([length_arm, 0, thickness_gear])
                 difference()
                    {
                     linear_extrude(height = height_planet_peg_cone, scale = (radius_small_hole + 1)/(radius_small_hole + radius_rim))   
                        circle(radius_small_hole + radius_rim, $fn = rez_lo);
                     translate([0,0,-epsilon])
                        cylinder(r = radius_small_hole, h = thickness_gear + height_planet_peg_cone + 2*epsilon, $fn = rez_mid);
                    }
                 //Clutch screw block
                 translate([-(radius_large_hole + 2*radius_rim), - width_planet_arm_screw_block/2,0])
                    cube([width_planet_arm_screw_block,width_planet_arm_screw_block,thickness_gear + thickness_bearing]);
                }

             //main hole
             translate([0,0,-epsilon])
             cylinder(r = radius_large_hole, h = thickness_gear + thickness_bearing + 2*epsilon, $fn = rez_hi); 
             //peg hole
             translate([length_arm,0,thickness_bearing]) 
                cylinder(r = radius_small_hole, h = thickness_gear + height_planet_peg_cone + 2*epsilon,$fn = rez_mid);
             //screw hole
             translate([0,0, (thickness_gear + thickness_bearing)/2])
             rotate([0,-90,0])
                cylinder(r = radius_planet_arm_screwhole, h = radius_large_hole + 2*radius_rim + epsilon, $fn = 6);   
            }         
        }
    }

module earth_arm(radius_large_hole, radius_small_hole, length_arm, radius_rim, thickness_arm = thickness_gear)
    {//Special case for planet arms, owing to interaction with calendar gear
        {
         difference()
            {
             union()
                {
                 //inner clutched body
                 cylinder(r = radius_large_hole + radius_rim, h = thickness_gear + thickness_bearing,$fn = rez_mid);
                 //outer body, holds planet peg
                 translate([length_arm, 0, 0])
                    cylinder(r = radius_small_hole + radius_rim, h = thickness_gear, $fn = rez_lo);
                 //Arm polygon
                 linear_extrude(height = thickness_arm)  
                     polygon(points=[[0,radius_large_hole + radius_rim], 
                        [length_arm,radius_small_hole + radius_rim],
                        [length_arm,-(radius_small_hole + radius_rim)],
                        [0,-(radius_large_hole + radius_rim)]]);
                 //cone at small end
                 translate([length_arm, 0, thickness_gear])
                 linear_extrude(height = thickness_gear + 2*thickness_bearing, scale = (4)/(radius_small_hole + radius_rim))   
                    circle(r = radius_small_hole + radius_rim, $fn = rez_lo);
                 //Clutch screw block
                 translate([-(radius_large_hole + 2*radius_rim), - width_planet_arm_screw_block/2,0])
                    cube([width_planet_arm_screw_block,width_planet_arm_screw_block,thickness_gear + thickness_bearing]);
                }

             //main hole
             translate([0,0,-epsilon])
             cylinder(r = radius_large_hole, h = thickness_gear + thickness_bearing + 2*epsilon, $fn = rez_hi); 
             //peg hole
             translate([length_arm,0,thickness_bearing]) 
                cylinder(r = radius_planet_peghole, h = 2*thickness_gear + thickness_bearing + 2*epsilon,$fn = rez_mid);
             //screw hole
             translate([0,0, (thickness_gear + thickness_bearing)/2])
             rotate([0,-90,0])
                cylinder(r = radius_planet_arm_screwhole, h = radius_large_hole + 2*radius_rim + epsilon, $fn = 6);   
            }         
        }
    }

module make_gear_extended(tooth_count, spoke_count = 0, count_pegs = 0, width_spoke_inner = 30, width_spoke_outer = 15, thickness_outer_rim = 10, radius_central_cylinder, radius_axis, radius_bearing = 0, axis_rez = rez_hi, include_axle_grip = false)
    {
     radius_tooth_inner = ((modul * tooth_count) - 2 * (modul + (modul / 6))) / 2;
     radius_tooth_outer = ((modul * tooth_count) + modul * 2) / 2;
     echo("radius inner = ", radius_tooth_inner);
     echo("radius outer = ", radius_tooth_outer);        
        
     difference()
        {
         union()
            {
             //Spokes
              if (spoke_count > 0)
                {
                 for(current_spoke = [1:spoke_count])
                    {
                     rotate([0,0,(current_spoke-1)*360/spoke_count])
                     linear_extrude(height = thickness_gear)
                        polygon(points=[[0,-width_spoke_inner/2],
                            [radius_tooth_inner - thickness_outer_rim,-width_spoke_outer/2],
                            [radius_tooth_inner - thickness_outer_rim,width_spoke_outer/2],
                            [0,width_spoke_inner/2]]);
                    }
                }
                
             //Bearing on top
             if (radius_bearing > 0)
                 translate([0,0,thickness_gear]) cylinder(r = radius_bearing, h = thickness_bearing, $fn = rez_mid);
                
             difference()
                {
                 //Main gear
                 pfeilrad (modul=1, zahnzahl=tooth_count, hoehe=thickness_gear, bohrung=0, eingriffswinkel=20, schraegungswinkel=30);

                 //Empty torus
                 translate([0,0,-epsilon])
                 difference()
                    {
                     cylinder(r = radius_tooth_inner - thickness_outer_rim, h = thickness_gear + 2*epsilon, $fn = rez_mid);
                     translate([0,0,-epsilon])
                        cylinder(r = radius_central_cylinder, h = thickness_gear + 4*epsilon, $fn = rez_mid);
                    }
                }
            }
          //Central axis hole
          translate([0,0,-epsilon]) 
            cylinder(r = radius_axis, h = thickness_gear + thickness_bearing + 2*epsilon, $fn = axis_rez);
        }
        
     if (count_pegs > 0)
        {
         for (current_peg = [1:count_pegs])
            {
             thickness_peg = count_pegs > 0? thickness_gear + thickness_bearing : thickness_gear;   
             rotate([0,0, (current_peg - 1) * 360/count_pegs])
             translate([radius_axis + slop_radial_tight - depth_peg,-width_peg/2,0])
                cube([depth_peg, width_peg, thickness_peg]);
            }
        }
     if (include_axle_grip)
        {
         translate([radius_axis * offset_gear_grip, -radius_axis, 0])
            cube([radius_axis * (1 - offset_gear_grip), 2*radius_axis,thickness_gear]);
        }
    }    

   
    


module mercury_drive()
    {
     //Note: axle with 136 teeth, turned by handle with 11 teeth, will make
     //approximately one week of Earth orbit per handle rotation.
    color("LightSteelBlue")
    translate([0,0,-extension_below_platform_mercury_axle])
    difference()
        {
         //Drive gear
         translate([0,0,thickness_gear])
         mirror([0,0,1])
         difference()
            {
             //kegelrad(modul=1, zahnzahl=136,  teilkegelwinkel=45, zahnbreite=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=0);
                
             pfeilrad (modul=1, zahnzahl=136, hoehe=thickness_gear, bohrung=0, eingriffswinkel=20, schraegungswinkel=30);   
                
             //Hollow area for spokes
             translate([0,0,-epsilon])
                cylinder(r = 50, h = 10, $fn = rez_mid);
            }    
        }
        
    
     translate([0,0,-extension_below_platform_mercury_axle])
     difference()
        {
         union()
            {
             //Spokes   
             for(current_spoke = [1:5])
                {
                 rotate([0,0,(current_spoke-1)*360/5])
                 linear_extrude(height = 5)
                    polygon(points=[[0,-12],
                        [51,-6],
                        [51,6],
                        [0,12]]);
                }
            }
         translate([0,0,-5])
            cylinder(r = radius_mercury_axle + slop_radial_tight, h = 20, $fn = rez_mid);         
        }
    
    //Grip
     translate([(radius_mercury_axle + slop_radial_tight) * offset_gear_grip, -(radius_mercury_axle + slop_radial_tight), -extension_below_platform_mercury_axle])
        cube([0.5*radius_mercury_axle, 2*(radius_mercury_axle + slop_radial_tight), 5]);        
    }

module mercury_axle()
    {
     color("LightSteelBlue")
     difference()
        {
         //Main cylinder outer wall
         cylinder(r = radius_mercury_axle, h = height_mercury_axle, $fn = rez_mid);
            
         //Main cylinder inner hollow
         translate([0,0,-epsilon])
            cylinder(r = radius_mercury_axle - thickness_axle_wall, h = height_mercury_axle + 2*epsilon, $fn = rez_mid);

         //Grip
         translate([radius_mercury_axle * offset_gear_grip, -radius_mercury_axle, 0])
            cube([radius_mercury_axle, 2*radius_mercury_axle, height_mercury_axle]);
        }
    }    

module outer_axle()
    {
    color("LightSalmon")
        {
         difference()
            {
             union()
                {
                 //Platform
                 cylinder(r = radius_platform, h = thickness_platform, $fn = rez_hi); 
                 //Bearing
                 translate([0,0,thickness_platform]) 
                    cylinder(r = radius_outer_shaft, h = thickness_bearing, $fn = rez_lo); //Base bearing
                }
             //Hollow in platform
             translate([0,0,-epsilon])   
                cylinder(r = radius_outer_axle - thickness_axle_wall, h = (thickness_platform + thickness_bearing) + 2*epsilon, $fn = rez_mid);
             //Mounting holes
             for (i = [1:3])
                {
                 rotate([0,0,i * 360/3])
                    {
                     translate([24, 0, -epsilon])
                        cylinder(r = 1.55, h = 10, $fn = 16);
                     translate([24, 0, thickness_platform-2.25])
                        cylinder(r = 3.5, h = 10, $fn = 6);                    
                    }
                }                
            }
        
        translate([0,0,thickness_platform])    
        linear_extrude(height = height_outer_axle)
        difference()
            {
             //Main tube   
             circle(r = radius_outer_axle, $fn = rez_mid);
             //Hollow in main tube
             circle(r = radius_outer_axle - thickness_axle_wall, $fn = rez_mid);
             //Peg slots
             for (i = [1:3])
                {
                 rotate([0,0,i * 360/3])
                 translate([radius_outer_axle - depth_slot, -width_slot/2])
                    square([depth_slot, width_slot]);
                }
            }
        }
    }

module idler_axle()
    {
    //rotate([0,90,0])
    difference()
        {
         cylinder(r = radius_idler_axle, h = 3*thickness_gear + 2*thickness_bearing, $fn = rez_hi);
         //Side cut for gear axis grip and printability
         translate([offset_gear_grip * radius_idler_axle, -radius_idler_axle])
            cube([radius_idler_axle, 2*radius_idler_axle,3*thickness_gear + 2*thickness_bearing]);
         //Bevels
         rotate_extrude()
         translate([radius_idler_axle, 0])
            circle(r = 1, $fn = 4);
         translate([0,0,3*thickness_gear + 2*thickness_bearing])
         rotate_extrude()
         translate([radius_idler_axle, 0])
            circle(r = 1, $fn = 4);
        }
    }
 
//Next function returns gear contact ratio for setting spacing of interacting gears
function radius_contact(tooth_count, modul = 1) = ((((modul * tooth_count) - 2 * (modul + (modul / 6))) / 2) + (((modul * tooth_count) + modul * 2) / 2)) / 2;

module All_Pegs()
    {
     for (current_peg = [0:7])
     translate([0, 10*current_peg,0])
     rotate([0,90,0])
        planet_peg(peg_heights[current_peg]);
    }

module planet_peg(peg_height)
    {
    color("Moccasin")
    rotate([0,0,360/16])
    linear_extrude(height = peg_height)
    difference()
        {
         circle(r = radius_planet_peg, $fn = 8);
         //translate([0.8*radius_planet_peg, -radius_planet_peg]) square([2*radius_planet_peg, 2*radius_planet_peg]);
        }
    }     
   
module DrawCalendarMarks()
    {
     for (current_month = [0:11]) 
        {
         rotate([0,0,month_days[current_month]/365 * 360])
            {
             linear_extrude(height = thickness_big_marks)
             translate([radius_marks,-thickness_big_marks/2])
                square([height_big_marks, width_big_marks]);
                
             translate([radius_words,0,0])
             rotate([0,0,90])
             linear_extrude(height = thickness_letters) 
                {
                 text(text = str(month_name[current_month]), font = font, size = font_size, valign = "bottom", halign = "center");
                }
            }
        }
     
     //Day marks
     for (current_day = [0 : 364])
         linear_extrude(height = thickness_small_marks)
         rotate([0,0,(current_day / 365) * 360])
         translate([radius_marks + (height_big_marks - height_small_marks),-width_small_marks/2])
                square([height_small_marks, width_small_marks]);
    }    

module printable_planets()
    {
     //Saturn
     difference() //TOP
        {
         union()
            {
             sphere(r = 9, $fn = rez_mid);   
             cylinder(r = 18, h = 1, $fn = rez_mid); //Rings                
            }
         translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
         rotate([0,26.7,0]) translate([0,0,-2]) cylinder(r = radius_planet_peg, h = 7, $fn = rez_lo); //Peg hole
        }
     translate([40,0,0]) //BOTTOM
     difference() 
        {
         sphere(r = 9, $fn = rez_mid);   
         translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
         rotate([0,26.7,0]) translate([0,0,-2]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
        }        
        
     //Jupiter
     translate([0,35,0])
        {
         difference() //TOP
            {
             sphere(r = 12, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 12, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        }

     //Mars
     translate([0,60,0])
        {
         difference() //TOP
            {
             sphere(r = 7, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 7, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        }

     //Earth
     translate([0,80,0])
        {
         difference() //TOP
            {
             sphere(r = 8, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 8, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        }
        
     //Moon
     translate([0,100,0])
        {
         difference() //TOP
            {
             sphere(r = 4, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 4, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        }  
        
     //Venus
     translate([0,120,0])
        {
         difference() //TOP
            {
             sphere(r = 7, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 7, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        } 
        
     //Mercury
     translate([0,140,0])
        {
         difference() //TOP
            {
             sphere(r = 6, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([30,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 6, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        } 
        
     //Sun
     translate([0,-40,0])
        {
         difference() //TOP
            {
             sphere(r = 15, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 5, $fn = rez_lo); //Peg hole
            }
         translate([40,0,0]) //BOTTOM
         difference() 
            {
             sphere(r = 15, $fn = rez_mid);   
             translate([0,0,-50]) cylinder(r = 50, h = 50, $fn = 4); //Negative hemisphere
             translate([0,0,-epsilon]) cylinder(r = radius_planet_peg, h = 50, $fn = rez_lo); //Peg hole
            }        
        }         
    }
