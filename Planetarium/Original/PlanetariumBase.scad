include <Getriebe.scad>;

rez_hi = 96;
rez_mid = 64;
rez_lo = 32;
epsilon = 0.01;
modul = 1;

radius_sun_axle = 2;
radius_mercury_axle = 5.5;
radius_other_axle = 5;
slop_axle_rotate = 0.6;
slop_axle_tight = 0.4;

contact_radius_large_wheel = radius_contact(136, modul = 1);
contact_radius_small_wheel = radius_contact(22, modul = 1);
inner_radius_large_wheel = (((modul * 136) - 2 * (modul + (modul / 6))) / 2);
outer_radius_large_wheel = (((modul * 136) + modul * 2) / 2);

radius_wheel_large = 136/2 + 0.4; //Contact radius. Outermost radius is slightly larger.
radius_wheel_small = 22/2 + 0.4; //Contact radius. Outermost radius is slightly larger.
radius_finger_wheel = 40;
radial_space_beyond_contact_radius = 5;
radius_mounting_holes = 1.75;
radius_to_mounting_holes = 24;

thickness_floor = 2;
thickness_gear = 5;
thickness_bearing = 2;
thickness_wall = 2;
thickness_roof = 5;
height_total = 32;

width_slot = 3;
depth_slot = 2;
thickness_axle_wall = 3;
radius_outer_axle = radius_mercury_axle + 0.5 + thickness_axle_wall;
height_outer_axle = 19*(thickness_gear + thickness_bearing) + thickness_bearing;
height_outer_axle_above_base = 40;
radius_outer_shaft = 18;

//rotate([180,0,0]) 
//color(c = RandomColor()) Housing();
    
color(c = RandomColor()) Floor();

//translate([0,0,height_total])
//color(c = RandomColor()) Outer_Axle();
    
//color(c = RandomColor()) FingerWheel();

//color(c = RandomColor()) FingerWheelSupport();

//Main wheel
//color(c = RandomColor()) translate([0,0, thickness_floor + 10]) pfeilrad(modul=1, zahnzahl=136, hoehe=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=30);

//Minor wheel
//color(c = RandomColor()) translate([radius_wheel_large + radius_wheel_small,0, thickness_floor + 10]) mirror([1,0,0]) pfeilrad(modul=1, zahnzahl=22, hoehe=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=30);

//rotate([0,90,0]) color(c = RandomColor()) FingerWheelAxle();

module FingerWheelAxle()
    {
     difference()
        {
         cylinder(r = radius_other_axle, h = 25, $fn = rez_hi);
         //Side cut for gear axis grip and printability
         translate([0.8 * radius_other_axle, -radius_other_axle, -epsilon])
            cube([radius_other_axle, 2*radius_other_axle,25 + 2*epsilon]);
        }
    }


module FingerWheelSupport()
    {
     translate([radius_wheel_large + radius_wheel_small,0,thickness_floor])
        {
         difference()
            {
             union()
                {
                 translate([0,0,15.25]) cylinder(r = radius_finger_wheel/2, h = 4.5, $fn = rez_mid);
                 rotate([0,0,67.5])
                 rotate_extrude(angle = 45, $fn = rez_mid)
                    {
                     translate([radius_finger_wheel - 9,0]) square([8,19.75]);
                     translate([0,15.25]) square([radius_finger_wheel - 6, 4.5]);
                    }
                 rotate([0,0,247.5])
                 rotate_extrude(angle = 45, $fn = rez_mid)
                    {
                     translate([radius_finger_wheel - 9,0]) square([8,19.75]);
                     translate([0,15.25]) square([radius_finger_wheel - 6, 4.5]);
                    } 
                }
             cylinder(r = radius_other_axle + slop_axle_rotate, h = 30, $fn = rez_hi); //Central axle hole
             rotate([0,0,90]) translate([radius_finger_wheel - 5,0,0]) cylinder(r = radius_mounting_holes, h = 40, $fn = 8);
             rotate([0,0,270]) translate([radius_finger_wheel - 5,0,0]) cylinder(r = radius_mounting_holes, h = 40, $fn = 8);
            }
        }
    }


