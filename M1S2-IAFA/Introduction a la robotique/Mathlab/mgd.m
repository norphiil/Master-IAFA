function T = mgd(q, h, L1, L2, L3) 
    q1 = q(1);
    q2 = q(2);
    q3 = q(3);
    q4 = q(4);
    
    T01 = [cos(q1) -sin(q1) 0 0;
           sin(q1) cos(q1) 0 0;
           0 0 1 h;
           0 0 0 1];
    
    T12 = [cos(q2) -sin(q2) 0 L1;
           sin(q2) cos(q2) 0 0;
           0 0 1 0;
           0 0 0 1];
    
    T23 = [1 0 0 L2;
           0 1 0 0;
           0 0 1 q3;
           0 0 0 1];
    
    T34 = [cos(q4) -sin(q4) 0 0;
           sin(q4) cos(q4) 0 0;
           0 0 1 0;
           0 0 0 1];
    
    T = T01 * T12 * T23 * T34;
end

