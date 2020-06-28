function [tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul)
% 输出正常人和糖尿病无治疗患者的血糖变化情况

sbioloadproject('insulindemo');  % 加载模型
warnSettings = warning('off', 'SimBiology:DimAnalysisNotDone_MatlabFcn_Dimensionless');


mealDose1 = sbioselect(m1, 'Name', 'Single Meal');
configset = getconfigset(m1,'active');  %这是一个配置项，结构体参数配置
configset.StopTime = 8;
set(configset.SolverOptions, 'OutputTimes', [0:0.01:8]);%设置采样率

normalMealSim = sbiosimulate(m1, configset, [], mealDose1);  %模拟正常人

diabeticVar = sbioselect(m1, 'Name', 'Type 2 diabetic');   % 这一行取消分号看标号

rmcontent(diabeticVar, {'parameter','Basal Plasma Glu Conc', 'Value', 164.18});
addcontent(diabeticVar, {{'parameter','Basal Plasma Glu Conc', 'Value', InitialGul}});% Display the variant
% 原本是164.18

diabeticMealSim = sbiosimulate(m1, configset, diabeticVar, mealDose1);

[tNormal, yNormal]  = normalMealSim.selectbyname('Plasma Glu Conc');   %一个一个地把模拟出的数据取出来（正常人）
[tDiabetic, yDiabetic]  = diabeticMealSim.selectbyname('Plasma Glu Conc');  %一个一个地把模拟出来的数据取出来（2型）

end