module FingerWheel()
    {
     translate([radius_wheel_large + radius_wheel_small, 0, height_total - thickness_roof - thickness_gear])
        {
         difference()
            {
             cylinder(r = radius_finger_wheel - 1, h = thickness_gear, $fn = rez_mid);
             //Axle hole   
             translate([0,0,-epsilon]) cylinder(r = radius_other_axle + slop_axle_tight, h = thickness_gear + 2*epsilon, $fn = rez_hi);
             //Finger divots
             for (d = [1:5])
                scale([1,1,0.5])
                rotate([0,0,(d-0.5)*360/5])
                translate([radius_finger_wheel * 0.6,0,9])
                    sphere(r = 8);
             //Lateral recess for reduced friction
             rotate_extrude($fn = rez_mid)
             translate([radius_finger_wheel * 0.6 + 8 + 1, thickness_gear - 1])
                square([10,2]);
            }
         //grip
         translate([0.8*(radius_other_axle + slop_axle_tight),-radius_other_axle,0])
            cube([radius_other_axle, 2*radius_other_axle,thickness_gear]);
         //Cap
         translate([0,0,thickness_gear])
         linear_extrude(height = thickness_gear*0.75, scale = 0.5)   
            circle(r = 2*radius_other_axle, $fn = rez_mid);
         //Arrow
         translate([radius_finger_wheel * 0.5, -2, thickness_gear])
            cube([7, 4, 1.5]);
         translate([radius_finger_wheel * 0.5 + 8, 0, thickness_gear])
            cylinder(r = 4, h = 1.5, $fn = 3);
        }
    }

module Floor()
    {
     difference()
        {
         union()
            {
             //Main circle
             cylinder(r = 2 + radius_wheel_large + radial_space_beyond_contact_radius - slop_axle_tight, h = thickness_floor, $fn = rez_hi);
             //Minor circle
             translate([radius_wheel_large + radius_wheel_small,0,0])
                cylinder(r = 2 + radius_finger_wheel + radial_space_beyond_contact_radius - slop_axle_tight, h = thickness_floor, $fn = rez_hi);
             //Screw blocks on top of floor
             for (i = [1:3])
                {
                 rotate([0,0,i * 120 + 60])
                 translate([0,0,thickness_floor])
                 difference()
                    {
                     rotate([0,0,-3])
                     rotate_extrude(angle = 6, $fn = rez_hi)
                     translate([radius_wheel_large + epsilon,0])
                        square([radial_space_beyond_contact_radius - slop_axle_tight,2]);
                     translate([radius_wheel_large + radial_space_beyond_contact_radius/2,0])
                        cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
                    }
                }
              translate([radius_wheel_large + radius_wheel_small,0,thickness_floor])
              difference()
                {
                 rotate([0,0,-6])
                 rotate_extrude(angle = 12, $fn = rez_hi)
                 translate([radius_finger_wheel + epsilon,0])
                    square([radial_space_beyond_contact_radius - slop_axle_tight,2]);
                 translate([radius_finger_wheel + radial_space_beyond_contact_radius/2,0])
                    cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
                }
            }

         //Screw holes on rim______________________________________________
         for (i = [1:3])
            {
             rotate([0,0,i * 120 + 60])
             translate([radius_wheel_large + radial_space_beyond_contact_radius/2,0,-1])
                    cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
            }
          translate([radius_wheel_large + radius_wheel_small + radius_finger_wheel + radial_space_beyond_contact_radius/2,0,-1])
            cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
            
         //Screw holes for finger wheel support bracket
          translate([radius_wheel_large + radius_wheel_small,0,-epsilon])
            {
             rotate([0,0,90]) translate([radius_finger_wheel - 5,0,0]) cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
             rotate([0,0,270]) translate([radius_finger_wheel - 5,0,0]) cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
            }
        }
    //Fingerwheel axle cup
    translate([radius_wheel_large + radius_wheel_small,0,thickness_floor])
    difference()
        {
         cylinder(r = radius_other_axle + slop_axle_rotate + thickness_wall, h = 10, $fn = rez_mid);
         cylinder(r = radius_other_axle + slop_axle_rotate, h = 10 + epsilon, $fn = rez_mid);
        }
    //Mercury and sun axle bottom cup
    translate([0,0,thickness_floor])
    difference()
        {
         cylinder(r = radius_mercury_axle + slop_axle_rotate + thickness_wall, h = 10, $fn = rez_mid);
         cylinder(r = radius_sun_axle, h = 5 + epsilon, $fn = rez_mid); //Sun axle hole
         translate([0,0,5]) 
            cylinder(r = radius_mercury_axle + slop_axle_rotate, h = 5 + epsilon, $fn = rez_mid);
        }
    
     //Skid supports for main wheel
      for (s = [1:3])
        {
         translate([0,0,thickness_floor])
         rotate([0,0, s*120])
         rotate_extrude(angle = 20, $fn = rez_mid)
         translate([radius_wheel_large - 9,0,0])
            square([thickness_wall, 9.75]);
        }
     }

