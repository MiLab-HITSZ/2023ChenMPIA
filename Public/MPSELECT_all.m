function [Population,POBJS] = MPSELECT_all (Population,DM)
% The environmental selection of OptMPNDS

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    %% Non-dominated sorting
    id =[];
    POBJS=[];
    for i = 1:numel(Population)
        id = [id ones(1,size(Population{i},1))*i];
        POBJS=[POBJS;Population{i}];
    end
    N = size(POBJS,1);
    objs=POBJS;
    [Nin,M]= size(objs);
    FrontNo_low = zeros(Nin,DM);
    for i =1:DM
        FrontNo_low(:,i) = NDSort(objs(:,(i-1)*(M/DM)+1:i*(M/DM)),zeros(N,1),Nin);
    end
    [FrontNo,~] = NDSort(FrontNo_low,zeros(N,1),N); 
    %% Population for next generation
    id = id(FrontNo==1);
    POBJS = POBJS(FrontNo==1,:);
    for i = 1:numel(Population)
        Population{i}=POBJS(id==i,:);
    end
  end