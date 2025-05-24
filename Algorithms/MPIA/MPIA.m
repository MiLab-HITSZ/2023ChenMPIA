 function MPIA(Global)
% <multi> <real/binary/permutation>
% Nondominated neighbor immune algorithm
% nA ---  20 --- Size of active population
% nC --- 100 --- Size of clone population

%------------------------------- Reference --------------------------------
% M. Gong, L. Jiao, H. Du, and L. Bo, Multiobjective immune algorithm with
% nondominated neighbor-based selection, Evolutionary Computation, 2008,
% 16(2): 225-255.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
            %% Parameter setting
            % nA = 20;
            nC = Global.N;
            % nCin = 20;
            %% Generate random population
            B = Global.Initialization();               % Antibody population
            [D,FrontNo_low,FrontNo,~] = UpdateDominantPopulation(B,Global.N,Global.DM);	% Dominant population
            
            
            MaxGen = Global.evaluation/Global.evaluated;
            nowGen = 1;
            p(nowGen) = 0.95*1/(1+exp(20*(nowGen/MaxGen-0.3)));
            RRRR=[];
            %% Optimization
            while Global.NotTermination(D)

    

                %Activeindex = 1:min(min(nA,length(D)));
                %Cloneindex = 1:min(min(nCin,length(D)));
                
                if any(D.objs>1e7)
                    Activeindex = 1:50;
                else
                    Bound = (max(D.objs)-min(D.objs));
                    ActiveindexList = [20 30 40 50 60 70];                mrlist = zeros(1,length(ActiveindexList));
                    for  Ai = 1:length(ActiveindexList)
                        Anum = ActiveindexList(Ai);
                        Atemp = D(1:Anum);
                        mr=min((max(Atemp.objs)-min(Atemp.objs))./Bound);
                        mrlist(Ai)=mr;
                    end
                    Selecti = find(mrlist>0.99,1,'first');
                    if isempty(Selecti)
                        Activeindex = 1:70;
                    else
                        Activeindex = 1:ActiveindexList(Selecti);
                    end
                end
                Cloneindex = Activeindex;
                A  = D(Activeindex);            % Active population
                RRRR = [RRRR Activeindex(end)];

                [C,FL,F,indexlist]  = Cloning(D(Cloneindex),nC,FrontNo_low(Cloneindex,:),FrontNo(Cloneindex));                   
                % Clone population
                C1 = C;
                MAT = zeros(1,length(A));
                for n=1:length(C)
                    if rand<p(nowGen)
                        R = randperm(length(A),4);
                        C1(n) = OperatorDE2(C(n),A(R(1)),A(R(2)),A(R(3)),A(R(4)),{0.9,0.5,1,20});
                    else
                        if rand<0.6 && F(n)>1 && MAT(indexlist(n))==0
                            %[~,mi]=max(FL(n,:));
                            mi = randi(Global.DM);
                            r1 = find(FrontNo_low(:,mi)==1 & FrontNo'<=F(n));
                            if isempty(r1)
                               R = randperm(length(A),2);
                                C1(n) = OperatorDE(C(n),A(R(1)),A(R(2)),{0.5,0.5,1,20});
                            else
                                r1 = r1(randi(length(r1)));
                                MAT(indexlist(n))=1;
                                C1(n) = OperatorGAhalf([C(n),D(r1)]);
                            end
                        else
                            R = randperm(length(A),2);
                            C1(n) = OperatorDE(C(n),A(R(1)),A(R(2)),{0.5,0.5,1,20});
                        end
                    end
                end
                [D,FrontNo_low,FrontNo,~]  = UpdateDominantPopulation([D,C1],Global.N,Global.DM);
                nowGen = nowGen+1;
                p(nowGen) = 0.95*1/(1+exp(20*(nowGen/MaxGen-0.3)));
            end
end
