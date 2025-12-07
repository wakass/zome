include <prism-chamfer.scad>;



module chamfer_box(w,h,d,chamfer_amount) {
poly_verts = [[0,0],[w,0],[w,d], [0,d]];

difference() {
linear_extrude(height=h)
    polygon(poly_verts);
    
// Make chamfers for top bottom and all edges.
for (edge = [1,2,3,4]) {
prism_chamfer_mask(poly_verts, start_edge=edge, end_edge=edge, height=0,
                          side=chamfer_amount, side2=0, corner_slope="medium");
prism_chamfer_mask(poly_verts, start_edge=edge, end_edge=edge, height=h,
                          side=chamfer_amount, side2=0, corner_slope="medium");

}


}
}
//w = 20;
//h = 20;
//d = 40;
//
//chamfer_box(w,h,d, 3);