module Housing()
    {
     difference()
        {
         union()
            {
            //Main gear housing
            rotate_extrude($fn = rez_hi)
                {
                difference()
                    {
                     square([radius_wheel_large + radial_space_beyond_contact_radius + thickness_wall, height_total]);
                     translate([radius_wheel_large + radial_space_beyond_contact_radius + thickness_wall, height_total]) circle(r = 4, $fn = 4);
                    }
                //Footing detail
                translate([radius_wheel_large + radial_space_beyond_contact_radius + thickness_wall, 0])
                    polygon([[0,0], [4,0], [4,2], [2,4], [2,6], [0,8]]);
                }
            //Minor gear housing
            translate([radius_wheel_large + radius_wheel_small,0])
            rotate_extrude($fn = rez_hi)
                {
                difference()
                    {
                     square([radius_finger_wheel + radial_space_beyond_contact_radius + thickness_wall, height_total]);
                     translate([radius_finger_wheel + radial_space_beyond_contact_radius + thickness_wall, height_total]) circle(r = 4, $fn = 4);
                    }
                //Footing detail
                translate([radius_finger_wheel + radial_space_beyond_contact_radius + thickness_wall, 0])
                    polygon([[0,0], [4,0], [4,2], [2,4], [2,6], [0,8]]);
                }
            }
        //Main gear negative
        translate([0,0,-epsilon])
        rotate_extrude($fn = rez_hi)
            {
            difference()
                {
                 square([radius_wheel_large + radial_space_beyond_contact_radius, height_total - thickness_roof]);
                 translate([radius_wheel_large + radial_space_beyond_contact_radius, height_total - thickness_roof]) circle(r = 4, $fn = 4);
                }
             translate([radius_wheel_large + radial_space_beyond_contact_radius, 0])
                square([2,2]);
            }
        //Minor gear negative
        translate([radius_wheel_large + radius_wheel_small,-epsilon])
        rotate_extrude($fn = rez_hi)
            {
             difference()
                {
                 square([radius_finger_wheel + radial_space_beyond_contact_radius, height_total - thickness_roof]);
                 translate([radius_finger_wheel + radial_space_beyond_contact_radius, height_total - thickness_roof]) circle(r = 4, $fn = 4);
                }
             translate([radius_finger_wheel + radial_space_beyond_contact_radius, 0])
                square([2,2]);
            }
        //Top hole for finger wheel access
        translate([radius_wheel_large + radius_wheel_small, 0, height_total - thickness_roof - epsilon])
        rotate_extrude($fn = rez_hi)
        difference()
            {
             square([radius_finger_wheel,thickness_roof + 2*epsilon]);
             translate([radius_finger_wheel,0]) circle(r = 5, $fn = 4);
            }
         //Hole for Mercury axle   
        translate([0,0,height_total - thickness_roof - epsilon])
            cylinder(r = radius_mercury_axle + slop_axle_rotate, h = thickness_roof + 2*epsilon, $fn = rez_mid);
        //Outer axle mounting holes
        for (i = [1:3]) 
            rotate([0,0,i*360/3])
            translate([radius_to_mounting_holes, 0, height_total - thickness_roof - epsilon])
                cylinder(r = radius_mounting_holes, h = thickness_roof + 2*epsilon, $fn = rez_lo);
        }
     //Stuff added back, after case hollowed out
     //Floor mounting screw catchers
     for (i = [1:3])
        {
         rotate([0,0,i * 120 + 60])
         translate([0,0,thickness_floor + 2])
         difference()
            {
             rotate([0,0,-3])
             rotate_extrude(angle = 6, $fn = rez_hi)
             translate([radius_wheel_large + epsilon,0])
             difference()
                {
                 square([radial_space_beyond_contact_radius + 1,10]);
                 translate([0,10])
                    circle(r = radial_space_beyond_contact_radius, $fn = 4);
                }
             translate([radius_wheel_large + radial_space_beyond_contact_radius/2,0])
                cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
            }
        }
      translate([radius_wheel_large + radius_wheel_small,0,thickness_floor + 2])
      difference()
        {
         rotate([0,0,-6])
         rotate_extrude(angle = 12, $fn = rez_hi)
         translate([radius_finger_wheel + epsilon,0])
         difference()
            {
             square([radial_space_beyond_contact_radius + 1,10]);
             translate([0,10])
                circle(r = radial_space_beyond_contact_radius, $fn = 4);
            }
         translate([radius_finger_wheel + radial_space_beyond_contact_radius/2,0])
            cylinder(r = radius_mounting_holes, h = 10, $fn = 8);
        }
     //Finger dial marks for days
     for (d = [1:14])
        {
         translate([radius_wheel_large + radius_wheel_small, 0, height_total - thickness_roof])
         rotate([0,0,-1.5 + d*360/14])
         rotate_extrude(angle = 3)
         translate([radius_finger_wheel - 5,0])
            polygon([[0,0],[thickness_roof / tan(60),thickness_roof],[6,thickness_roof],[6,0]]);
        }
     //Upper tube for Mercury axle
     translate([0,0,height_total - 15])
     difference()
        {
         cylinder(r = radius_mercury_axle + slop_axle_rotate + thickness_wall, h = 15, $fn = rez_mid);
         translate([0,0,-epsilon])
            cylinder(r = radius_mercury_axle + slop_axle_rotate, h = 15 + 2*epsilon, $fn = rez_mid);
        }
    //Outer axle mounting nut holders
    for (i = [1:3]) 
        rotate([0,0,i*360/3])
        translate([radius_to_mounting_holes, 0, height_total - thickness_roof - 3])
        difference()
            {
             cylinder(r = 5.5, h = 3, $fn = rez_lo);
             translate([0,0,-epsilon]) cylinder(r = 3.5, h = 3 + 2*epsilon, $fn = 6);        
            }
    }   

