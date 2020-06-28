function [tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul)
% ��������˺����������ƻ��ߵ�Ѫ�Ǳ仯���

sbioloadproject('insulindemo');  % ����ģ��
warnSettings = warning('off', 'SimBiology:DimAnalysisNotDone_MatlabFcn_Dimensionless');


mealDose1 = sbioselect(m1, 'Name', 'Single Meal');
configset = getconfigset(m1,'active');  %����һ��������ṹ���������
configset.StopTime = 8;
set(configset.SolverOptions, 'OutputTimes', [0:0.01:8]);%���ò�����

normalMealSim = sbiosimulate(m1, configset, [], mealDose1);  %ģ��������

diabeticVar = sbioselect(m1, 'Name', 'Type 2 diabetic');   % ��һ��ȡ���ֺſ����

rmcontent(diabeticVar, {'parameter','Basal Plasma Glu Conc', 'Value', 164.18});
addcontent(diabeticVar, {{'parameter','Basal Plasma Glu Conc', 'Value', InitialGul}});% Display the variant
% ԭ����164.18

diabeticMealSim = sbiosimulate(m1, configset, diabeticVar, mealDose1);

[tNormal, yNormal]  = normalMealSim.selectbyname('Plasma Glu Conc');   %һ��һ���ذ�ģ���������ȡ�����������ˣ�
[tDiabetic, yDiabetic]  = diabeticMealSim.selectbyname('Plasma Glu Conc');  %һ��һ���ذ�ģ�����������ȡ������2�ͣ�

end

