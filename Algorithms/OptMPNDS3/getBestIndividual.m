function Pbest = getBestIndividual(Population, FrontNo, CrowdDis)
    N = length(Population);
    P = 0.05;

    top = ceil(N * P);
    top = randi(top);
    count = 0;
    index = 0;

    while (count < top)
        index = index + 1;
        tmp = length(find(FrontNo == index));
        count = count + tmp;
    end

    count = length(find(FrontNo < index));
    Last = find(FrontNo == index);
    [~, Rank] = sort(CrowdDis(Last), 'descend');
    Next = Last(Rank(top - count));

    Pbest = Population(Next);
end
