classdef MPUAV6< handle
        %% Properties  
        properties (SetAccess = immutable)
            M;
            DM;
            data;
            lower;
            upper;
            D;
            encoding;
            funname;
            maxFE;
            seed;
            nonidealpoint;
        end
        
        properties (SetAccess = private)
            calcount;
        end

        methods
        %% Initialization
        function obj = MPUAV6(seed)
            obj.seed = seed;
            assert(obj.seed<=30 && obj.seed>=1, "The random seed must be an integer in the interval [1,30]");
            data2 = load('data2.mat');
            obj.nonidealpoint=data2.data2{6,seed};
            obj.maxFE = 100000;
            obj.calcount = 0;
            obj.M = 4;
            obj.DM=2;
            obj.data = load('data.mat');
            obj.data = obj.data.data;
            obj.lower = obj.data.lb;
            obj.upper = obj.data.ub;
            obj.D = obj.data.dim;
            obj.encoding = 'real';
            obj.funname={'fuel','distance','distance','noise'};
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)         
            PopObj = zeros(size(PopDec,1),obj.M);
            assert(obj.calcount<=obj.maxFE, "Maximum number of evaluations exceeded.");

            for i =1:size(PopDec,1)
                PopObj(i,:)=obj.Calobj(PopDec(i,:),obj.data);
            end
            obj.calcount = obj.calcount + size(PopDec,1);
        end

        %% Calculate single individual's objective values for each party
        %  When the solution is infeasible, the retrun value is all objective function values plus 
        %  the constraint violation value multiplied by 1e32.

        function [fit,trace_ijz]=Calobj(obj,x,data)
            trace_code =  round(x(1:data.Bound-1));
            for i = 2:length(trace_code)
                actionlist = data.canselect{trace_code(i-1)+data.canselectp};
                maxa = actionlist(end); mina=actionlist(1);
                trace_code(i)=min(max(mina,trace_code(i)),maxa);
            end
            trace_code = [data.S(2) trace_code];
            trace_code = [cumsum(trace_code)];
            trace_code = [trace_code data.E(2)];
            trace_code(trace_code<1)=1;
            trace_code(trace_code>data.map_size(2))=data.map_size(2);
            height_code = x(data.Bound:end);
            trace=[[data.S(1):data.E(1)]' trace_code'];
            trace_heightmin=zeros(1,length(trace));
            trace_height=zeros(1,length(trace));
            risk_die = zeros(1,length(trace));
            risk_money = zeros(1,length(trace));
            noise = zeros(1,length(trace));
            ss= sum(data.populations_risk,'all');
            for i =1:data.Bound
                trace_heightmin(i)=max(data.minh(trace(i,1),trace(i,2)),5);
                trace_height(i)=trace_heightmin(i)+(data.maxh-trace_heightmin(i))*height_code(i);
                h = trace_height(i);
                Cpf=getC_Risk(getR_pf(getV(h,data),data),data.populations_risk(trace(i,1),trace(i,2)),data);
                Cvf=getC_Risk(data.R_vf,data.road_risk(trace(i,1),trace(i,2)),data);
                C_rpd=getC_rpd(h,data);
                risk_die(i)=Cpf+Cvf;
                risk_money(i)=C_rpd;
                noise(i)=data.populations_risk(trace(i,1),trace(i,2))*getNoiseimpact(trace_height(i))/ss;
            end
            trace_xyz=[(trace-1).*data.map_step trace_height'];
            trace_line = trace_xyz(2:end,:)-trace_xyz(1:end-1,:);
            trace_alpha_cos = sum((trace_line(1:end-1,1:2).*trace_line(2:end,1:2)),2)...
                ./(sqrt(sum((trace_line(1:end-1,1:2)).^2,2)).*sqrt(sum((trace_line(2:end,1:2)).^2,2)));
            trace_alpha=[0;acos(trace_alpha_cos)];
            trace_ijz=[trace trace_height'];
            trace_len = sqrt(sum((trace_xyz(1:end-1,:)-trace_xyz(2:end,:)).^2,2));
            trace_height_delta = trace_height(2:end)-trace_height(1:end-1);
            trace_len_xy = sqrt(trace_len'.^2-trace_height_delta.^2);
            trace_beta_tan = trace_height_delta./trace_len_xy;
            trace_beta = atan(trace_beta_tan);
            trace_cos = zeros(size(trace_beta));
            for i = 1:length(trace_cos)
            %     trace_cos(i)=getcos((trace_height(i)+trace_height(i+1))/2,...
            %                 trace_alpha(i),...
            %                 trace_beta(i),...
            %                 data.alpha_trace,...
            %                 data.beta_trace);
                trace_cos(i)=getcos2((trace_height(i)+trace_height(i+1))/2,trace_height_delta(i),data.m/1000,trace_len(i)/data.v);
            end
            
            disMat = min(pdist2(data.IOT_pos*100,trace_xyz),[],2);
            distsum =  sum(disMat);
            cv_dist = sum(max(disMat-500,0));
            
            cv_alpha = sum(max(trace_alpha-data.alpha_trace,0));
            cv_beta = sum(max(abs(trace_beta)-data.beta_trace,0));
            cv_s = sum(max(abs(trace_ijz(2:end,2)-trace_ijz(1:end-1,2))-data.ub(1),0));
            trace_heightsum = sum(abs(trace_height(2:end)-trace_height(1:end-1)));
            tracelensum = sum(trace_len);
            risk_diesum = sum(risk_die);
            risk_moneysum = sum(risk_money);
            alphasum = sum(trace_alpha);
            cosum = sum(trace_cos);
            noise_impactsum = sum(noise);
            fit=[cosum;distsum;risk_diesum;noise_impactsum];
            fit=fit+(cv_alpha+cv_beta+cv_s+cv_dist)*1e32;
        end
        
    end
end