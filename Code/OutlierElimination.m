%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OutlierElimination function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: OutlierElimination.m
%
%   Description: elimination of outlier for feature map based on the
%                boxplot method.
%
%   Input:  (1) Feature2D: the original feature
%
%   Output:  (1) Feature2DResult: the resulting Feature2DResult
%
%   Author: GaoHan
%
%   Date: 2020/05/22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Feature2DResult = OutlierElimination(Feature2D, method)
[UpThre,LowThre] = BoxPlotCalOutliers(Feature2D(:));
[Nrow, Ncol] = size(Feature2D);

Feature2Dtmp = Feature2D;

switch method
    case 'max'
        Feature2Dtmp(Feature2D > UpThre) = UpThre;
        Feature2DResult = Feature2Dtmp;
    case 'min'
        Feature2Dtmp(Feature2D < LowThre) = LowThre;
        Feature2DResult = Feature2Dtmp;
    case 'maxmin'
        Feature2Dtmp(Feature2D > UpThre) = UpThre;
        Feature2Dtmp(Feature2D < LowThre) = LowThre;
        Feature2DResult = Feature2Dtmp;
        
    case 'average'
        [idxRow, idxCol] = find(Feature2D > UpThre);

        wsize = 3;
        radius = (wsize - 1) / 2;
        Nidx = length(idxRow);
        Feature2Dtmp(Feature2D > UpThre) = nan;
        
        Feature2DNew = zeros(Nrow+2*radius, Ncol+2*radius);
        Feature2DNew = Feature2DNew * nan;
        Feature2DNew(radius+1:end-radius,radius+1:end-radius) = Feature2Dtmp;
        clear Feature2Dtmp;
        for i = 1:Nidx
            crow = idxRow(i)+radius;
            ccol = idxCol(i)+radius;
            
            region = Feature2DNew(crow-radius:crow+radius,ccol-radius:ccol+radius);
            Feature2DNew(crow,ccol) = mean(region(:),'omitnan');
        end
        
        Feature2DResult = Feature2DNew(radius+1:end-radius,radius+1:end-radius);
end

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BoxPlotCalOutliers subfunction
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [UpThre,LowThre] = BoxPlotCalOutliers(V)

V = V(~isnan(V) & ~isinf(V));

Vsort = sort(V);
N = length(Vsort);

% the 25th percentiles point
N1 = (N + 1) / 4;

if N1 == floor(N1)
    Q1 = Vsort(N1);
else
    N1 = floor(N1);
    Q1 = 0.25 * Vsort(N1) + 0.75 * Vsort(N1+1);
end

% the median 
N2 = 2 * (N + 1) / 4;

if N2 == floor(N2)
    Q2 = Vsort(N2);
else
    N2 = floor(N2);
    Q2 = 0.5 * Vsort(N2) + 0.5 * Vsort(N2+1);
end

% the 75th percentiles point
N3 = 3 * (N + 1) / 4;

if N3 == floor(N3)
    Q3 = Vsort(N3);
else
    N3 = floor(N3);
    Q3 = 0.75 * Vsort(N3) + 0.25 * Vsort(N3+1);
end

% calculate the threshold
% the '3' determine the extreme outlier point
% the '1.5' determine the mild outlier point
IQR = Q3 - Q1;
UpThre = Q3 + 3 * IQR;
LowThre = Q1 - 3 * IQR;

end
