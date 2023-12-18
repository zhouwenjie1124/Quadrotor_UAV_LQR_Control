function Lx = skew(L)
% Computes the skew of L, Lx
Lx=[    0, -L(3),   L(2);
     L(3),     0,  -L(1);
    -L(2),  L(1),     0];
end

