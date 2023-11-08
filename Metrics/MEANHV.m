function result=MEANHV(Population,optimum,DM)
[~,M]=size(Population);
result = 0;
    for i=1:DM
        result=result+HV(Population(:,(i-1)*(M/DM)+1:i*(M/DM)),optimum(:,(i-1)*(M/DM)+1:i*(M/DM)));
    end
result = result;
end