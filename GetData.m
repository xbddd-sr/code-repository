numTimeStepsTrain = floor(0.9*266112);
%%
XdataTest0204 = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest0204 = type(1:2,numTimeStepsTrain+1:end);
y0204h = net0204h(XdataTest0204);

%%
XdataTest0608 = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest0608 = type(3:4,numTimeStepsTrain+1:end);
y0608h = net0608h(XdataTest0608);

%%
XdataTest100125h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest100125h = type(5:6,numTimeStepsTrain+1:end);
y100125h = net100125h(XdataTest100125h);

%%
XdataTest150175h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest150175h = type(7:8,numTimeStepsTrain+1:end);
y150175h = net150175h(XdataTest150175h);



%%
XdataTest200225h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest200225h = type(9:10,numTimeStepsTrain+1:end);
y200225h = net200225h(XdataTest200225h);

%%
XdataTest250275h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest250275h = type(11:12,numTimeStepsTrain+1:end);
y250275h = net250275h(XdataTest250275h);

%%
XdataTest300350h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest300350h = type(13:14,numTimeStepsTrain+1:end);
y300350h = net300350h(XdataTest300350h);

%%
XdataTest400500h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest400500h = type(15:16,numTimeStepsTrain+1:end);
y400500h = net400500h(XdataTest400500h);

%%
XdataTest67800h = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTest67800h = type(17:19,numTimeStepsTrain+1:end);
y67800h = net67800h(XdataTest67800h);

%%
XdataTestfirstmin = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTestfirstmin = type(20:21,numTimeStepsTrain+1:end);
yfirstmin = netfirstmin(XdataTestfirstmin);

%%
XdataTestsecondmax = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTestsecondmax = type(22:23,numTimeStepsTrain+1:end);
ysecondmax = netsecondmax(XdataTestsecondmax);

%%
XdataTestthirdmin = Parameters_Daluan(:,numTimeStepsTrain+1:end);
YdataTestthirdmin = type(24:25,numTimeStepsTrain+1:end);
ythirdmin = netthirdmin(XdataTestthirdmin);


%%

i = 2;

timefit = [0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
           3.5, 4.0, 5.0, 6.0, 7.0, 8.0];
       
% glupredict_single = [y0204h(1,i),y0204h(2,i),y0608h(1,i),y0608h(2,i),y100125h(1,i),y100125h(2,i),...
%               y150175h(1,i),y150175h(2,i),y200225h(1,i),y200225h(2,i),y250275h(1,i),y250275h(2,i),...
%               y300350h(1,i),y300350h(2,i),y400500h(1,i),y400500h(2,i),y67800h(1,i),y67800h(2,i),y67800h(3,i)...
%               yfirstmin(1,i), ysecondmax(1,i), ythirdmin(1,i)];
          
glupredict = [y0204h; y0608h; y100125h; y150175h; y200225h; y250275h; y300350h; y400500h; y67800h];
          
gluactual = type(1:19,numTimeStepsTrain+1:end);

xtrainpara = Parameters_Daluan(:,numTimeStepsTrain+1:end);
