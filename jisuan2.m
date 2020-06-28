function [tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection)
% 输出糖尿病患者加入治疗方案后的血糖变化微分方程模型输出

sbioloadproject('insulin_run_data');  % 加载模型
warnSettings = warning('off', 'SimBiology:DimAnalysisNotDone_MatlabFcn_Dimensionless');


mealDose1 = sbioselect(m1, 'Name', 'Single Meal');
configset = getconfigset(m1,'active');  %这是一个配置项，结构体参数配置
configset.StopTime = 8;
set(configset.SolverOptions, 'OutputTimes', [0:0.01:8]);%设置采样率

params = sbioselect(m1,'Type','parameter');
params(21).Value = InitialGul;        % 血糖   164.18
params(68).Value = InjectCycle;         % 注射周期    20
params(78).Value = SwitchTime;        % 切换时间   240 
params(73).Value= InitialInjection;        % 第一次注射量  4000
params(67).Value = BigCycleInjection;        % 周期大注射量   140
params(76).Value = SmallCycleInjection;         % 周期小注射量   20
diabeticMealSimInj = sbiosimulate(m1, configset, [], mealDose1);

[tDiabeticInj, yDiabeticInj]  = diabeticMealSimInj.selectbyname('Plasma Glu Conc');
end