
features=[];
featuresS=[];


%Datalar okunuk Dalgacýk Dönüþümü uygulanarak alt bantlara ulaþýldý
for i=1:100
    
   myfilename= sprintf('Z%d.txt',i);
   filename = fullfile('D:\','A-Z',myfilename);
%    fid = fopen(filename, 'r');
%    Data=fscanf(fid,'%d');
   Data=load(filename,myfilename);
   [c,l]=wavedec(Data, 5,'db2');
   [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
   approx = appcoef(c,l,'db2');
   
   %Her bir alt banda istatistiksel parametreler ve güç deðeri uygulanarak
   %özellik çýkarýmý yapýldý
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

%Yukarýdaki iþlemlerin aynýsý saðlýklý veriler için de yapýldý.
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

%Bir hedef vektör oluþturuldu ve saðlýklý veriler için 0 hasta verier için
%1 olacak þekilde veri setine eklendi
hedef1=zeros(100,1);%Saðlýklý için 0
hedef2=ones(100,1);%Hasta için 1
hedef=vertcat(hedef2,hedef1);%hedef vektörler birleþtirildi
hedef=transpose(hedef);

%Saðlýklý ve hasta veriler üzerinden çýkarýlan özellik matrisi tek bir
%matris haline getirildi.
veriler=vertcat(features(),featuresS());
veriler=transpose(veriler);

%hedef vektör ile tüm verilerin olduðu matris birleþtirildi. Böyle YSA
%giriþine sokulan verinin çýkýþ deðerinin ne olacaðý hedef vektör ile
%karþýlaþtýrmasý kolaylaþtýrýldý
veriler=vertcat(veriler,hedef);

%veriler, YSA'nýn daha iyi kendini eðitebilmesi için karýþtýrýldý.
cols = size(veriler,2);
P = randperm(cols);
B = veriler(:,P);


%Normalizasyon iþlemi uygulandý.
for i=1:28
    for j=1:200
       B(i,j)=(B(i,j)-min(B(i,:)))/(max(B(i,:))-min(B(i,:)));
        
    end
end


%Veriler %70 eðitim ve %30 test olarak ayrýldý.
data_train=B(1:28,1:170);
hedef_train=B(29,1:170);
data_test=B(1:28,171:200);
hedef_test=B(29,171:200);


%YSA için að hazýrlandý.
net=newff(minmax(data_train), [34,1], {'tansig','logsig'},'traingd'); 
net.trainParam.perf='mse';
net.trainParam.epochs=2000;
net.trainParam.goal=1e-5;
net=train(net,data_train,hedef_train);

%Aðdaki çýktýlar alýndý.
outputs=net(data_train);

%Tahmin iþlemi yapýldý.
ypred=sim(net,data_test);

%Confusion(Karmaþýklýk) matrisi oluþturuldu.
[c, cm, ind, per]=confusion(hedef_test,ypred);
hata= double(mse(hedef_test,ypred));

%Sistemin Accuracy(Doðruluðu) hesaplandý.
a=cm(1,1);
b=cm(2,2);
accuracy=((a+b)/30)*100;



