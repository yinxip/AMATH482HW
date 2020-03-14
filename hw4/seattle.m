clc;close; clear all
%% build dataset 
train=[];
for str=["Soundgarden","Alice","Pearl"]
    for i=1:2
        [song, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        song=song'/2;
        song=song(1,:)+song(2,:);
        for j=10:10:140 % 14 piece from every music for better results
            five=song(Fs*j:Fs*(j+5));
            fivespec=abs(spectrogram(five));
            fivespec=reshape(fivespec, [1,32769*8]);
            train=[train; fivespec];
        end
    end
end
train=train';
sz = size(train,2)/3; 
    
[U,S,V] = svd(train,'econ');
feature=20;
music = S*V'; % projection onto principal components
U = U(:,1:feature);
soundgarden = music(1:feature,1:sz);
alice = music(1:feature,sz+1:2*sz);
pearl=music(1:feature, 2*sz+1:3*sz);
    
ma = mean(soundgarden,2);
md = mean(alice,2);
mc = mean(pearl,2);
m = (ma+md+mc)/3;
    
    Sw = 0; % within class variances
    for k=1:sz
        Sw = Sw + (soundgarden(:,k)-ma)*(soundgarden(:,k)-ma)';
    end
    for k=1:sz
        Sw = Sw + (alice(:,k)-md)*(alice(:,k)-md)';
    end
    for k=1:sz
        Sw = Sw + (pearl(:,k)-mc)*(pearl(:,k)-mc)';
    end
    
    Sb = ((ma-m)*(ma-m)'+(md-m)*(md-m)'+(mc-m)*(mc-m)')/3; % between class 
    
    [V2,D] = eig(Sb,Sw); % linear discriminant analysis
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    
    vsoundgarden = w'*soundgarden; 
    valice = w'*alice;
    vpearl= w'*pearl;

% pearl < threshold < soundgarden < threshold < alice
 
    sortsoundgarden = sort(vsoundgarden);
    sortalice = sort(valice);
    sortpearl=sort(vpearl);
    
plot(sortsoundgarden,zeros(28),'ob'); 
hold on
plot(sortalice,ones(28),'dr');
plot(sortpearl,1/2*ones(28),'k*');
title('Test2: Porjection on w','Fontsize',16)
ylabel('Category','Fontsize',16)
xlabel('Porjection on w','Fontsize',16)

    t1 = length(sortpearl);
    t2 = 1;
    while sortpearl(t1)>sortsoundgarden(t2)
        t1 = t1-1;
        t2 = t2+1;
    end
    threshold1 = (sortpearl(t1)+sortsoundgarden(t2))/2;
    
    t3=length(sortsoundgarden);
    t4=1;
    while sortsoundgarden(t3)>sortalice(t4);
        t3=t3-1;
        t4=t4+1;
    end
    threshold2 = (sortsoundgarden(t3)+sortalice(t4))/2;


%test1
test=[];
for i=3
    for str=["Soundgarden","Alice","Pearl"]
        [song, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        song=song'/2;
        song=song(1,:)+song(2,:);
        for j=20:10:120 % 11 piece from every music 
            five=song(Fs*j:Fs*(j+5));
            fivespec=abs(spectrogram(five));
            fivespec=reshape(fivespec, [1,32769*8]);
            test=[test; fivespec];
        end
    end
end

test=test.';
TestNum=size(test,2);
TestMat = U'*test;  % PCA projection
pval = w'*TestMat;  % LDA projection
figure(2)

bar(pval)
xlabel('Test Data')
ylabel('Projection')
title('Test2: LDA')
hold on;
yline(threshold1,'-','threshold of Pearl and Soundgarden','Linewidth',5);
hold on;
yline(threshold2,'-','threshold of Soundgarden and Alice','Linewidth',5);
hold off;

p=pval;
for i=1:33
    if p(i)<threshold1
        p(i)=-1;%pearl
    elseif  p(i)>threshold2
        p(i)=1;%alice
    else threshold1<p(i)<threshold2
        p(i)=0;%soundgarden
    end
end

truep=zeros(1,33);
truep(12:22)=1;
truep(23:33)=-1;

res=p-truep;
k=0;
for i=1:33
    if res(i)==0
        k=k+1;
    end
end

suc2=k/33;

