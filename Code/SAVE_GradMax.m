function SAVE_GradMax(Outpath, GradMax, Gx, Gy)
if ispc
    dsp = '\';
else
    dsp = '/';
end

if ~exist(Outpath, 'dir'), mkdir(Outpath); end

save([Outpath, dsp, 'GradResult.mat'], 'GradMax', 'Gx', 'Gy');


end