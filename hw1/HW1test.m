% load data
clear; close all; clc;
load Testdata

% define axes on both spatial and frequency domain
L = 15; % spatial domain
n = 64; % Fourier modes - frequency domain
x2 = linspace(-L, L, n + 1); % discretizing the range of x
% create the axis
x = x2(1 : n);
y = x; 
z = x;
% rescale frequencies by 2*pi/L since the FFT assumes 2*pi periodic signals.
k = (2 * pi / (2 * L)) * [0 : (n / 2 - 1) -n / 2: -1]; 
% for plotting or the order is going to mess up
ks = fftshift(k);
% create coordinates defined by x,y,z - for spatial domain
[X, Y, Z] = meshgrid(x, y, z); 
% create coordinates defined by x,y,z - for frequency domain
[Kx, Ky, Kz] = meshgrid(ks, ks, ks); 

%% 1.Averaging the nosiy data
ave = 0;

for j = 1:20
    % reshape each time ultrasound into 3D spatial domain
    Un(:,:,:) = reshape(Undata(j,:),n,n,n);
    
    % Below the codes give an overview of the noisy data. Uncomment them and
    % plot the noisy data if you want.
    
    % close all, isosurface(X, Y, Z, abs(Un), 0.4) 
    % axis([-20 20 -20 20 -20 20]), grid on, drawnow 
    % pause(1) 
    
    % apply FFT on each time
    Unt = fftn(Un);
    ave = ave + Unt;
end

% get ride of the imaginary numbers since we consider the spatial domain
ave = abs(fftshift(ave)) ./ 20;

figure(1)
% plot the averaged data 
isosurface(Kx,Ky,Kz, ave ./ max(ave), 0.999)
axis tight % zoom into the area that contains data
xlabel('Frequency on x-axis', 'FontSize', 20)
ylabel('Frequency on y-axis', 'FontSize', 20)
zlabel('Frequency on z-axis', 'FontSize', 20)
title('Plot of the averaged data in frequency domain', 'FontSize', 20)
legend('Frequency', 'FontSize', 20)
grid on
drawnow

% find the max value of average and return the index of that position
[C,I] = max(ave(:));
center = [Kx(I), Ky(I), Kz(I)];
disp('The center frequency in frequency domain is at:')
center

%% 2. Guassian Filter
tau = 0.7;

g = exp(-tau * ((Kx - center(1)).^2 + (Ky - center(2)).^2 + (Kz - center(3)).^2));

g = fftshift(g);

Xc = zeros(1,20);
Yc = zeros(1,20);
Zc = zeros(1,20);

for j = 1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Unt = fftn(Un);
    Unft = g .* Unt;
    Unf = ifftn(Unft); 
    Unf = abs(Unf); % imaginary
    [C1,I1] = max(Unf(:));
    Xc(j) = X(I1);
    Yc(j) = Y(I1);
    Zc(j) = Z(I1);
end

disp('The final position in spatial domain is:')
[Xc(20), Yc(20), Zc(20)]

figure(2)
plot3(Xc,Yc,Zc,'-o','Linewidth', 1.6)
hold on
% time1 location
plot3(Xc(1), Yc(1), Zc(1), 'r*', 'Linewidth', 3)
% time20 location
plot3(Xc(20), Yc(20), Zc(20), 'gx', 'Linewidth', 3)
axis([-20 20 -20 20 -20 20]) 
xlabel('x-axis', 'FontSize', 20)
ylabel('y-axis', 'FontSize', 20)
zlabel('z-axis', 'FontSize', 20)
title('Trajectory of the marble in spatial domain', 'FontSize', 20)
legend('Trajectory of the marble in 20 times', 'The location of the marble at time 1', 'The location of the marble at time 20', 'FontSize', 17)
axis tight % zoom in data
grid on
drawnow