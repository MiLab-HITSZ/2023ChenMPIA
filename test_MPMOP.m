clear
delete(gcp('nocreate'));
parpool('local',30);
addpath(genpath(fileparts(mfilename('fullpath'))));%add path
ANS_IGD_mean = []
ANS_IGD_std = []
ANS_Num_mean = []
ANS_Num_std = []
ANS_HV_mean = []
ANS_HV_std = []
SLIST={};
tic;
for dim=30
    IGD_mean = [];
    IGD_std = [];
    Num_mean = [];
    Num_std = [];
    HV_mean = [];
    HV_std = [];
    popsize = 105;
    itermax = 1000;
    test_case={
        @OptAll,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @OptAll,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @OptAll,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @OptAll,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @OptAll,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @OptAll,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS2,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @OptMPNDS2,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS2,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS2,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS2,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @OptMPNDS2,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @MPNNIA,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @MPNNIA,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @MPNNIA,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @MPNNIA,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @MPNNIA,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @MPNNIA,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @MPHEIA,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @MPHEIA,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @MPHEIA,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @MPHEIA,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @MPHEIA,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @MPHEIA,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @MPAIMA,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @MPAIMA,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @MPAIMA,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @MPAIMA,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @MPAIMA,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @MPAIMA,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        % @MPIA,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        % @MPIA,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        % @MPIA,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        % @MPIA,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        % @MPIA,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        % @MPIA,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        @MPIA2,@MPMOP1,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP2,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP3,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP4,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP5,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP6,popsize,1,1,itermax*dim*2,dim;
        @MPIA2,@MPMOP7,popsize,1,1,itermax*dim*3,dim;
        @MPIA2,@MPMOP8,popsize,1,1,itermax*dim*3,dim;
        @MPIA2,@MPMOP9,popsize,1,1,itermax*dim*3,dim;
        @MPIA2,@MPMOP10,popsize,1,1,itermax*dim*3,dim;
        @MPIA2,@MPMOP11,popsize,1,1,itermax*dim*3,dim;
        };
    for i=1:size(test_case,1)
        time=toc ;
        fprintf("%d/%d DIM:%d TIME:%f \n",i,size(test_case,1),dim,time);
        Score=[];
        for j=0
            spmd(30)
                %display(labindex);
                s = RandStream.create('mrg32k3a','NumStreams',30,'StreamIndices',labindex);
                RandStream.setGlobalStream(s);
                result=CALRUN('-algorithm',test_case{i,1},'-problem',test_case{i,2},'-N',test_case{i,3},'-save',test_case{i,4},'-run',test_case{i,5}, ...,
                    '-evaluation',test_case{i,6},'-D',test_case{i,7});
            end
            result=  cat(1, result{1:end});
            Score=[Score;result];
        end
        SLIST{i}=Score;
        result_mean=mean(Score);
        result_std=std(Score);
        IGD_mean(i) = result_mean(1);
        IGD_std(i) = result_std(1);
        Num_mean(i) = result_mean(3);
        Num_std(i) = result_std(3);
        HV_mean(i) = result_mean(4);
        HV_std(i) = result_std(4);
    end
    ANS_IGD_mean = [ANS_IGD_mean;reshape(IGD_mean,11,[])]
    ANS_IGD_std = [ANS_IGD_std;reshape(IGD_std,11,[])]
    ANS_Num_mean = [ANS_Num_mean;reshape(Num_mean,11,[])]
    ANS_Num_std = [ANS_Num_std;reshape(Num_std,11,[])]
    ANS_HV_mean = [ANS_HV_mean;reshape(HV_mean,11,[])]
    ANS_HV_std = [ANS_HV_std;reshape(HV_std,11,[])]
end
%%
[~,temp1]=min(ANS_IGD_mean,[],2)
win_IGD = sum(temp1==7)
[~,temp2]=max(ANS_Num_mean,[],2)
win_NUM = sum(temp2==7)
[~,temp3]=max(ANS_HV_mean,[],2)
win_HV = sum(temp3==7)
%% IGD
WXres1=zeros(11,7,3);
for i = 1:11
    TEMP =[];
    for j = 1:7
        TEMP=[TEMP SLIST{(j-1)*11+i}(:,1)];
    end
    for al = 1:6
        diff = ranksum(TEMP(:,al),TEMP(:,end))<0.1;
        if diff
            if mean(TEMP(:,al))>mean(TEMP(:,end))
                WXres1(i,al,1)=WXres1(i,al,1)+1;
            else
                WXres1(i,al,3)=WXres1(i,al,3)+1;
            end
        else
            WXres1(i,al,2)=WXres1(i,al,2)+1;
        end
    end
end
%% HV
WXres2=zeros(11,7,3);
for i = 1:11
    TEMP =[];
    for j = 1:7
        TEMP=[TEMP SLIST{(j-1)*11+i}(:,4)];
    end
    for al = 1:6
        diff = ranksum(TEMP(:,al),TEMP(:,end))<0.1;
        if diff
            if mean(TEMP(:,al))<mean(TEMP(:,end))
                WXres2(i,al,1)=WXres2(i,al,1)+1;
            else
                WXres2(i,al,3)=WXres2(i,al,3)+1;
            end
        else
            WXres2(i,al,2)=WXres2(i,al,2)+1;
        end
    end
end