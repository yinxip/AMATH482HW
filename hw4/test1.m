clear all; close all; clc;

%% train dataset
train=[];
for str=["pop","kpop","Beethoven"]
    for i=1:2
        [y, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        y=y'/2;
        y=y(1,:)+y(2,:); % convert to one sound link
        for j=10:5:100
            five=y(Fs*j:Fs*(j+5));
            five = spectrogram(five);
            fivespec=abs(five);
            fivespec=reshape(fivespec, [1,32769*8]);
            train=[train; fivespec];
        end
    end
end
train=train';
sz = size(train,2)/3; 
   
%% svd and lda
[U,S,V] = svd(train,'econ');
feature=20;
music = S*V'; % projection onto principal components
U = U(:,1:feature);
pop = music(1:feature,1:sz);
kpop = music(1:feature,sz+1:2*sz);
Beethoven=music(1:feature, 2*sz+1:3*sz);

ma = mean(pop,2);
md = mean(kpop,2);
mc = mean(Beethoven,2);
m = (ma+md+mc)/3;
    
Sw = 0; % within class variances
for k=1:sz
	Sw = Sw + (pop(:,k)-ma)*(pop(:,k)-ma)';
end
for k=1:sz
	Sw = Sw + (kpop(:,k)-md)*(kpop(:,k)-md)';
end
for k=1:sz
	Sw = Sw + (Beethoven(:,k)-mc)*(Beethoven(:,k)-mc)';
end
    
Sb = ((ma-m)*(ma-m)'+(md-m)*(md-m)'+(mc-m)*(mc-m)')/3; % between class 
    
[V2,D] = eig(Sb,Sw); % linear discriminant analysis
[~,ind] = max(abs(diag(D)));
w = V2(:,ind); w = w/norm(w,2);
    
vpop = w'*pop; 
vkpop = w'*kpop;
vBeethoven= w'*Beethoven;

%% find threshold

% vpop < threshold1 < Beethoven < threshold2 < vkpop
 
sortpop = sort(vpop);
sortkpop = sort(vkpop);
sortBeethoven=sort(vBeethoven);

plot(sortpop,zeros(38),'ob'); 
hold on
plot(sortkpop,ones(38),'dr');
plot(sortBeethoven,1/2*ones(38),'k*');
% xline(threshold1,'-','threshold of Beethoven and Jackson','Linewidth',5);
% xline(threshold2,'-','threshold of Beethoven and Jackson','Linewidth',5);
title('Test1: Porjection on w','Fontsize',16)
ylabel('Category','Fontsize',16)
xlabel('Porjection on w','Fontsize',16)


t1 = length(sortpop);
t2 = 1;
while sortpop(t1)>sortBeethoven(t2)
	t1 = t1-1;
	t2 = t2+1;
end
threshold1 = (sortpop(t1)+sortBeethoven(t2))/2;
   
t3=length(sortBeethoven);
t4=1;
while sortBeethoven(t3)>sortkpop(t4)
	t3=t3-1;
	t4=t4+1;
end
threshold2 = (sortBeethoven(t3)+sortkpop(t4))/2;

%% test data
test=[];
for i=3
    for str=["pop","kpop","Beethoven"]
        [y, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        y=y'/2;
        y=y(1,:)+y(2,:);
        for j=50:10:150 % 11 piece from every music 
            five=y(Fs*j:Fs*(j+5));
            five = spectrogram(five);
            fivespec=abs(five);
            fivespec=reshape(fivespec, [1,32769*8]);
            test=[test; fivespec];
        end
    end
end


test=test.';
TestNum=size(test,2);
TestMat = U'*test;  % PCA projection
pval = w'*TestMat;  % LDA projection
figure(1)
bar(pval)
xlabel('Test Data')
ylabel('Projection')
title('Test1: LDA')
hold on;
yline(threshold1,'-','threshold of Beethoven and Jackson','Linewidth',5);
hold on;
yline(threshold2,'-','threshold of EXO and Beethoven','Linewidth',5);
hold off;

p=pval;
for i=1:33
    if p(i)<threshold1
        p(i)=-1;%pop
    elseif  p(i)>threshold2
        p(i)=1;%kpop
    else threshold1 < p(i) < threshold2
        p(i)=0;%Beethoven
    end
end

true=zeros(1,33);
true(23:33)=1;
true(1:11)=-1;

res=p-true;
c=0;
for i=1:33
    if res(i)==0
        c=c+1;
    end
end

suc1=c/33
