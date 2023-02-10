set(0,'DefaultFigureWindowStyle','docked')
%dimensions and variables
Lx = 1; %Rectangle parameters
Ly = 1;
Nx = 100; %# of intervals
Ny = 100;
nx = Nx+1; %# of grid points
ny = Ny+1;

%loop variables
ni = 10000;
eps = 1.e-6;
dx = Lx/Nx; %grid size
dy = Ly/Ny;


%gridpoint setup:
i_x = 2:nx-1;
i_y = 2:ny-1;

x = (0:Nx)*dx;
y = (0:Ny)*dy;

%boundry conditions and setup V
V = zeros(nx,ny);

V(:,1) = 0; %bottom
V(1,:) = 1; %left
V(:,ny) = 0; %4*x.*(1-x);%top
V(nx,:) = 1; %right

V_prev = V;
error = 2*eps;
numloop = 0;

while (error > eps)
    numloop = numloop+1;

    V(i_x,i_y) = 0.25*(V(i_x+1,i_y) + V(i_x-1,i_y) + V(i_x,i_y+1) + V(i_x,i_y-1));

    error = max(abs(V(:)-V_prev(:)));
%     if mod(numloop,50) == 0
%         surf(V')
%         pause(0.05)
%     end
    V_prev = V;
end
surf(V')

fprintf("\n numloop = %g \n",numloop);
[Ex,Ey] = gradient(V);

figure
quiver(-Ey',-Ex',1)