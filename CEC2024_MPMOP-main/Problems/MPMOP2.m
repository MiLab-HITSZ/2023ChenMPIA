classdef MPMOP2< handle
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
        function obj = MPMOP2(D)
            
            obj.calcount=0;
            obj.M = 4;
            obj.D = D;
            obj.DM=2;
            obj.maxFE=1000*obj.D*obj.DM;
            obj.lower    =ones(1,obj.D).*(-1);
            obj.upper    = ones(1,obj.D);
            obj.lower(1)=0;
            obj.encoding = 'real';
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)
            M=obj.M;
            assert(obj.calcount<=obj.maxFE, "Maximum number of evaluations exceeded.");
            PopObj(:,[1:M/2])=MPMOP_Value('MPMOP2', PopDec(), 0);
            PopObj(:,[M/2+1:M])=MPMOP_Value('MPMOP2', PopDec(), 3);
            obj.calcount = obj.calcount + size(PopDec,1);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1=0;
            t2=3; 
            [~,true_y1,true_y2]=true_PS(obj.D,'MPMOP2',t1,t2);
            P=[true_y1,true_y2];
        end
        
        %% Sample reference points on Pareto optimal set      
        function P = PS(obj)
            t1=0;
            t2=3;
            P=true_PS(obj.D,'MPMOP2',t1,t2);
        end
        
    end
end