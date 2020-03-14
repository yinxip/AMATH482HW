clc;close;clear all
%% build dataset 
train=[];
for str=["band","classical","country"]
    for i=1:2
        [song, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        song=song'/2;
        song=song(1,:)+song(2,:);
        for j=10:10:100 % 15 piece from every music for better results
            five=song(Fs*j:Fs*(j+5));
            fivespec=abs(spectrogram(five));
            fivespec=reshape(fivespec, [1,32769*8]);
            train=[train; fivespec];
        end
    end
end
train=train';
sz = size(train,2)/3; 
%%
[U,S,V] = svd(train,'econ');
feature=20;
music = S*V'; % projection onto principal components
U = U(:,1:feature);
band = music(1:feature,1:sz);
classical = music(1:feature,sz+1:2*sz);
country=music(1:feature, 2*sz+1:3*sz);
    
ma = mean(band,2);
md = mean(classical,2);
mc = mean(country,2);
m = (ma+md+mc)/3;
    
    Sw = 0; % within class variances
    for k=1:sz
        Sw = Sw + (band(:,k)-ma)*(band(:,k)-ma)';
    end
    for k=1:sz
        Sw = Sw + (classical(:,k)-md)*(classical(:,k)-md)';
    end
    for k=1:sz
        Sw = Sw + (country(:,k)-mc)*(country(:,k)-mc)';
    end
    
    Sb = ((ma-m)*(ma-m)'+(md-m)*(md-m)'+(mc-m)*(mc-m)')/3; % between class 
    
    [V2,D] = eig(Sb,Sw); % linear discriminant analysis
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    
    vband = w'*band; 
    vclassical = w'*classical;
    vcountry= w'*country;
%%
% band < threshold < classical < threshold < country
 
    sortband = sort(vband);
    sortclassical = sort(vclassical);
    sortcountry=sort(vcountry);
    
plot(sortband,zeros(20),'ob'); 
hold on
plot(sortclassical,ones(20),'dr');
plot(sortcountry,1/2*ones(20),'k*');
title('Test3: Porjection on w','Fontsize',16)
ylabel('Category','Fontsize',16)
xlabel('Porjection on w','Fontsize',16)

    t1 = length(sortband);
    t2 = 1;
    while sortband(t1)>sortclassical(t2)
        t1 = t1-1;
        t2 = t2+1;
    end
    threshold1 = (sortband(t1)+sortclassical(t2))/2;
    
    t3=length(sortclassical);
    t4=1;
    while sortclassical(t3)>sortcountry(t4);
        t3=t3-1;
        t4=t4+1;
    end
    threshold2 = (sortclassical(t3)+sortcountry(t4))/2;

%%
%test1
test=[];
for i=3
    for str=["band","classical","country"]
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
figure(3)
bar(pval)
xlabel('Test Data')
ylabel('Projection')
title('Test3: LDA')
hold on;
yline(threshold1,'-','threshold of Band and Classical','Linewidth',5);
hold on;
yline(threshold2,'-','threshold of Classical and Country','Linewidth',5);
hold off;

p=pval;
for i=1:33
    if p(i)<threshold1
        p(i)=-1;%band
    elseif  p(i)>threshold2
        p(i)=1;%country
    else threshold1<p(i)<threshold2
        p(i)=0;%classical
    end
end

truep=zeros(1,33);
truep(1:11)=-1;
truep(23:33)=1;

res=p-truep;
k=0;
for i=1:33
    if res(i)==0
        k=k+1;
    end
end

suc3=k/33

