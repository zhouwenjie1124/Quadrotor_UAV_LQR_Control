%% State Space Equation
% command value
Oc = [0,0,0];
Vc = [1,0,0];

% basic parameter
J = 0.1 * eye(3);
g = 9.8;
m = 0.25;
Rcu = eye(3);
ddvdt_dv = 0*eye(3);
ddvdt_dw = 0*eye(3);
ddwdt_dw = 0*eye(3);

% A matrix
% -----System state x = [Pe,Ve,Le,Oe,xI(P,L(3)]
A = [-skew(Oc),   eye(3),        -skew(Vc), zeros(3), zeros(3,4);
      zeros(3), ddvdt_dv,skew(Rcu*[0;0;g]), ddvdt_dw, zeros(3,4);
      zeros(3), zeros(3),        -skew(Oc),   eye(3), zeros(3,4);
      zeros(3), zeros(3),         zeros(3), ddwdt_dw, zeros(3,4);
        eye(3), zeros(3),         zeros(3), zeros(3), zeros(3,4);
       [0,0,0],  [0,0,0],          [0,0,1],  [0,0,0], [0,0,0,0]];
% A1 is A matrix without integral term
A1 = [-skew(Oc) ,eye(3),-skew(Vc),zeros(3);
    zeros(3),ddvdt_dv,skew(Rcu*[0;0;g]),ddvdt_dw;
    zeros(3),zeros(3),-skew(Oc),eye(3);
    zeros(3),zeros(3),zeros(3),ddwdt_dw;];


% B matrix
% -----system input u = [T(1),n(3)]
B = [   [0;0;0],zeros(3);
     [0;0;-1/m],zeros(3);
        [0;0;0],zeros(3);
        [0;0;0],    J^-1;
        zeros(4,4)];
% B1 is B matrix without integral term
B1 = [[0;0;0],zeros(3);
     [0;0;-1/m],zeros(3);
     [0;0;0],zeros(3);
     [0;0;0],J^-1;];
% C matrix
% -----System output y = [Pe,Le,Oe,xI]
C = [    eye(3),   zeros(3), zeros(3),  zeros(3),zeros(3,4);
       zeros(3),  zeros(3),    eye(3),  zeros(3),zeros(3,4);
       zeros(3),  zeros(3),  zeros(3),    eye(3),zeros(3,4);
     zeros(4,3),zeros(4,3),zeros(4,3),zeros(4,3), eye(4,4)];

% D matrix
D = zeros(13,4);

% system 
% ----- dX = AX + BU
% ----- y  = CX
system = ss(A,B,C,D);

%% LQR Control

% Pmc = 100;
% Vmc = 0.001;
Q = eye(16);
Q(1,1) = 3;Q(2,2)=3;
%Q(1,1)=Pmc; Q(2,2)=Pmc; Q(3,3)=Pmc;
%Q(4,4)=Vmc; Q(5,5)=Vmc; Q(6,6)=Vmc;

% Fmc=0.00001;
R = eye(4);   
%R(1,1) = Fmc;  

% Linear Controller Gain
k = lqr(A, B, Q, R);
k1 = lqr(A1, B1, Q, R); % without integral term

%% Longberg Observer
% observability
E_obs = obsv(A,C);       
E_val = rank(E_obs);         

% acker gain
desired_poles = [-10, -11, -12, -4, -5, -6, -1, -2, -3, -4, -5, -6, -6, -5, -4, -3];
L_acker = (place(A',C', desired_poles))';

% Kalman Filter gain
 QN = 10*eye(4);
 RN = 0.001*eye(13);
 [Kest, L_kalman] = kalman(system,QN, RN);
