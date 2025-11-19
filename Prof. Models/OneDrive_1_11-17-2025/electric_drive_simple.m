% create a user defined characteristic of an electric drive
%May 15th, 2024
%clear all
close all

%1st trait 0-A:     constant maximum torque
%2nd trait A-B:     connection between overload and rated
%3rd trait B-C:     constant power
%4th trait C-inf:   decreasing power

%%%PARAMETRS 
%pb: rated power [W]
pb=40000;
%nb: rated speed [rpm]
nb=3000;

%tb: base torque [Nm]
tb=pb/(2*pi*nb/60);

%ta: maximum torque [Nm]
ta=2*tb;

%na: max speed of max torque [rpm]
na=nb*0.7;

%nc: maximum speed of constant power
nc=2*nb;

%dn: motor speed step [rpm]
dn=1;

%n: motor speed vector [rpm]
n=[0:dn:8000];

%tm: motor torque vector [Nm]

i=0
for i=1: length (n);
    if n(i)<=na
        %0-A trait
        tm(i)=ta;
    else
        if n(i)<=nb
        % A-B trait
        tm(i)=(ta-tb)*((nb-n(i))/(nb-na))^1.5+tb;
        else
            if n(i)<=nc
                %B-C trait
                tm(i)=tb*nb/n(i);
                tc=tm(i);
            else
                %C trait
                tm(i)=tc*(nc/n(i))^2;
            end
        end
    end
end

%pm: motor power [W]
pm=tm.*n*2*pi/60;


figure 
subplot (2,1,1)
plot(n,tm,'linewidth',2)
grid
xlabel('motor speed [rpm]')
ylabel ('[Nm]')
title ('MOTOR TORQUE')

subplot (2,1,2)
plot(n,pm/1000,'linewidth',2)
grid
xlabel('motor speed [rpm]')
ylabel ('[KW]')
title ('MOTOR POWER')

