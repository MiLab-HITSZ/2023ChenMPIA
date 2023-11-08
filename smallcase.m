
%clear;
%clc;
%close all;
rng default
rng(11)
addpath(genpath(pwd));
%%
epoch = 1; % set MPUAV case index , epoch 1 is 1-6 , epoch 2 is 7-12
if epoch == 1
    data_seed = 12;
    RS=[9 9 9 9 9 9];
else
    data_seed = 121314;
    RS=[30 30 30 30 30 30];
end
data_2();
data.alpha_trace = 60/360*(2*pi); % ?????
data.beta_trace = 45/360*(2*pi); % ??????
data.map_size=map_size;
data.P_crash = 3.42 * 10e-4; % ??????
data.S_hit=0.0188; % m^2 ??????
data.R_I = 0.3;  % ???????
data.R_vf = 0.27; % ????????
data.alpha=10^6; % J ????????
data.beta = 100; % J 
data.S_c = 0.5 ; % ??????
data.g = 9.8 ; % m/s^2
data.IOT_pos=IOT_pos;
data.m = 1380 ; % g (DJI Phantom4)
data.rou_a = 1225 ; % g/m^3(???????)
data.miu = miu; % ?????????
data.sigma = sigma; % ?????????
data.v = 20; % 20m/s
S=[1 1];E=[45 45]; % ?????? 
data.S = S;
data.E = E;
data.minh=bulid_xyz;
data.maxh=141;
Bound = E(1)-S(1);
dim = Bound*2;
data.Bound = Bound;
data.map_step=map_step;
data.populations_risk=populations_risk;
data.road_risk=road_risk;
PLOTHV = 1;
PLOTStep = 7;
if exist('HVidealpoint.mat','file')
    load HVidealpoint.mat
    dir HVidealpoint.mat
    saveflag = 0;
else
    HVidealpointlist=[];
    saveflag = 1;
    PLOTHV = 0;
end
GLOBAL
%% pre-cal
ystep = 3;
pbase = ystep+1;
for i = 1:2*ystep+1
    pi = i - pbase;
    can=[];
    for j = -ystep:1:ystep
        if acos([1,pi]*[1,j]'/sqrt(1+pi^2)/sqrt(1+(j)^2))<=data.alpha_trace
            can=[can j];
        end
    end
    canselect{i}=can;
end
data.canselect = canselect;
data.canselectp = pbase;
%%
tiledlayout(2,2);
count=0;strcell={'(a)','(b)','(c)','(d)'};
for h = 30:30:120
    count=count+1;
    nexttile;
    Risk_map = zeros(map_size);
    Riskproperty_map = zeros(map_size);
    for i=1:map_size(1)
        for j =1:map_size(2)
            Risk_map(i,j)=Risk_map(i,j)+getC_Risk(getR_pf(getV(h,data),data),populations_risk(i,j),data);
            Risk_map(i,j)=Risk_map(i,j)+getC_Risk(data.R_vf,road_risk(i,j),data);
        end
    end
    colormap('jet')
    contourf(Risk_map)
    colorbar;
    title([strcell{count} '  At an altitude of ' num2str(h) 'm'],'Position',[26,-12]);
end
%%
problemList={@MPUAV4};
maxiterList={80000,80000,80000,80000,80000,80000};
data.lb = [ones(1,dim/2-1).*-2 ones(1,dim/2+1).*0];
data.ub = [ones(1,dim/2-1).*ystep ones(1,dim/2+1).*1];
data.dim = dim;
figure(100);

for problemindex=1:numel(problemList)
    RANDSEED=RS(problemindex);
    popnum=105;
    maxiter=maxiterList{problemindex};
    problem=problemList{problemindex};
    newp=problem(data);
    funname = newp.Global.funname;
    callfit = newp.Global.fn;
    %% MPIA
    rng default;rng(5);
    test_case={@MPIA2,problem,popnum,1,1,maxiter,dim};
    for i =1:numel(test_case)/7
        var={'-algorithm',test_case{i,1},'-problem',test_case{i,2},'-N',test_case{i,3},'-save',test_case{i,4},'-run',test_case{i,5},'-evaluation',test_case{i,6},'-D',test_case{i,7},'-data',data,'-showflag',1};
        Global = GLOBAL(var{:});
        Global.Start();
    end
end


