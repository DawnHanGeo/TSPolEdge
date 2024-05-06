%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: TSPol_PolSta_Enhance.m
%
%   Description: TS Polarmetric Stationary Enhancement Procedure
%
%   Input:  (1) PolSta: the original polarimetric stationary
%           (2) template: the template cell 
%           (3) templateiner: the iner template cell 
%           (4) beita: the weight of iner 
%
%   Output: (1) PolStaEn: the enhanced polsta
%
%   Date: 2021/10/29
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PolStaEn] = TSPol_PolSta_Enhance(PolSta, template,templateiner, beita)

%% input C3_3D
[Nrow, Ncol] = size(PolSta);

%% input template
NT = length(template); 

%% calculate edge
GradSta = zeros(NT, Nrow, Ncol);
            
for i = 1:NT
    etemp = squeeze(template{i});
    [temp1, temp2] = TempSeparation(etemp);
    n1 = sum(temp1(temp1 ~= 0));
    n2 = sum(temp2(temp2 ~= 0));
    tempiner = templateiner{i};
    niner = sum(tempiner(tempiner ~= 0));
    
    PolSta1 = imfilter(PolSta, temp1, 'corr', 'symmetric', 'same'); PolSta1 = PolSta1./n1;
    PolSta2 = imfilter(PolSta, temp2, 'corr', 'symmetric', 'same'); PolSta2 = PolSta2./n2;
    PolStainer = imfilter(PolSta, tempiner, 'corr', 'symmetric', 'same'); PolStainer = PolStainer./niner;
    
    PolSta1(isnan(PolSta1) | isinf(PolSta1)) = min( PolSta1(~isnan(PolSta1) & ~isinf(PolSta1)));
    PolSta2(isnan(PolSta2) | isinf(PolSta2)) = min( PolSta2(~isnan(PolSta2) & ~isinf(PolSta2)));
    
    PolStamin = min(PolSta1, PolSta2);
    maxvalue = max([PolStainer(:); PolStamin(:)]);
    minvalue = min([PolStainer(:); PolStamin(:)]);
    PolStainer = NormalizeCommonAdapative(PolStainer, 0, 1, maxvalue, minvalue);
    PolStamin = NormalizeCommonAdapative(PolStamin, 0, 1, maxvalue, minvalue);
    PolStatmp = exp(beita .* PolStainer.^2 ./ PolStamin);            
    GradSta(i,:,:) = PolStatmp;
end

PolStaEn = squeeze(max(GradSta));

end      

%% subfunction: TempSeparation
% description: divide one template into two individual templates
function [temp1, temp2] = TempSeparation(etemp)

parcel = bwlabel(etemp, 4);
uind = unique(parcel(:));
uind(uind == 0) = [];
luind = length(uind);

if luind > 2
    error('the number of parcels should be not larger than 2!');
end

temp1 = etemp*0;
temp2 = etemp*0;
temp1(parcel == uind(1)) = etemp(parcel == uind(1));
temp2(parcel == uind(2)) = etemp(parcel == uind(2));

end


