%% This script provides examples of how to use MPUAV benchmark and MPMOP benchmark.

clear 
close all
clc
rng(1)
addpath(genpath(pwd));
%% Part1 - A case about using MPUAV methods

seed = 1; % The random seed must be an integer in the interval [1,30]
problem = MPUAV1(seed);

rng(seed)
popsize = 100;
disp('The decision variables dim of MPUAV problem')
disp(problem.D)
disp('The objectives dim of MPUAV problem')
disp(problem.M)
disp('The decsion-maker nums of MPUAV problem')
disp(problem.DM)
disp('The decision variables lower bound of MPUAV problem')
disp(problem.lower)
disp('The decision variables upper bound of MPUAV problem')
disp(problem.upper)

% init the population X0 by using rand uniform distribution
X0 = problem.lower+(problem.upper-problem.lower).*rand(popsize,problem.D);

% cal the objectives value of population
Objs = problem.CalObj(X0);

disp('The MPHV metric of the population')
MPHV(Objs,problem)
%% Attention!

% (1) Calls to CalObj that exceed the number of evaluations MaxFE will trigger an error.
% An example of this error

% MaxFE = 10;
% problem = MPMOP11(MaxFE);
% for i = 1:10000000000
%    Objs = problem.CalObj(X0);
% end

% (2) The value of the random seed needs to be passed in when instantiating the MPUAV object.
% problem = MPUAV1(seed);


% (3) When the quality of the solution set is very poor, MPHV returns a value of 0.
%% Part2 - A case about using MPMOP methods
% MPMOP(D)
problem = MPMOP11(30);
popsize = 100;
disp('The decision variables dim of MPMOP problem')
disp(problem.D)
disp('The objectives dim of MPMOP problem')
disp(problem.M)
disp('The decsion-maker nums of MPMOP problem')
disp(problem.DM)
disp('The decision variables lower bound of MPMOP problem')
disp(problem.lower)
disp('The decision variables upper bound of MPMOP problem')
disp(problem.upper)

% init the population X0 by using rand uniform distribution
X0 = problem.lower+(problem.upper-problem.lower).*rand(popsize,problem.D);

% cal the objectives value of population
Objs = problem.CalObj(X0);

% cal the PF of MPMOP problem
PF = problem.PF();

% cal the PS of MPMOP problem
PS = problem.PS();

% plot the PF of MPMOP problem
OBJperDM = problem.M / problem.DM;
figure();
for dm = 1:problem.DM
    subplot(1,problem.DM,dm);
    index = (dm-1)*OBJperDM+1:dm*OBJperDM;
    if OBJperDM==2
        plot(PF(:,index(1)),PF(:,index(2)),'black.')
    end
    if OBJperDM==3
        plot3(PF(:,index(1)),PF(:,index(2)),PF(:,index(3)),'black.')
    end
end

disp('The MPIGD metric of the population')
MPIGD(Objs,problem)


