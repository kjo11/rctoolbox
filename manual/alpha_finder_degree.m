function a= alpha_finder_degree(alpha,l,phase)
        a= 180*acos((1-l)*sind(alpha)^2+cosd(alpha)*sqrt(1-(1-l)^2*sind(alpha)^2))/pi-phase;
end