%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NormalizeCommonAdapative function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Nvector = NormalizeCommonAdapative(vector, lower, upper, maxValue, minValue)
Nvector = vector * nan;
idx = find(~isnan(vector) & ~isinf(vector));

if nargin < 2
    upper = 1;
    lower = -1;
elseif nargin < 4
    maxValue = max(vector(idx));
    minValue = min(vector(idx));
elseif nargin < 5
    minValue = min(vector(idx));
end


Nvector(idx) = ...
    lower +  ( (upper - lower) * ( vector(idx) -  minValue ) )...
    / ( maxValue - minValue );

end