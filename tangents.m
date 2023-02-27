clear all
clc
syms x

% Input the number of tangents to approximate
numtan = input('How many tangents do you want? (2 or 3):');

% Equation of the curve (3rd order)
p1 = 0.0000002;
p2 = -0.0001603;
p3 = 0.1082458;
p4 = 0.0685682;
curva = p1*x^3 + p2*x^2 + p3*x + p4;

% Upper limit and step
n = 300;
p = 60; % Only for symmetric curves, set p so that n/p is odd (this avoids having two solutions)

% Graph of the curve
x2 = 0:p:n;
y = subs(curva, x, x2);
figure
hold on
plot(x2, y, 'b', 'LineWidth', 3)
xlabel('MWh')
ylabel('Cost US$/MWh')
grid on

% Total area under the curve
area = int(curva, x, 0, n);

% Obtain the derivative
der = diff(curva);
dy = subs(der, x, x2);

% Graph of the derivative
%plot(x2,dy,'r','LineWidth',1)%grafico de la tangente

% Obtain all the tangents y=mx+b
for i = 1:n/p+1
    b(i) = y(i) - dy(i) * x2(i);
    t(i) = dy(i) * x + b(i);
    tan = subs(t(i), x, x2);
    % Graph of all tangents
    %plot(x2,tan)
end

%%%%%%FOR TWO TANGENTS%%%%%%
if numtan == 2
    % To follow the process of searching for better tangents
    contador = 1;
    ncomb = factorial(floor(n/p+1)) / (factorial(floor(n/p-1)) * factorial(2)); % Number of possible combinations nCr

    % Error between pairs of tangents and the area of the curve
    for i = 1:n/p+1
        for j = i+1:n/p+1
            fprintf('Trying combination %d of %.0f\n', contador, ncomb);
            cruces(i,j) = solve(t(i) == t(j));
            at(i,j) = int(t(i), x, 0, cruces(i,j)) + int(t(j), x, cruces(i,j), n);
            errorp(i,j) = (at(i,j) - area) * 100 / at(i,j);
            contador = contador + 1;
        end
    end

    % Locate the best pair of tangents (smallest area error)
    menor = min(errorp(find(errorp~=0)));
    [tg1, tg2] = find(errorp == menor);
    tan1 = subs(t(tg1), x, x2);
    tan2 = subs(t(tg2), x, x2);

    % Graph of the two best tangents and the intersections with the curve
    plot(x2, tan1)
    plot(x2, tan2)
    xtg1 = solve(y(tg1) == t(tg1));
    xtg2 = solve(y(tg2) == t(tg2));
    rangox = solve(t(tg1) == t(tg2));
    rangoy = subs(t(tg1), x, rangox);
    plot(xtg1,y(tg1),'*r','LineWidth',1,'MarkerSize',10)
    plot(xtg2,y(tg2),'*r','LineWidth',1,'MarkerSize',10)
    plot(rangox,rangoy,'og','LineWidth',2,'MarkerFaceColor','g')
    legend('Curve','Tangent 1','Tangent 2','Tangential Point 1','Tangential Point 2','Intersection of Tangents','Location','northwest')
    hold off
    
    %Printing Results
    fprintf('\nThe best combination is: tangent %d, tangent %d; with an area error of %.2f%%\n\n',tg1,tg2,menor)
    fprintf('The two best tangents intersect the curve at:\ntan%d(x1,y1)=(%d,%3.2f)\ntan%d(x2,y2)=(%d,%3.2f)\n\n',tg1,xtg1,y(tg1),tg2,xtg2,y(tg2));
    fprintf('The tangents intersect each other at:\n(x,y)=(%3.2f,%3.2f)\n\n',rangox,rangoy);
    fprintf('Tariff Range 1: [0,%d]\nTariff Range 2:[%d,%d]\n\n',rangox,rangox,n);


%%%%%%FOR THREE TANGENTS%%%%%%
elseif numtan==3
%To follow the process of searching for better tangents
contador=1;
ncomb=factorial(floor(n/p+1))/((factorial(floor(n/p-2))*factorial(3)));%Number of possible combinations nCr

%Error between pairs of tangents and the area of the curve
for i=1:n/p+1
for j=i+1:n/p+1
for k=j+1:n/p+1
fprintf('Trying combination %d of %.0f\n',contador,ncomb);
cruces1(i,j)=solve(t(i)==t(j));
cruces2(j,k)=solve(t(j)==t(k));
at(i,j,k)=int(t(i),x,0,cruces1(i,j))+int(t(j),x,cruces1(i,j),cruces2(j,k))+int(t(k),x,cruces2(j,k),n);
errorp(i,j,k)=(at(i,j,k)-area)*100/at(i,j,k);
contador=contador+1;
end
end
end

%Locate the best combination of tangents (smallest area error)
menor=min(errorp(find(errorp~=0)));
[tg1,tg2]=find(errorp==menor);
t1=tg1(1);
t3=ceil(tg2(1)/(n/p));
t2=tg2(1)-(n/p)*(t3-1);
tan1=subs(t(t1),x,x2);
tan2=subs(t(t2),x,x2);
tan3=subs(t(t3),x,x2);

%Graph of the three best tangents and the intersections with the curve
plot(x2,tan1)
plot(x2,tan2)
plot(x2,tan3)
xtg1=solve(y(t1)==t(t1));
xtg2=solve(y(t2)==t(t2));
xtg3=solve(y(t3)==t(t3));
rangox1=solve(t(t1)==t(t2));
rangox2=solve(t(t2)==t(t3));
rangoy1=subs(t(t1),x,rangox1);
rangoy2=subs(t(t2),x,rangox2);
plot(xtg1,y(t1),'*r','LineWidth',1,'MarkerSize',10)
plot(xtg2,y(t2),'*r','LineWidth',1,'MarkerSize',10)
plot(xtg3,y(t3),'*r','LineWidth',1,'MarkerSize',10)
plot(rangox1,rangoy1,'og','LineWidth',2,'MarkerFaceColor','g')
plot(rangox2,rangoy2,'og','LineWidth',2,'MarkerFaceColor','g')
legend('Curve','Tangent 1','Tangent 2','Tangent 3','Tangential Point 1','Tangential Point 2','Tangential Point 3','First Intersection between Tangents','Second Intersection between Tangents','Location','northwest')
hold off

% Print Results
fprintf('\nThe best combination is: tangent %d, tangent %d, tangent %d; with an area error of=%.2f%%\n\n',t1,t2,t3,menor)
fprintf('The three best tangents intersect the curve at:\ntan%d(x1,y1)=(%d,%.2f)\ntan%d(x2,y2)=(%d,%.2f)\ntan%d(x3,y3)=(%d,%.2f)\n\n',t1,xtg1,y(t1),t2,xtg2,y(t2),t3,xtg3,y(t3));
fprintf('The tangents intersect each other at:\n(x1,y1)=(%.2f,%.2f)\n(x2,y2)=(%.2f,%.2f)\n\n',rangox1,rangoy1,rangox2,rangoy2);
fprintf('Tariff Range 1: [0,%d]\nTariff Range 2: [%d,%d]\nTariff Range 3: [%d,%d]\n\n',rangox1,rangox1,rangox2,rangox2,n);
end
