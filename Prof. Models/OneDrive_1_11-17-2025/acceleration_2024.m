%%% acceleration 
% May_15 2024

clear all
close all

%calculates the acceleration of a vehicle using the scripts:
vehicle_load_2024
electric_drive_simple

%wm: motor speed vector [rad/s]
wm=n*2*pi/60;

%v_m: vehicle speed from the motor speed [m/s]
v_m=wm/rt*rw;

%f_m: tractive effort from the motor [N]
f_m=tm*rt/rw;

%ft: tractive effort resampled with the discretization of the vehicle speed
%v[N]
ft=interp1(v_m,f_m,v);

%pt: motor power [W]
pt=ft.*v;

% figure 
% plot(v,ft,'*',v_m,f_m,'+')
% legend('vehicle discretization','motor discretization')

figure
subplot(2,1,1)
plot(vkph,ft,vkph,fl,'linewidth',2)
grid
xlabel('vehicle speed [km/h]')
ylabel ('[N]')
title('FORCES')
legend('TRACTION', 'LOAD')

subplot(2,1,2)
plot(vkph,pt/1000,vkph,pl/1000,'linewidth',2)
grid
xlabel('vehicle speed [km/h]')
ylabel ('[kw]')
title('POWER')
legend('TRACTION', 'LOAD')

%tl_v: load torque from the vehicle [Nm]
tl_v=fl*rw/rt;

%n_v: motor speed from the vehicle [rpm]
n_v=v/rw*rt*60/2/pi;

%tl: load torque using motor speed discretization [rpm]
tl=interp1(n_v, tl_v,n);
%pl_m: load power at the motor [W]
pl_m=tl.*n*2*pi/60;

figure
subplot(2,2,1)
plot(vkph,ft,vkph,fl,'linewidth',2)
grid
xlabel('vehicle speed [km/h]')
ylabel ('[N]')
title('FORCES')
legend('TRACTION', 'LOAD')

subplot(2,2,3)
plot(vkph,pt/1000,vkph,pl/1000,'linewidth',2)
grid
xlabel('vehicle speed [km/h]')
ylabel ('[kw]')
title('POWER')
legend('TRACTION', 'LOAD')

subplot(2,2,2)
plot(n,tm,n,tl,'linewidth',2)
grid
xlabel('motor speed [rpm]')
ylabel ('[Nm]')
title('TORQUE')
legend('TRACTION', 'LOAD')

subplot(2,2,4)
plot(n,pm/1000,n,pl_m/1000,'linewidth',2)
grid
xlabel('motor speed [rpm]')
ylabel ('[kw]')
title('POWER')
legend('TRACTION', 'LOAD')

%%%acceleration %%
%facc: acceleration force [N]
facc=ft-fl;

%i_pos_acc: elements of the vector with positive acceleration
i_pos_acc=find(facc>0);

%i_max_speed: element of top speed
i_max_speed=length(i_pos_acc);

%v_max: top speed [m/s]
v_max=v(i_max_speed);
v_max_kph=v_max*3600/1000


%acc: vehicle acceleration [m/s^2]
acc=facc(i_pos_acc)/mg; 

%acc_max: maximum acceleration [m/s^2]
acc_max=max(acc)
%g_max: maximum acceleration in g
g_max=acc_max/9.81;

%dt: vector of delta time for each dv
dt=dv./acc;

%speed: speed vector of positive acceleration [m/s]
speed=v(i_pos_acc);

%t_acc: acceleration time [s]
t_acc=cumsum(dt);

%dd: delta distance [m]
dd=speed.*dt;

%dist: distance travelled from 0 [m]
dist=cumsum(dd);

figure 
subplot(3,1,1)
plot(t_acc,acc,'linewidth',2)
grid
title ('ACCELERATION')
ylabel('[m/s^2]')
axis([0 60 0 2])

subplot(3,1,2)
plot(t_acc,speed*3.6,'linewidth',2)
grid
title ('SPEED')
ylabel('[kph]')
axis([0 60 0 160])

subplot(3,1,3)
plot(t_acc,dist,'linewidth',2)
grid
title ('DISTANCE')
ylabel('[m]')
axis([0 60 0 2000])

