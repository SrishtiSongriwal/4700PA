set(0,'defaultaxesfontsize',20) %settting the font size
set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultLineLineWidth',2) %for the line width property
set(0,'Defaultaxeslinewidth',2)

Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V = linspace (-1.95,0.7,200);
I = (ones(1,200));
I_2 = I + 0.4*rand(1,200)+-0.2;
Ii = Is.*(exp((1.2/25e-3).*V)-1) + Gp.*V - Ib*(exp((-1.2/0.025).*(V + Vb))-1);
noise = Ii.*0.2.*randn(1,200);
I = Ii + noise;
%x = linspace(1,200,200);

p_1 = polyfit(V,Ii,4);
y_1 = polyval(p_1,V);
p_2 = polyfit(V,Ii,8);
y_2 = polyval(p_2,V);

%Variable A
f0_1 = fittype('A.*(exp(1.2*x/25e-3)-1) + Gp.*x - C*(exp(1.2*(-(x + Vb))/25e-3)-1)');
ff_A_1 = fit(V.',I_2.',f0_1);
If_A_1 = ff_A_1(V);
 
%Variable B
f0_2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x + Vb))/25e-3)-1)');
ff_B_2 = fit(V.',I_2.',f0_2);
If_B_2 = ff_B_2(V);

%Variable C
f0_3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x + D))/25e-3)-1)');
ff_C_3 = fit(V.',I_2.',f0_3);
If_C_3 = ff_C_3(V);


inputs = V.';
targets = I_2.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs

figure()
subplot(3,2,1)
hold on
plot(V,Ii,'r')
plot(V,I,'g')
plot(V,Inn)
legend('I', 'I with noise', 'Inn')
hold off

subplot(3,2,2)
semilogy(V,abs(Ii),'r'), hold on
semilogy(V,abs(I))
semilogy(V,abs(Inn))
legend('I', 'I with noise', 'Inn')
hold off

subplot(3,2,3)
hold on
plot(V,y_1,'r')
plot(V,y_2,'g')
legend('4th order','8th order')
hold off

subplot(3,2,4)
semilogy(V,abs(y_1),'r'), hold on
semilogy(V,abs(y_2),'g')
legend('I', 'I with noise')
hold off

subplot(3,2,5)
hold on
plot(V,If_A_1,'r')
plot(V,If_B_2,'g')
plot(V,If_C_3,'b')
legend('EQA','EQB','EQC')
ylim([-4,4]);
hold off

subplot(3,2,6)
semilogy(V,abs(Ii),'m'), hold on
semilogy(V,abs(If_A_1),'r')
semilogy(V,abs(If_B_2),'g')
semilogy(V,abs(If_C_3),'b')
legend('data','EQA','EQB','EQC')
hold off
