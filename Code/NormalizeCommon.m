%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NormalizeCommon function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Nvector = NormalizeCommon(vector, lower, upper)

if nargin < 2
    upper = 1;
    lower = -1;
end

Nvector = vector * nan;
idx = find(~isnan(vector) & ~isinf(vector));
Nvector(idx) = ...
    lower +  ( (upper - lower) * ( vector(idx) -  min(vector(idx)) ) )...
    / ( max(vector(idx))- min(vector(idx)) );

end
