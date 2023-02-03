winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15
f = 550e12;
lambda = c_c/f;

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0;
% epi{1}(20:30,10:20)= c_eps_0*11.3; %the values in the brackets represent (xstarting:xstopping,ystarting:ystopping).The multiplier on the RHS is of a refractive index of the material for letting light pass 
% epi{1}(150:200,10:90)= c_eps_0*1.3;
% epi{1}(80:95,110:120)= c_eps_0*2;

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

bc{1}.NumS = 2;
for ii=1:bc{1}.NumS
    bc{1}.s(ii).xpos = 20*ii; %nx{1}/(4) + 1;
    bc{1}.s(ii).type = 'ss';
    bc{1}.s(ii).fct = @PlaneWaveBC;
end

% mag = -1/c_eta_0;
mag = 5; %represents the magnitude of the wave
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,0,sty,'s'};
% bc{1}.s(3).paras = {mag,phi,omega,betap,t0,st,s,25,sty,'s'};
% bc{1}.s(4).paras = {mag,phi,omega,betap,t0,st,s,50,sty,'s'};

Plot.y0 = round(y0/dx);

%The bc structure represents the boundry condition. m: magnetic wall with h=0 and p is periodic  
bc{1}.xm.type = 'a';
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






