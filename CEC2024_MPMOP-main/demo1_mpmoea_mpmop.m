%% This script provides examples of how to test MPMOEAs using MPMOPs.
% The final pouplation should be named "population_MPMOPn" when solving
% MPMOPn. In this script, we implment the algorithm MPNDS.
clear
clc
close all
rng(1)
addpath(genpath(pwd));
%% OptMPNDS
popsize = 100;
problem = MPMOP8(30);
X0 = problem.lower+(problem.upper-problem.lower).*rand(popsize,problem.D);
Y0 = problem.CalObj(X0);
P.getX = @(population) population(:,1:problem.D);
P.getY = @(population) population(:,problem.D+1:end);
P.Population = [X0 Y0];
[~,FrontNo,CrowdDis] = EnvironmentalSelection(P,popsize,problem.DM);
try
    while 1
        fprintf("FE:%d/MaxFE:%d\n",problem.calcount,problem.maxFE);
        MatingPool = TournamentSelection(2,popsize,FrontNo,-CrowdDis);
        Offspring_X  = GA(P.getX(P.Population(MatingPool,:)),problem.lower,problem.upper);
        Offspring_Y  = problem.CalObj(Offspring_X);
        P.Population = [P.Population; Offspring_X Offspring_Y];
        [P.Population,FrontNo,CrowdDis] = EnvironmentalSelection(P,popsize,problem.DM);
    end
catch
    population_MPMOP11 = P.getX(P.Population);
end
%% Eval the solutions using MPIGD metric
disp('The MPIGD metric of the population')
objs = P.getY(P.Population);
MPIGD(objs,problem)

















%% The selection operator
function [Population,FrontNo,CrowdDis] = EnvironmentalSelection(P,N,DM)
    %% Non-dominated sorting
    Population = P.Population;
    objs = P.getY(Population);
    %%take use of MPNDS to sort
    [FrontNo,MaxFNo] = MPNDS(objs,[],N,DM);    
    Next = FrontNo < MaxFNo;
    CrowdDis = CrowdingDistance(objs,FrontNo);
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    %% Population for next generation
    Population = Population(Next,:);
    FrontNo    = FrontNo(Next);
    CrowdDis   = CrowdDis(Next);
end
%% CrowdingDistance fucntion
function CrowdDis = CrowdingDistance(PopObj,FrontNo)
% Calculate the crowding distance of each solution front by front
    [N,M]    = size(PopObj);
    CrowdDis = zeros(1,N);
    Fronts   = setdiff(unique(FrontNo),inf);
    for f = 1 : length(Fronts)
        Front = find(FrontNo==Fronts(f));
        Fmax  = max(PopObj(Front,:),[],1);
        Fmin  = min(PopObj(Front,:),[],1);
        for i = 1 : M
            [~,Rank] = sortrows(PopObj(Front,i));
            CrowdDis(Front(Rank(1)))   = inf;
            CrowdDis(Front(Rank(end))) = inf;
            for j = 2 : length(Front)-1
                CrowdDis(Front(Rank(j))) = CrowdDis(Front(Rank(j)))+(PopObj(Front(Rank(j+1)),i)-PopObj(Front(Rank(j-1)),i))/(Fmax(i)-Fmin(i));
            end
        end
    end
end
%% multiparty non-dominated sorting operator (MPNDS)
function [FrontNo,MaxFNo] = MPNDS(varargin)
    %the procedure for MPNDS
    %DM is the number of decison makers
    PopObj = varargin{1};
    [~,M]  = size(PopObj);
    if nargin == 3
        nSort  = varargin{2};
        DM=varargin{3};
    else
        PopCon = varargin{2};
        nSort  = varargin{3};
        DM=varargin{4};
        Infeasible           = any(PopCon>0,2);
        PopObj(Infeasible,:) = repmat(max(PopObj,[],1),sum(Infeasible),1) + repmat(sum(max(0,PopCon(Infeasible,:)),2),1,M);
    end
    [FrontNo,MaxFNo] = MPNDS_Sort(PopObj,nSort,DM);  
end
function [FrontNo,MaxFNo] = MPNDS_Sort(PopObj,nSort,DM)
    [PopObj,~,Loc] = unique(PopObj,'rows');
    Table          = hist(Loc,1:max(Loc));
    [N,M]          = size(PopObj);    
    FrontNo        = inf(1,N);
    MaxFNo         = 1;
    FNo=1;
    S=false(1,N);
    Visited=false(1,N);
    Front=inf(DM,N);
    %Fast Non Dominated Sorting for each party
    for k=1:DM
        Front(k,:)=NDSort(PopObj(:,(k-1)*M/DM+1:k*M/DM),N);
    end
    FrontNo_max=max(Front,[],1);     %find the max level for individual in all parties
    %MPNDS
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        Fz=true(1,N);
         %Pop(k).frontno==FNo&Pop(k).visited==false represent individulas
         %which are in the Fno_th Front in k decision maker.
        for k=1:DM
            Fz=Fz&Front(k,:)==FNo&Visited==false;%get the union and store in Fz
        end        
        if sum(Fz)==0           
            for k=1:DM 
                S=S|(Front(k,:)==FNo&Visited==false); %S union the rest
            end
            FNo=FNo+1; 
            Fz=S&(FrontNo_max==FNo);
            S(find(Fz~=0))=0;    %S=S-Fz       
        end
        if sum(Fz)~=0            
            FrontNo(Fz)=MaxFNo;
             temp=false(1,N);
             temp(Fz)=true;           
             Visited(temp)=true;%minus the Fz
             MaxFNo = MaxFNo + 1;
        end
    end
    FrontNo = FrontNo(:,Loc);
    MaxFNo=MaxFNo-1;
end