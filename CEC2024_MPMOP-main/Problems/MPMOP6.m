classdef MPMOP6< handle
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
        function obj = MPMOP6(D)
            obj.calcount=0;
            obj.M = 6;
            obj.D = D;
            obj.DM=2;
            obj.maxFE=1000*obj.D*obj.DM;
            obj.lower    =  ones(1,obj.D).*(-1);
            obj.upper    = ones(1,obj.D);
            obj.lower([1:2])=0;
            obj.encoding = 'real';
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)
            M=obj.M;
            assert(obj.calcount<=obj.maxFE, "Maximum number of evaluations exceeded.");
            PopObj(:,[1:M/2])=MPMOP_Value('MPMOP6', PopDec(), 0);
            PopObj(:,[M/2+1:M])=MPMOP_Value('MPMOP6', PopDec(), 1);
            obj.calcount = obj.calcount + size(PopDec,1);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1=0;
            t2=1;
            [~,true_y1,true_y2]=true_PS(obj.D,'MPMOP6',t1,t2);
            P=[true_y1,true_y2];
        end

        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            t1=0;
            t2=1;
            P=true_PS(obj.D,'MPMOP6',t1,t2);
        end
        
    end
end