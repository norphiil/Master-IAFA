function [output1, output2] = MGI(X, Y, Z1, Z2)
    cq2 = (Z1^2 +Z2^2 - X^2 - Y^2)/2*X*Y;
    q2 = atan2((1-cq2^2)^(1/2),cq2);
    B1 = X + Y * cq2;
    B2 = Y * sin(q2);
    sq1 = (B1 * Z2 - B2 * Z1)/(B1^2 + B2^2);
    cq1 = (B1 * Z1 + B2 * Z2)/(B1^2 + B2^2);
    q1 = atan2(sq1, cq1);
    output1 = q1;
    output2 = q2;
end

