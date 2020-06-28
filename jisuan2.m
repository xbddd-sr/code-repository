function [tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection)
% ������򲡻��߼������Ʒ������Ѫ�Ǳ仯΢�ַ���ģ�����

sbioloadproject('insulin_run_data');  % ����ģ��
warnSettings = warning('off', 'SimBiology:DimAnalysisNotDone_MatlabFcn_Dimensionless');


mealDose1 = sbioselect(m1, 'Name', 'Single Meal');
configset = getconfigset(m1,'active');  %����һ��������ṹ���������
configset.StopTime = 8;
set(configset.SolverOptions, 'OutputTimes', [0:0.01:8]);%���ò�����

params = sbioselect(m1,'Type','parameter');
params(21).Value = InitialGul;        % Ѫ��   164.18
params(68).Value = InjectCycle;         % ע������    20
params(78).Value = SwitchTime;        % �л�ʱ��   240 
params(73).Value= InitialInjection;        % ��һ��ע����  4000
params(67).Value = BigCycleInjection;        % ���ڴ�ע����   140
params(76).Value = SmallCycleInjection;         % ����Сע����   20
diabeticMealSimInj = sbiosimulate(m1, configset, [], mealDose1);

[tDiabeticInj, yDiabeticInj]  = diabeticMealSimInj.selectbyname('Plasma Glu Conc');
end