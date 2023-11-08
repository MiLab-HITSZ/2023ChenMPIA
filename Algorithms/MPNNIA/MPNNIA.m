function MPNNIA(Global)
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
            nA = 20;
            nC = Global.N;
            nCin = 20;
            %% Generate random population
            B = Global.Initialization();               % Antibody population
            [D,FrontNo_low,FrontNo] = UpdateDominantPopulation(B,Global.N,Global.DM);	% Dominant population

            %% Optimization
            while Global.NotTermination(D)
                Activeindex = 1:min(min(nA,length(D)));
                Cloneindex = 1:min(min(nCin,length(D)));
                A  = D(Activeindex);            % Active population
                C  = Cloning(D(Cloneindex),nC,FrontNo_low(Cloneindex,:),FrontNo(Cloneindex));                     % Clone population
                
                % SBX + PM
               R = randi(length(A),1,length(C));
               for n = 1:length(C)
                       R(n)=randi(length(A));
               end
               C1 = OperatorGAhalf([C,A(R)]);
                [D,FrontNo_low,FrontNo]  = UpdateDominantPopulation([D,C1],Global.N,Global.DM);
            end
end