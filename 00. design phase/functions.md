face_angle_local =
function (theta, m, n) {     return asin(cos(theta)^2 *sin(2*(PI rad )*m/n) / sqrt(1-(cos(theta)^2*cos(2*(PI rad)*m/n)+sin(theta)^2)^2)); }

Mid angle of two faces (alpha):
-- Note Q is defined inversely in the dome
angle_face = 
#face_angle_local(90deg-#Q, #M1, #N) - #face_angle_local(90deg-#Q, #M2, #N)


Inner angle of parallelogram projected onto alpha/2 (half of the mid angle between two faces)
angle_top_projected = 
2*atan(tan(#angle_top/2)/sin(#alpha/2))


angle of downward slope of hub arm
90deg-asin(cos(#angle_bottom_projected/2)*sin(#alpha/2)/cos(#angle_bottom/2))

sin(q) = sin(#theta/2) / sin(#gamma/2)
q= corr_angle_bottom = asin(sin(#theta/2) / sin(#gamma/2))
