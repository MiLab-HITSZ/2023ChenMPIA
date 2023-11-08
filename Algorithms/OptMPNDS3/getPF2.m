function [PF1, PF2] = getPF2(Global,FElist,popsize)
    N = Global.N;
    Global.N = popsize;
    Population = Global.Initialization();    
    [~, FrontNo, CrowdDis] = EnvironmentalSelection1(Population, ...
        Global.N, Global.DM{1});
    A=[];
    %% Optimization
    while Global.evaluated < FElist(1)
        MatingPool = TournamentSelection(2, Global.N, FrontNo, -CrowdDis);
        Offspring = GA(Population(MatingPool));
        [Population, FrontNo, CrowdDis] = EnvironmentalSelection1( ...
            [Population, Offspring], Global.N, Global.DM{1});
        A=[A Population];
    end
    A=unique(A);
    PF1 = Population;
    Population = A;
    [Population, FrontNo, CrowdDis] = EnvironmentalSelection1(Population, ...
        Global.N, Global.DM{2});
    %% Optimization
    while Global.evaluated < FElist(1)+FElist(2)
        MatingPool = TournamentSelection(2, Global.N, FrontNo, -CrowdDis);
        Offspring = GA(Population(MatingPool));
        [Population, FrontNo, CrowdDis] = EnvironmentalSelection1( ...
            [Population, Offspring], Global.N, Global.DM{2});
    end

    PF2 = Population;
    Global.N = N;
end
