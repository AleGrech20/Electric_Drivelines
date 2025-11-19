%%% vehicle parameters and plotting of the load forces

close all
clear all

%%% vehicle paramers%%

%%masses%%
%mc: curb mass [kg]
mc=1500;

%mh: human standard mass [kg]
mh=80;
%np: number of passaengers 
np=4;
%mp: payload [kg]
mp=50;
%mg: gross weight [kg]
mg=mc+mh*np+mp;

%% Aerodynamic drag%%
%ro: air density [kg/m^3]
ro=1.2041;
%cd: drag coefficient
cd=0.30;
%af: cross section [m^2]
af=2;

%% Rolling resistance%%
%crr: coefficient of rolling resistance [N/N]
crr=0.012;

%rw: wheel radius [m]
%wd: hub wheel diameter [inches]
wd=15;
%wt: width of the tyre [mm]
wt=215;
%ar: height to width aspect ratio [%]
ar=65;
rw=wd/2*25.4e-3+wt*ar/100*1e-3;

%% Road resistance%%
%grade: road grade [pu]
grade =0;
%alfa: road angle [rad]
alfa =atan(grade);

%%TRANSMISSION%%
%rt: total gear ratio
rt=4.6

%%speed vector%%
%dv: speed discretization [m/s]
dv=0.1;

%v: vehicle speed vector [m/s]
v=[0:dv:50];
%vkph: vehicle speed in kph [km/h]
vkph=v.*3600/1000;


%%LOAD FORCES CALCULATION%%
%fa: aerodynamic drag force [N]
fa=1/2*ro*cd*af*v.^2;
%pa: aerodynamic drag power [W]
pa=fa.*v;

%frr: rolling resistance force [N]
frr=mg*9.81*cos(alfa)*crr*ones(size(v));
%prr: rolling resistance power [W]
prr=frr.*v;

%fgrade: force to overcome road grade [N]
fgrade=mg*9.81*sin(alfa)*ones(size(v));
pgrade=fgrade.*v;

%fl:total load force [N]
fl=fa+frr+fgrade;
%pl: totla load power [W]
pl=fl.*v;

figure
subplot(2,1,1)
plot(vkph, fa, vkph,frr, vkph,fgrade, vkph,fl, 'linewidth', 2)
grid
xlabel('vehicle speed [km/h]')
ylabel('N')
title ('LOAD FORCES')
legend ('AERO', 'ROLLING', 'GRADE', 'TOTAL')

subplot(2,1,2)
plot(vkph, pa/1000, vkph,prr/1000, vkph,pgrade/10000, vkph,pl/1000, 'linewidth', 2)
grid
xlabel('vehicle speed [km/h]')
ylabel('kW')
title ('LOAD POWER')
legend ('AERO', 'ROLLING', 'GRADE', 'TOTAL')

%cs: specific energy consuption [Wh/km]
cs=pl./vkph;

figure 
plot(vkph,cs,'linewidth',2)
grid
xlabel('vehicle speed [km/h]')
ylabel ('Wh/km')
title (' SPECIFIC ENERGY CONSUMPTION')