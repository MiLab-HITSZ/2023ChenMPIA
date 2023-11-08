function [C,FL,F,indexlist] = Cloning(A,nC,FrontNo_low,FrontNo)
    %% Calculate the crowding distance of each solution
    PopObj=A.objs;
    [PopObj,~,Loc] = unique(PopObj,'rows');
    CrowdDis = CrowdingDistance(PopObj,FrontNo);   
    CrowdDis = CrowdDis(Loc);
    if all(CrowdDis==inf)
        CrowdDis = ones(size(CrowdDis));
    else
        CrowdDis(CrowdDis==inf) = 2*max(CrowdDis(CrowdDis~=inf));
    end
    CrowdDis = CrowdDis + (max(FrontNo)-FrontNo);
    %% Clone
    q = ceil(nC*CrowdDis/sum(CrowdDis));
    C = [];
    FL = [];
    F = [];
    indexlist=[];
    
    for i = 1 : length(A)
        C = [C,repmat(A(i),1,q(i))];
        indexlist = [indexlist,repmat(i,1,q(i))];
        FL = [FL;repmat(FrontNo_low(i,:),q(i),1)];
        F = [F;repmat(FrontNo(i),q(i),1)];
    end
end