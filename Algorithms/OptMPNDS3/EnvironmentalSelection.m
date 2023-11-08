function [Population, FrontNo, CrowdDis, Archive] = EnvironmentalSelection(Population, N, DM)
    % The environmental selection of OptAll

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
    % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
    % for evolutionary multi-objective optimization [educational forum], IEEE
    % Computational Intelligence Magazine, 2017, 12(4): 73-87".
    %--------------------------------------------------------------------------

    %% Non-dominated sorting
    objs = Population.objs;
    [objs, loc, ~] = unique(objs, 'rows');
    Population = Population(loc);
    %%take use of PLNDS to sort
    % [FrontNo, MaxFNo] = PLNDS(objs, Population.cons, N, DM);
    [FrontNo, MaxFNo] = PLNDS(objs, Population.cons, N, DM);
    Next = FrontNo < MaxFNo;
    % CrowdDis = -GaussianKernel(objs);
    % CrowdDis = CrowdingDistance(objs, FrontNo);
    Last = find(FrontNo == MaxFNo);

    while length(Last) > N - sum(Next)
        % CrowdDis = FairnessMeasure(objs(Last, :), FrontNo(Last));
        CrowdDis = CrowdingEntropy(objs(Last,:), FrontNo(Last));
    % CrowdDis = CrowdingDistance(objs(Last,:), FrontNo(Last));

%         decs = Population.decs;
%         figure();
%         gscatter(decs(Last, 1), decs(Last, 2), CrowdDis');
        [~, index] = min(CrowdDis);
        Last(index) = [];
    end

    Next(Last) = true;

    %% Population for next generation
    Population = Population(Next);
    FrontNo = FrontNo(Next);
    CrowdDis = CrowdingEntropy(objs(Next,:), FrontNo);
    % CrowdDis = CrowdingDistance(objs(Next, :), FrontNo);
    % CrowdDis = FairnessMeasure(objs(Next, :), FrontNo);
end
