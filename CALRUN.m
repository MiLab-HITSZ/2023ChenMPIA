function Score=CALRUN(varargin)

    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));

    if verLessThan('matlab','7.14')
        error('Fail to execute PlatEMO, since the version of MATLAB is lower than 7.14 (R2012a). Please update the version of your MATLAB software.');
    else        
        Global = GLOBAL(varargin{:});
        Global.Start();        
        Score        =cat(1,Global.score{end,2:end})';  
        Population= MPSELECT(Global.result{2},Global.D,Global.DM);
        hv=MEANHV(Population.objs,max(2*max(Global.problem.PF(),[],1),1),Global.DM);
        Score=[Score hv];
    end
       
end