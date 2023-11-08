function result=bothHV(Population,optimum,DM)
[~,M]=size(Population);
result = [];
    for i=1:DM
        result=[result;HV(Population(:,(i-1)*(M/DM)+1:i*(M/DM)),optimum(:,(i-1)*(M/DM)+1:i*(M/DM)))];
    end
end