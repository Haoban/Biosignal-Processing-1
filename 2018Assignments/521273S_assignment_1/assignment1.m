spirometer = load('spirometer.txt');
regressionCoefficients1 = load('regressionCoefficients1.txt');
regressionCoefficients2 = load('regressionCoefficients2.txt');
regressionCoefficients3 = load('regressionCoefficients3.txt');
beltSignals = load('beltSignals.txt');


spirometer_1 = resample(spirometer,1,2);


Fest_1 = beltSignals * regressionCoefficients1 ;
Fest_2 = [beltSignals , (beltSignals).^2] * regressionCoefficients2 ;
Fest_3 = [beltSignals, beltSignals(:,1).* beltSignals(:,2)] * regressionCoefficients3;




r_1 = ((sum(Fest_1 .* spirometer_1)) - length(spirometer_1) * mean(Fest_1) * mean(spirometer_1))^2/ ((sum((Fest_1).^2) - length(spirometer_1) * mean(Fest_1)^2) * (sum((spirometer_1).^2) - length(spirometer_1) * mean(spirometer_1)^2));
r_1 = sqrt(r_1);
%corrcoef(Fest_1 , spirometer_1);
r_2 = ((sum(Fest_2 .* spirometer_1)) - length(spirometer_1) * mean(Fest_2) * mean(spirometer_1))^2/ ((sum((Fest_2).^2) - length(spirometer_1) * mean(Fest_2)^2) * (sum((spirometer_1).^2) - length(spirometer_1) * mean(spirometer_1)^2));
r_2 = sqrt(r_2);
%corrcoef(Fest_2 , spirometer_1);
r_3 = ((sum(Fest_3 .* spirometer_1)) - length(spirometer_1) * mean(Fest_3) * mean(spirometer_1))^2/ ((sum((Fest_3).^2) - length(spirometer_1) * mean(Fest_3)^2) * (sum((spirometer_1).^2) - length(spirometer_1) * mean(spirometer_1)^2));
r_3 = sqrt(r_3);
%corrcoef(Fest_3 , spirometer_1);
SS_err_1 = sum((spirometer_1 - Fest_1).^2);
SS_err_2 = sum((spirometer_1 - Fest_2).^2);
SS_err_3 = sum((spirometer_1 - Fest_3).^2);

MSE_1 = SS_err_1/length(Fest_1);
MSE_2 = SS_err_2/length(Fest_2);
MSE_3 = SS_err_3/length(Fest_3);

RMSE_1 = sqrt(MSE_1);
RMSE_2 = sqrt(MSE_2);
RMSE_3 = sqrt(MSE_3);

figure(1)

subplot(2,1,1);
x = linspace(0,60,3001);
x = x(1,2:3001);
plot(x,Fest_1,'Color','r')
hold on
plot(x,Fest_2,'color','b')
hold on
plot(x,Fest_3,'color','g')
hold on
plot(x,spirometer_1,'color','k') 
title('Predicted respiratory airflow signal vs spirometer signals');
xlabel('seconds')
ylabel('Ml')

subplot(2,1,2);

x = linspace(0,60,3001);
x = x(1,2:3001);
plot(x,beltSignals(:,1),'b')
hold on
plot(x,beltSignals(:,2),'g'); 
title('Chest signal and abdomen signal');
xlabel('seconds')
ylabel('au')


