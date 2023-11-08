function PFlist = getPF(Global,FElist,popsize)
    N = Global.N;
    Global.N = popsize;
    A = [];
    ListSUM = cumsum(FElist);
    PFlist=[];
    %% Optimization
    for i = 1:length(FElist)
        Population=Global.Initialization();
        [Population, FrontNo, CrowdDis] = EnvironmentalSelection1(Population, ...
        Global.N, Global.DM{i});
        while Global.evaluated < ListSUM(i)
            MatingPool = TournamentSelection(2, Global.N, FrontNo, -CrowdDis);
            Offspring = GA(Population(MatingPool));
            [Population, FrontNo, CrowdDis] = EnvironmentalSelection1( ...
                [Population, Offspring], Global.N, Global.DM{i});
        end
        PFlist=[PFlist Population];
    end
    Global.N = N;
end
