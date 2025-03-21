function T = Rpiece(Rc, q) 
    x = q(1);
    y = q(2);
    z = q(3);

    
    T01 = [cos(pi/2) -sin(pi/2) 0 x;
           sin(pi/2) cos(pi/2) 0 y;
           0 0 1 z;
           0 0 0 1];
    
    T = Rc * T01;
end

