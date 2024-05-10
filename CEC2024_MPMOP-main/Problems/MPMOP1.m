classdef MPMOP1< handle
    %% Properties  
    properties (SetAccess = immutable)
        M;
        DM;
        lower;
        upper;
        D;
        encoding;
        maxFE;
    end
    
    properties (SetAccess = private)
        calcount;
    end

    methods
        %% Initialization
        function obj = MPMOP1(D)
            obj.calcount=0;
            obj.M = 4;
            obj.D = D;
            obj.DM=2;
            obj.maxFE=1000*obj.D*obj.DM;
            obj.lower    = zeros(1,obj.D);
            obj.upper    = ones(1,obj.D);
            obj.lower (:,1)=1;
            obj.upper(:,1)=4;
            obj.encoding = 'real';
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)         
            M=obj.M;
            assert(obj.calcount<=obj.maxFE, "Maximum number of evaluations exceeded.");
            PopObj(:,[1:M/2])=MPMOP_Value('MPMOP1', PopDec(), 1);
            PopObj(:,[M/2+1:M])=MPMOP_Value('MPMOP1', PopDec(), 2);
            obj.calcount = obj.calcount + size(PopDec,1);
        end

        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1=1;
            t2=2;
            [~,true_y1,true_y2]=true_PS(obj.D,'MPMOP1',t1,t2);
            P=[true_y1,true_y2];
        end
        
        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            t1=1;
            t2=2;
            P=true_PS(obj.D,'MPMOP1',t1,t2);
        end
        
    end
end