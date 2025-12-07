//
// Tool to hold two workpieces in a given angle
//
//  Author: MrFuzzy_F, 
//  License: CC BY-NC
//

$fa=1*1;
$fs=0.25*1;
eps  = 0.01; //numerical precision, openscad
tol  = 0.4;  //process tolerance (3d printing)

// workpiece fixing angle, default: 90 degrees [30:180]
//C1
holder_angle = 75.944;
// Uncomment to get C2
holder_angle = 180.0 - 75.944;

//E1
holder_angle = 99.0;
//Uncomment to get E2
holder_angle = 180.0 - 99.0; 

holder_thickness = 45;


/* [Screw hole guides] */
distance_screw = 22.0; // Distance between holes, holes are centered vertically
d_screw = 4.5; // Hole diameter
offset_screw = 11.0; // Normal distance from edge
/* [Screw hole guide insert?] */
insert_thickness = 2.0; // thickness
insert_cutout_length = 20; //length along arm

access_cutout_length = 20; //length along arm, access cutout has no thickness since it goes through
access_cutout_offset = eps; //offset
access_cutout_height = 35;

/* [Inner holder] */ 

// side length of holder plate
holder_side_length = 90;

// chamfer corner to avoid eg. contact with glue 
corner_chamfer = 10;

// width of cutout for clamps
clamp_cutout_width = 32;

// top height of cutout for clamps
clamp_cutout_height = 20;

// offset of clamp cutout to edge
clamp_offset = 12;

// 2 extra corners: use custom offset if >0, otherwise auto-computed if holder_angle > 90 degrees
flat_offset = 0;

// use fence 
use_fence = "no"; // [yes, no]

// thickness of fence adds to overall thickness
fence_thickness = 4; 

// width of fence over plate
fence_width = 7.5;  


/* [Optional outer clamp counter piece] */

// length of flat section under clamp
p2_clamp_width = 30;

// arm length covering workpiece
p2_arm_length_on_workpiece = 60;
    
// part thickness between clamp and corner
p2_clamp_corner_offset = 20;

// diameter of optional circular cutout in corner (e.g. to avoid glue contact)
p2_corner_cutout_diameter = 10;



cutout_position = holder_side_length/2 * (0.9 + 0.5*ln(90/holder_angle));
fence_thickness_mod = use_fence == "yes" ? fence_thickness : 0;

angle_r = (180-holder_angle)/2;
angle_l = 180-angle_r;
l_arm = p2_arm_length_on_workpiece;


module print(item=0) {
  if (item==0) main_inner_holder();
  if (item==1) main_outer_holder();
  if (item==2) outer_holder_insert();
}

item = 1;
print(item);



module main_inner_holder() {
    difference() {
        main_plate();
        
        // cut out openings for clamps
        translate([cutout_position, clamp_offset, 0])
            clamp_cutout();

            // 2nd cutout needs to be rotated according to plate angle
            rotate([0, 0, -90+holder_angle])
                translate([clamp_offset, cutout_position, 0])
                    rotate([0, 0, -90])
                        clamp_cutout();
    }
}


module main_plate() {
    linear_extrude(holder_thickness + fence_thickness_mod)
        if (holder_angle <= 90 && flat_offset == 0) {
            polygon(points=[
                [corner_chamfer * cos(holder_angle), corner_chamfer * sin(holder_angle)], 
                [holder_side_length * cos(holder_angle), holder_side_length * sin(holder_angle)], 
                [holder_side_length, 0], 
                [corner_chamfer, 0]]);
        } else {
            flat_offset_adj = flat_offset == 0 ? holder_side_length * 2/3 : flat_offset;
            polygon(points=[
                [corner_chamfer * cos(holder_angle), corner_chamfer * sin(holder_angle)], 
                [holder_side_length * cos(holder_angle), holder_side_length * sin(holder_angle)], 
                [flat_offset_adj * cos(holder_angle*2/3), flat_offset_adj * sin(holder_angle*2/3)], 
                [flat_offset_adj * cos(holder_angle/3), flat_offset_adj * sin(holder_angle/3)], 
                [holder_side_length, 0], 
                [corner_chamfer, 0]]);         
        }
        
    translate([corner_chamfer, -fence_width, 0])
        cube([holder_side_length-corner_chamfer, fence_width, fence_thickness_mod]);

    rotate([0, 0, -90-(90-holder_angle)])
        translate([-holder_side_length, -fence_width, 0])
            cube([holder_side_length-corner_chamfer, fence_width, fence_thickness_mod]);
              
}


module clamp_cutout() {
    
    translate([-clamp_cutout_width/2, 0, -0.01])
        cube([clamp_cutout_width, clamp_cutout_height/2, holder_thickness+fence_thickness_mod+0.02]);
    translate([0, clamp_cutout_height/2, -0.01])
        resize([clamp_cutout_width, clamp_cutout_height, holder_thickness+fence_thickness_mod+0.02])
            cylinder(1, 1);
    
}

module outer_holder_base(angle_l, angle_r, l_arm) {
        
    difference() {
        linear_extrude(holder_thickness)
            polygon(points=[[0,0],
                [l_arm * cos(angle_r), l_arm * sin(angle_r)], 
                [l_arm * cos(angle_r), l_arm * sin(angle_r) - p2_clamp_corner_offset], 
                [p2_clamp_width/2, -p2_clamp_corner_offset], [-p2_clamp_width/2, -p2_clamp_corner_offset],
                [l_arm * cos(angle_l), l_arm * sin(angle_l) - p2_clamp_corner_offset], 
                [l_arm * cos(angle_l), l_arm * sin(angle_l)]]);
        
        translate([0, 0, -0.01])
            cylinder(holder_thickness+0.02, d=p2_corner_cutout_diameter);
    }
}

module outer_holder_insert_cutout(tol=0.0) {
       /// Cutout
        translate([access_cutout_offset*cos(angle_l), access_cutout_offset*sin(angle_l), holder_thickness/2 - access_cutout_height/2])
            rotate(a=angle_r,v=[0,0,1])
                    translate([-p2_clamp_corner_offset*2,0,0])
                        cube([p2_clamp_corner_offset*4,access_cutout_length + tol, access_cutout_height+tol]);

}

module main_outer_holder() {
    
    difference() {
        outer_holder_base(angle_l,angle_r, p2_arm_length_on_workpiece);    
        outer_holder_insert_cutout(tol/2.0);
    }  
            
}

module outer_holder_insert() {
    
    difference() {
    intersection() {
        outer_holder_base(angle_l,angle_r, p2_arm_length_on_workpiece);    
        outer_holder_insert_cutout(-tol/2.0);
    }  
    
    /// Screw holes
   translate([offset_screw*cos(angle_l), offset_screw*sin(angle_l), holder_thickness/2 + distance_screw/2])
        rotate(a=90.0,v=[-cos(90-angle_r),sin(90-angle_r),0])
            translate([0,0,-p2_clamp_corner_offset*2])
            cylinder(p2_clamp_corner_offset*4+0.02, d=d_screw);        
        
   translate([offset_screw*cos(angle_l), offset_screw*sin(angle_l), holder_thickness/2 - distance_screw/2])
        rotate(a=90.0,v=[-cos(90-angle_r),sin(90-angle_r),0])
            translate([0,0,-p2_clamp_corner_offset*2])
            cylinder(p2_clamp_corner_offset*4+0.02, d=d_screw);        
         
    }
}
