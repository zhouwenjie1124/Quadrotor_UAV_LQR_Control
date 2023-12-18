
Oc = [0,0,0];
Vc = [1,0,0];

J = 0.1 * eye(3);
g = 9.8;
m = 0.25;
Rcu = eye(3);

ddvdt_dv = 0*eye(3);
ddvdt_dw = 0*eye(3);
ddwdt_dw = 0*eye(3);

A1 = [-skew(Oc) ,eye(3),-skew(Vc),zeros(3);
    zeros(3),ddvdt_dv,skew(Rcu*[0;0;g]),ddvdt_dw;
    zeros(3),zeros(3),-skew(Oc),eye(3);
    zeros(3),zeros(3),zeros(3),ddwdt_dw;];

B1 = [[0;0;0],zeros(3);
     [0;0;-1/m],zeros(3);
     [0;0;0],zeros(3);
     [0;0;0],J^-1;];

Fmc=0.00001;
Pmc = 100;
Vmc = 0.001;
Q = eye(12);
Q(1,1)=Pmc; Q(2,2)=Pmc; Q(3,3)=Pmc;
Q(4,4)=Vmc; Q(5,5)=Vmc; Q(6,6)=Vmc;
R = eye(4);   R(1,1) = Fmc;    
k1 = lqr(A1, B2, Q, R);