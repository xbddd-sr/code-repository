function [ypredict,firstmin_data,firstmin_time,secondmax_data,secondmax_time,thirdmin_data,thirdmin_time] =jisuan1(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection)
% 输出糖尿病患者接受治疗的神经网络模型输出
%%


%加载网络
load('net0204h.mat');
load('net0608h.mat');
load('net100125h.mat');
load('net150175h.mat');
load('net200225h.mat');
load('net250275h.mat');
load('net300350h.mat');
load('net400500h.mat');
load('net67800h.mat');
load('netfirstmin.mat');
load('netsecondmax.mat');
load('netthirdmin.mat');


%通过网络得到数据
data0204h = sim(net0204h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data0204h(data0204h<0)=0;   %  0.2   0.4

data0608h = sim(net0608h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data0608h(data0608h<0)=0;   %  0.6   0.8

data100125h = sim(net100125h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data100125h(data100125h<0)=0;   %  1  1.25

data150175h = sim(net150175h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data150175h(data150175h<0)=0;   %  1.5  1.75

data200225h = sim(net200225h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data200225h(data200225h<0)=0;   %  2.0  2.25

data250275h = sim(net250275h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data250275h(data250275h<0)=0;   %  2.5   2.75

data300350h = sim(net300350h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data300350h(data300350h<0)=0;   %  3.0   3.5

data400500h = sim(net400500h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data400500h(data400500h<0)=0;   %  4.0   5.0

data67800h = sim(net67800h,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
data67800h(data67800h<0)=0;   %  6.0 7.0 8.0

datafirstmin = sim(netfirstmin,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
datafirstmin(datafirstmin<0)=0;   %  第一个极小值

datasecondmax = sim(netsecondmax,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
datasecondmax(datasecondmax<0)=0;   %  第二个极大值

datathirdmin = sim(netthirdmin,[InitialGul;InjectCycle;SwitchTime;InitialInjection;...
         BigCycleInjection;SmallCycleInjection]); 
datathirdmin(datathirdmin<0)=0;   %  第二个极大值

%将数据按时间顺序进行排列
tpredict = [0, 0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
        3.5, 4.0, 5.0, 6.0, 7.0, 8.0];
    
ypredict = [InitialGul, data0204h(1), data0204h(2), data0608h(1), data0608h(2),...
        data100125h(1), data100125h(2), data150175h(1),data150175h(2),...
        data200225h(1), data200225h(2), data250275h(1), data250275h(2),...
        data300350h(1), data300350h(2), data400500h(1), data400500h(2),...
        data67800h(1), data67800h(2), data67800h(3)];



% 最大值/最小值及时间点预测：
firstmin_data = datafirstmin(1);
firstmin_time = datafirstmin(2)/100;
secondmax_data = datasecondmax(1);
secondmax_time = (datasecondmax(2) + 124)/100;
thirdmin_data = datathirdmin(1);
thirdmin_time = (datathirdmin(2) + 199)/100;


end