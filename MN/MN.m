clear

V_in = 0;

R1 = 1;
Cap = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
alpha = 100;
R4 = 0.1;
Ro = 1000;

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
Go = 1/Ro;

% Unknowns: X = [I_in, V1, V2, I_L, I3, I, V4, Vo];
X = [];

G = zeros(8);
G(1,:) = [1 G1 -G1 0 0 0 0 0];
G(2,:) = [0 -G1 (G1+G2) 1 0 0 0 0];
G(3,:) = [0 0 0 -1 1 0 0 0];
G(4,:) = [0 0 0 0 0 -1 G4 -G4];
G(5,:) = [0 0 0 0 0 0 -G4 (G4+Go)];
G(6,:) = [0 1 0 0 0 0 0 0];
G(7,:) = [0 0 0 0 -alpha 0 1 0];
G(8,:) = [0 0 1 0 -R3 0 0 0];

C = zeros(8);
C(1,:) = [0 Cap -Cap 0 0 0 0 0];
C(2,:) = [0 -Cap Cap 0 0 0 0 0];
C(8,:) = [0 0 0 -L 0 0 0 0];

F = [0 0 0 0 0 V_in 0 0];

%
% In time domain, C dX/dt + GX = F. In the frequency domain, (G + jwC)X =
% F. For DC analysis, we can set w = 0. To solve for X:
% X = F / (G + jwC)
%

% DC Sweep

index = 1;

for V_in = -10:10
    
    F = [0 0 0 0 0 V_in 0 0];
    X = G\F';
    
    Vo(index) = X(8);
    V3(index) = X(5)*R3; %X(5) contains I3
    
    index = index + 1;
    
end

V_in = linspace(-10,10,21);

figure(1)
plot(V_in,Vo)
hold on
plot(V_in,V3)
xlabel('Input voltage')
ylabel('Voltage at nodes')
legend('Vo','V3')
hold off

% AC Sweep

% For the AC sweep, let V_in = 1V
V_in = 1;

Vo = [];
V3 = [];

index = 1;

for f = 0:100
    
    w = 2*pi*f;
    X = (G + 1i*w*C)\F';
    
    Vo(index) = real(X(8));
    V3(index) = real(X(5))*R3; %X(5) contains I3
    
    index = index + 1;
    
end

f = linspace(0,100,101);

figure(2)
plot(f,Vo)
hold on
plot(f,V3)
xlabel('Frequency')
ylabel('Absolute voltage at nodes')
legend('Vo','V3')
hold off

figure(3)
plot(f,20*log10(Vo/V_in))
xlabel('Frequency')
ylabel('Gain (dB)')

% Variable Capacitance

w = pi;

for index = 1:100

    Cap = 0.05*randn + 0.25;
    
    cPerturb(index) = Cap;
    
    C(1,:) = [0 Cap -Cap 0 0 0 0 0];
    C(2,:) = [0 -Cap Cap 0 0 0 0 0];
    C(8,:) = [0 0 0 -L 0 0 0 0];
    
    X = (G + 1i*w*C)\F';
    
    gain(index) = 20*log10(abs(X(8))/V_in);
    
    index = index + 1;

end

figure(4)
hist(cPerturb)
title('Distribution of Capacitance')
xlabel('C')

figure(5)
hist(gain)
title('Spread of Gain')
xlabel('20log_{10}|V_o/V_{in}|')
