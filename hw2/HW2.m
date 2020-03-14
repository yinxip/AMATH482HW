% Part1
clear; close all; clc;
load handel

v = y';
% plot((1:length(v))/Fs,v); 
% xlabel('Time [sec]'); 
% ylabel('Amplitude'); 
% title('Signal of Interest, v(n)');

% play the music
p8 = audioplayer(v,Fs); 
% playblocking(p8);

L=length(y)/Fs; % length of the music
n=length(v); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(2*pi/L) * [0:(n-1)/2 -(n-1)/2:-1]; 
ks=fftshift(k);

%% produce spectrograms of the piece of work.
tslide=0:0.1:L;
Vgt_spec = zeros(length(tslide),n);
Vmht_spec = zeros(length(tslide),n);
Vshnt_spec = zeros(length(tslide),n);

% Gaussian
a_vec = [0.1 10 100 1000];
for jj = 1:length(a_vec)
    a = a_vec(jj);
    
    for j=1:length(tslide) 
        
	g=exp(-a*(t-tslide(j)).^2);     
	Vg=g.*v;     
	Vgt=fft(Vg);     
	Vgt_spec(j,:) = fftshift(abs(Vgt)); % We don't want to scale it

    end
    
    subplot(2,2,jj)
    pcolor(tslide, ks/(2*pi), Vgt_spec.') 
    shading interp   
    xlabel('Time(second)','Fontsize',16)
    ylabel('Frequency(Hz)','Fontsize',16)
    title(['Gaussian Filter with a =', num2str(a)],'Fontsize',16)     
    colormap(hot)
end


a = 100;
for j=1:length(tslide) 
	% Gaussian
	g=exp(-a*(t-tslide(j)).^2);     
	Vg=g.*v;     
	Vgt=fft(Vg);     
	Vgt_spec(j,:) = fftshift(abs(Vgt)); % We don't want to scale it
	% hat
    sigma = 0.05;
    constant = 2 / (sqrt(3*sigma)* (pi^(1/4)));
	mh = constant .* (1-((t-tslide(j))./sigma).^2) .* exp(-(((t-tslide(j)).^2) ./ (2 * sigma.^2)));    
	Vmh = mh.*v;     
	Vmht = fft(Vmh); 
	Vmht_spec(j,:) = fftshift(abs(Vmht)); % We don't want to scale it
	% Shannon
	shn = abs(t - tslide(j)) <= 0.05/2;
	Vshn = shn .* v;
	Vshnt = fft(Vshn); 
	Vshnt_spec(j,:) = fftshift(abs(Vshnt)); % We don't want to scale it
end


%% oversample and undersample
tslideover=0 : 0.01 : L;
over = zeros(length(tslideover),n);
for j = 1:length(tslideover) 
    filterover = exp(-a*(t-tslideover(j)).^2);
    vfo = filterover .* v;
    
    vfto = fft(vfo);
    over(j,:) = fftshift(abs(vfto));    
end


tslideunder=0 : 1 : L;
under = zeros(length(tslideunder),n);
for j = 1:length(tslideunder)
	filterunder = exp(-a*(t-tslideunder(j)).^2);
    vfu = filterunder .* v;
    
    vftu = fft(vfu);
    under(j,:) = fftshift(abs(vftu));
end


%% Figures
figure(1)
pcolor(tslide, ks/(2*pi), Vgt_spec.') 
shading interp   
xlabel('Time(second)','Fontsize',16)
ylabel('Frequency(Hz)','Fontsize',16)
title('Gaussian Filter','Fontsize',16)     
colormap(hot)
colorbar

figure(2)
pcolor(tslide, ks/(2*pi), Vmht_spec.') 
shading interp   
xlabel('Time(second)','Fontsize',16)
ylabel('Frequency(Hz)','Fontsize',16)
title('Mexican Hat Filter','Fontsize',16)     
colormap(hot)
colorbar

figure(3)
pcolor(tslide, ks/(2*pi), Vshnt_spec.') 
shading interp   
xlabel('Time(second)','Fontsize',16)
ylabel('Frequency(Hz)','Fontsize',16)
title('Shannon Filter','Fontsize',16)    
colormap(hot)
colorbar

figure(4)
subplot(1,2,1)
pcolor(tslideover, ks/(2*pi), over.') 
shading interp   
xlabel('Time(second)','Fontsize',16)
ylabel('Frequency(Hz)','Fontsize',16)
title('Oversampling','Fontsize',16)   
colormap(hot)
colorbar

subplot(1,2,2)
pcolor(tslideunder, ks/(2*pi), under.') 
shading interp   
xlabel('Time(second)','Fontsize',16)
ylabel('Frequency(Hz)','Fontsize',16)
title('Undersampling','Fontsize',16)    
colormap(hot)
colorbar


