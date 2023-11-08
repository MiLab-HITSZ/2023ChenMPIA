%clear
%close all
addpath(genpath(fileparts(mfilename('fullpath'))));%add path
ANS_IGD_mean = []
ANS_IGD_std = []
ANS_Num_mean = []
ANS_Num_std = []
ANS_HV_mean = []
ANS_HV_std = []
tic;
for dim=30:10:30
    IGD_mean = [];
    IGD_std = [];
    Num_mean = [];
    Num_std = [];
    HV_mean = [];
    HV_std = [];
    popsize = 105;
    itermax = 1000;
    test_case={
        @MPIA2,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP9,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        % @MPIA2,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        % @MPIA2,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        % @MPIA2,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        % @MPIA2,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        % @MPIA2,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        };
    for i=1:size(test_case,1)
        %for k=1:30
            time=toc ;
            fprintf("%d/%d DIM:%d TIME:%f \n",i,size(test_case,1),dim,time);
            s = RandStream.create('mrg32k3a','NumStreams',30,'StreamIndices',1);
            RandStream.setGlobalStream(s);
            if i > 11
                tttt = 100+i;
            else
                tttt = i;
            end
            result=CALRUN('-algorithm',test_case{i,1},'-problem',test_case{i,2},'-N',test_case{i,3},'-save',test_case{i,4},'-run',test_case{i,5}, ...,
                '-evaluation',test_case{i,6},'-D',test_case{i,7},'-showresult',1,'-showfig',tttt);
            IGD_mean(i) = result(1);
            Num_mean(i) = result(3);
            HV_mean(i) = result(4);
        %end
    end
    ANS_IGD_mean = [ANS_IGD_mean;reshape(IGD_mean,11,[])]
    ANS_Num_mean = [ANS_Num_mean;reshape(Num_mean,11,[])]
    ANS_HV_mean = [ANS_HV_mean;reshape(HV_mean,11,[])]
end