
features=[];
featuresS=[];


%Datalar okunuk Dalgac�k D�n���m� uygulanarak alt bantlara ula��ld�
for i=1:100
    
   myfilename= sprintf('Z%d.txt',i);
   filename = fullfile('D:\','A-Z',myfilename);
%    fid = fopen(filename, 'r');
%    Data=fscanf(fid,'%d');
   Data=load(filename,myfilename);
   [c,l]=wavedec(Data, 5,'db2');
   [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
   approx = appcoef(c,l,'db2');
   
   %Her bir alt banda istatistiksel parametreler ve g�� de�eri uygulanarak
   %�zellik ��kar�m� yap�ld�
   features(i,1)=min(cd3);
   features(i,2)=max(cd3);
   features(i,3)=mean(cd3);
   features(i,4)=std(cd3);
   features(i,5)=skewness(cd3);
   features(i,6)=kurtosis(cd3);
   pRMS = rms(cd3)^2;
   pRMSdb= pow2db(pRMS);
   features(i,7)=pRMSdb;
   
   features(i,8)=min(cd4);
   features(i,9)=max(cd4);
   features(i,10)=mean(cd4);
   features(i,11)=std(cd4);
   features(i,12)=skewness(cd4);
   features(i,13)=kurtosis(cd4);
   pRMS = rms(cd4)^2;
   pRMSdb= pow2db(pRMS);
   features(i,14)=pRMSdb;
   
   features(i,15)=min(cd5);
   features(i,16)=max(cd5);
   features(i,17)=mean(cd5);
   features(i,18)=std(cd5);
   features(i,19)=skewness(cd5);
   features(i,20)=kurtosis(cd5);
   pRMS = rms(cd5)^2;
   pRMSdb= pow2db(pRMS);
   features(i,21)=pRMSdb;
   
   features(i,22)=min(approx);
   features(i,23)=max(approx);
   features(i,24)=mean(approx);
   features(i,25)=std(approx);
   features(i,26)=skewness(approx);
   features(i,27)=kurtosis(approx);
   pRMS = rms(approx)^2;
   pRMSdb= pow2db(pRMS);
   features(i,28)=pRMSdb;

   
end

%Yukar�daki i�lemlerin ayn�s� sa�l�kl� veriler i�in de yap�ld�.
for i=1:100
    
   myfilename= sprintf('S%d.txt',i);
   filename = fullfile('D:\','E_S',myfilename);
%    fid = fopen(filename, 'r');
%    Data=fscanf(fid,'%d');
   Data=load(filename,myfilename);
   [c,l]=wavedec(Data, 5,'db2');
   [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
   approx = appcoef(c,l,'db2');
   
   featuresS(i,1)=min(cd3);
   featuresS(i,2)=max(cd3);
   featuresS(i,3)=mean(cd3);
   featuresS(i,4)=std(cd3);
   featuresS(i,5)=skewness(cd3);
   featuresS(i,6)=kurtosis(cd3);
   pRMS = rms(cd3)^2;
   pRMSdb= pow2db(pRMS);
   featuresS(i,7)=pRMSdb;
   
   featuresS(i,8)=min(cd4);
   featuresS(i,9)=max(cd4);
   featuresS(i,10)=mean(cd4);
   featuresS(i,11)=std(cd4);
   featuresS(i,12)=skewness(cd4);
   featuresS(i,13)=kurtosis(cd4);
   pRMS = rms(cd4)^2;
   pRMSdb= pow2db(pRMS);
   featuresS(i,14)=pRMSdb;
   
   featuresS(i,15)=min(cd5);
   featuresS(i,16)=max(cd5);
   featuresS(i,17)=mean(cd5);
   featuresS(i,18)=std(cd5);
   featuresS(i,19)=skewness(cd5);
   featuresS(i,20)=kurtosis(cd5);
   pRMS = rms(cd5)^2;
   pRMSdb= pow2db(pRMS);
   featuresS(i,21)=pRMSdb;
   
   featuresS(i,22)=min(approx);
   featuresS(i,23)=max(approx);
   featuresS(i,24)=mean(approx);
   featuresS(i,25)=std(approx);
   featuresS(i,26)=skewness(approx);
   featuresS(i,27)=kurtosis(approx);
   pRMS = rms(approx)^2;
   pRMSdb= pow2db(pRMS);
   featuresS(i,28)=pRMSdb;

   
end

%Bir hedef vekt�r olu�turuldu ve sa�l�kl� veriler i�in 0 hasta verier i�in
%1 olacak �ekilde veri setine eklendi
hedef1=zeros(100,1);%Sa�l�kl� i�in 0
hedef2=ones(100,1);%Hasta i�in 1
hedef=vertcat(hedef2,hedef1);%hedef vekt�rler birle�tirildi
hedef=transpose(hedef);

%Sa�l�kl� ve hasta veriler �zerinden ��kar�lan �zellik matrisi tek bir
%matris haline getirildi.
veriler=vertcat(features(),featuresS());
veriler=transpose(veriler);

%hedef vekt�r ile t�m verilerin oldu�u matris birle�tirildi. B�yle YSA
%giri�ine sokulan verinin ��k�� de�erinin ne olaca�� hedef vekt�r ile
%kar��la�t�rmas� kolayla�t�r�ld�
veriler=vertcat(veriler,hedef);

%veriler, YSA'n�n daha iyi kendini e�itebilmesi i�in kar��t�r�ld�.
cols = size(veriler,2);
P = randperm(cols);
B = veriler(:,P);


%Normalizasyon i�lemi uyguland�.
for i=1:28
    for j=1:200
       B(i,j)=(B(i,j)-min(B(i,:)))/(max(B(i,:))-min(B(i,:)));
        
    end
end


%Veriler %70 e�itim ve %30 test olarak ayr�ld�.
data_train=B(1:28,1:170);
hedef_train=B(29,1:170);
data_test=B(1:28,171:200);
hedef_test=B(29,171:200);


%YSA i�in a� haz�rland�.
net=newff(minmax(data_train), [34,1], {'tansig','logsig'},'traingd'); 
net.trainParam.perf='mse';
net.trainParam.epochs=2000;
net.trainParam.goal=1e-5;
net=train(net,data_train,hedef_train);

%A�daki ��kt�lar al�nd�.
outputs=net(data_train);

%Tahmin i�lemi yap�ld�.
ypred=sim(net,data_test);

%Confusion(Karma��kl�k) matrisi olu�turuldu.
[c, cm, ind, per]=confusion(hedef_test,ypred);
hata= double(mse(hedef_test,ypred));

%Sistemin Accuracy(Do�rulu�u) hesapland�.
a=cm(1,1);
b=cm(2,2);
accuracy=((a+b)/30)*100;



