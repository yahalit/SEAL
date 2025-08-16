function ert_make_rtw_hook(hookMethod, modelName, rtwroot, tmf, buildOpts, buildArgs) %#ok<*INUSD>
switch hookMethod
    case 'entry'        % very start of build
        myPreCodeGen(modelName);
    % case 'before_tlc'   % right before TLC generates code
    %     myPreCodeGen(modelName);
    % other cases: 'before_tlc' ,'after_tlc', 'before_make', 'after_make', 'exit'
end
end

function myPreCodeGen(mdl)
    % your pre-processing here
    bd = RTW.getBuildDir(mdl);
    disp("Pre-codegen for " + mdl + " in " + bd.BuildDirectory);
    % e.g., validate SLDD, generate headers, tweak params, etc.
end