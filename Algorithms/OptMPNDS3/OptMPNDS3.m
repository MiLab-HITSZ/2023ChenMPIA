function OptMPNDS3(Global)
    % <algorithm> <O>
    % OptMPNDS3
    for i = 1:Global.DM
        DMlist{i}=[1+(i-1)*(Global.M/Global.DM):i*(Global.M/Global.DM)];
    end
    Global.setDM(DMlist);
    Population = getPF(Global,ones(1,numel(Global.DM))*1500,Global.N);
    [Population, FrontNo, CrowdDis] = EnvironmentalSelection(Population, length(Population), Global.DM);
    % Global.problem.Draw(Population.decs, FrontNo, func2str(Global.algorithm));

    % initial the parameters
    mu_CR = 0.5;
    mu_F = 0.5;
    Archive = [];
    c = 0.05;

    while Global.NotTermination(Population)
        S_F = [];
        S_CR = [];
        Offsprings = [];
        tempArchive = [];
        N = length(Population); % size of Population

        for i = Population
            % generate Normal random number
            pd = makedist('Normal', 'mu', mu_CR, 'sigma', 0.1);
            t = truncate(pd, 0, 1);
            CR_i = random(t);

            % generate Cauchy random number
            pd = makedist('tLocationScale', 'mu', mu_F, 'sigma', 0.1, 'nu', 1);
            F_i = random(pd);
            % truncate the probability
            while F_i <= 0
                F_i = random(pd);
            end

            if F_i > 1
                F_i = 1;
            end

            Pbest = getBestIndividual(Population, FrontNo, CrowdDis);
            Parent1 = Population(randi(N));

            while Parent1 == i
                Parent1 = Population(randi(N));
            end

            temp = [Archive, Population];
            Parent2 = temp(randi(length(temp)));

            while Parent2 == Parent1
                Parent2 = temp(randi(length(temp)));
            end

            x = i.decs;
            Pbest = Pbest.decs;
            Parent1 = Parent1.decs;
            Parent2 = Parent2.decs;
            trial = x + F_i * (Pbest - x) + F_i * (Parent2 - Parent1);
            D = length(x);
            j_rand = randi(D);

            for j = 1:D

                if j == j_rand || rand() < CR_i
                    dec(j) = trial(j);
                else
                    dec(j) = x(j);
                end

            end


            % generate the offspring
            Offspring = INDIVIDUAL(dec, [CR_i, F_i]);

            if dominated(Offspring.objs, i.objs, Global.DM)
                Archive = updateArchive(Archive, i, 2 * Global.N);

                Offsprings = [Offsprings, Offspring];
            elseif dominated(i.objs, Offspring.objs, Global.DM)
                Archive = updateArchive(Archive, Offspring, 2 * Global.N);
                Offsprings = [Offsprings, i];
            else
                Offsprings = [Offsprings, Offspring, i];
            end


        end

        [Population, FrontNo, CrowdDis] = EnvironmentalSelection(Offsprings, Global.N, Global.DM);
        Archive = updateArchive(Archive, setdiff(Offsprings, Population), 2 * Global.N);
        temp = Population.adds(zeros(length(Population), 2));
        S_CR = temp(:, 1);
        S_F = temp(:, 2);
        S_CR = S_CR(S_CR ~= 0);
        S_F = S_F(S_F ~= 0);


        if ~isempty(S_CR)
            mu_CR = (1 - c) * mu_CR + c * mean(S_CR);
        end

        if ~isempty(S_F)
            mu_F = (1 - c) * mu_F + c * mean_Lehmer(S_F);
        end
    end

end

function result = mean_Lehmer(F)
    result = sum(F.^2);
    result = result / sum(F);
end

function Archive = updateArchive(Archive, Population, N)

    for i = Population

        if length(Archive) < N
            Archive = [Archive, i];
        else
            decs = Archive.decs;
            dec = i.decs;
            dis = pdist2(decs, dec);
            [~, index] = min(dis);
            Archive(index) = i;
        end

    end

end


