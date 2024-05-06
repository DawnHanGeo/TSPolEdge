
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