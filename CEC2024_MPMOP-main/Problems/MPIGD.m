function Score= MPIGD(PopObj,problem)
PopObj=MPSELECT(PopObj,problem);
PF = problem.PF();
DM = problem.DM;
%%calculate the MPIGD for the result
[~,M]=size(PF);
[row,~]=size(PF);
[col,~]=size(PopObj);
Distance_IGD=zeros(row,col);
%we calculate their distance between real PF and PF for each party, sum
%them,and find the min value for each individual
for i=1:DM
    Distance_IGD = Distance_IGD+pdist2(PF(:,(i-1)*M/DM+1:i*M/DM),PopObj(:,(i-1)*M/DM+1:i*M/DM));
end  
Distance_IGD = min(Distance_IGD,[],2);
Score    = mean(Distance_IGD);
end