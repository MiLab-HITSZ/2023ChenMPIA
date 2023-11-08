function CrowdDis = CrowdingEntropy(PopObj, FrontNo)
    % Calculate the crowding distance of each solution front by front

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
    % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
    % for evolutionary multi-objective optimization [educational forum], IEEE
    % Computational Intelligence Magazine, 2017, 12(4): 73-87".
    %--------------------------------------------------------------------------

    [N, M] = size(PopObj);
    CrowdDis = zeros(1, N);
    Fronts = setdiff(unique(FrontNo), inf);

    for f = 1:length(Fronts)
        Front = find(FrontNo == Fronts(f));
        Fmax = max(PopObj(Front, :), [], 1);
        Fmin = min(PopObj(Front, :), [], 1);

        for i = 1:M
            [~, Rank] = sortrows(PopObj(Front, i));
            CrowdDis(Front(Rank(1))) = inf;
            CrowdDis(Front(Rank(end))) = inf;

            for j = 2:length(Front) - 1
                c = PopObj(Front(Rank(j + 1)), i) - PopObj(Front(Rank(j - 1)), i)+0.000000000001;
                dl = (PopObj(Front(Rank(j + 1)), i) - PopObj(Front(Rank(j)), i)+0.000000000001);
                du = (PopObj(Front(Rank(j)), i) - PopObj(Front(Rank(j - 1)), i)+0.000000000001);
                pl = dl / c;
                pu = du / c;
                CE =- (dl * log2(pl) + du * log2(pu)) / (Fmax(i) - Fmin(i)+0.000000000001);
                CrowdDis(Front(Rank(j))) = CrowdDis(Front(Rank(j))) + CE;
            end

        end

    end

end
