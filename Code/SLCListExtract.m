%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SLCListExtract  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SLCList = SLCListExtract(TrackPath, SLCListFile)
if ispc
    dsp = '\';
else
    dsp = '/';
end

if nargin < 2
    SLCListFile = nan;
end

if isnan(SLCListFile)
    d = dir(TrackPath);
    isub = [d(:).isdir]; % returns logical vector
    SLCList = {d(isub).name}';
    SLCList(ismember(SLCList,{'.','..'})) = [];
else
    SLCList = textread([TrackPath, dsp, SLCListFile], '%s');
end


end