module Outer_Axle()
    {
     difference()
        {
         linear_extrude(height = height_outer_axle_above_base, scale = radius_outer_shaft/(radius_to_mounting_holes + 5))
            circle(r = radius_to_mounting_holes + 5, $fn = rez_hi);
        //Outer axle mounting holes
        for (i = [1:3]) 
        rotate([0,0,i*360/3])
            {
             translate([radius_to_mounting_holes, 0, -epsilon])
                cylinder(r = radius_mounting_holes, h = 10, $fn = rez_lo);
             translate([radius_to_mounting_holes, 0, 2])
                cylinder(r = 5, h = height_outer_axle_above_base, $fn = rez_mid);                
            }
         translate([0,0,-epsilon]) cylinder(r = radius_outer_axle - thickness_axle_wall, h = height_outer_axle_above_base + 2*epsilon, $fn = rez_mid);
        }
    
    translate([0,0,height_outer_axle_above_base])    
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



function RandomColor() = [(rands(0.4,1,1)[0]), (rands(0.4,1,1)[0]), (rands(0.4,1,1)[0]), 1];
    
//Next function returns gear contact ratio for setting spacing of interacting gears
function radius_contact(tooth_count, modul = 1) = ((((modul * tooth_count) - 2 * (modul + (modul / 6))) / 2) + (((modul * tooth_count) + modul * 2) / 2)) / 2;    