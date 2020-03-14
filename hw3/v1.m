% first video
% load data
clear; close all; clc;

load('cam1_1.mat') 
load('cam2_1.mat') 
load('cam3_1.mat') 

% play the videos 
% implay(vidFrames1_1)
% implay(vidFrames2_1)
% implay(vidFrames3_1)

v11 = vidFrames1_1;
v21 = vidFrames2_1;
v31 = vidFrames3_1;

numFrames11 = size(v11,4); 
numFrames21 = size(v21,4); 
numFrames31 = size(v31,4); 


for i = 1:numFrames11
   mov11(i).cdata = v11(:,:,:,i); 
   mov11(i).colormap = [];
end

for i = 1:numFrames21
   mov21(i).cdata = v21(:,:,:,i); 
   mov21(i).colormap = [];
end

for i = 1:numFrames31
   mov31(i).cdata = v31(:,:,:,i); 
   mov31(i).colormap = [];
end


X1 = [];
Y1 = [];

X2 = [];
Y2 = [];

X3 = [];
Y3 = [];

%%
width = 50;

sh = zeros(480,640);
sh(300 - 2.6*width:1:300+2.6*width, 350-width:1:350+width) = 1;

for i = 1:numFrames11
    data = frame2im(mov11(i));
    data = rgb2gray(data);
    
    data2 = double(data);
    dataf = sh .* data2;
    
    pink = dataf > 240;
    Index = find(pink);
    [y, x] = ind2sub(size(pink), Index);
    X1 = [X1, mean(x)];
    Y1 = [Y1, mean(y)];
end

sh = zeros(480,640);
sh(250 - 1.7*width:1:250+1.7*width, 290-1.3*width:1:290+1.3*width) = 1;

for i = 1:numFrames21
    data = frame2im(mov21(i));
    data = rgb2gray(data);
    
    data2 = double(data);
    dataf = sh .* data2;
    
    pink = dataf > 240;
    Index = find(pink);
    [y, x] = ind2sub(size(pink), Index);
    X2 = [X2, mean(x)];
    Y2 = [Y2, mean(y)];
end

sh = zeros(480,640);
sh(250 - width:1:250+2*width, 360-2.5*width:1:360+2.5*width) = 1;

for i = 1:numFrames31
    data = frame2im(mov31(i));
    data = rgb2gray(data);
    
    data2 = double(data);
    dataf = sh .* data2;
    
    pink = dataf > 240;
    Index = find(pink);
    [y, x] = ind2sub(size(pink), Index);
    X3 = [X3, mean(x)];
    Y3 = [Y3, mean(y)];
end

%%
[Min, I] = min(Y1(1:50));
X1 = X1(I:end);
Y1 = Y1(I:end);

[Min, I] = min(Y2(1:50));
X2 = X2(I:end);
Y2 = Y2(I:end);


[Min, I] = min(X3(1:50));
X3 = X3(I:end);
Y3 = Y3(I:end);

length = [length(X1), length(X2), length(X3)];

minimal = min(length);

X1 = X1(1:minimal);
X2 = X2(1:minimal);
X3 = X3(1:minimal);
Y1 = Y1(1:minimal);
Y2 = Y2(1:minimal);
Y3 = Y3(1:minimal);



X = [X1; Y1; X2; Y2; X3; Y3];

[m, n] = size(X);
mn = mean(X, 2);

X = X - repmat(mn,1,n);


%%
[u,s,v] = svd(((X./sqrt(n-1))));

lambda = diag(s).^2;

Y = u' * X; % principal components projection

s = diag(s);

figure(1)
subplot(2,1,1)
plot(1:216,X(2,:), 1:216,X(4,:), 1:216,X(5,:),'LineWidth',2)
hold on
plot(1:216, Y(1,:), '--k','LineWidth',1.5)
axis([0 216 -120 120 ])
title('Displacement of the spring(Vertically) for test 1','Fontsize',16)
ylabel('Displacement','Fontsize',16)
xlabel('Frame','Fontsize',16)
legend('Cam1', 'Cam2', 'Cam3','First Principal','Fontsize',5)


subplot(2,1,2)
plot(1:216,X(1,:), 1:216,X(3,:), 1:216,X(6,:))
axis([0 216 -120 120 ])
title('Displacement of the spring(Horizentally) for test 1','Fontsize',16)
ylabel('Displacement','Fontsize',16)
xlabel('Frame','Fontsize',16)
legend('Cam1', 'Cam2', 'Cam3','Fontsize',10)

figure(2)
plot(1:6,lambda/sum(lambda))
title('Energy of Test1','Fontsize',16)
ylabel('Energy','Fontsize',16)
xlabel('Diagonal','Fontsize',16)

