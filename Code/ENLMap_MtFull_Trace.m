%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: ENLMap_MtFull_Trace.m
%
%   Description: the trace moment-based estimator of ENL
%
%   Input:  (1) C3_3D: the C3 data with 3D format (Nrow * Ncol * 6: C11,C22,C33,C12,C13,C23)
%           (2) L: the look
%           (3) w: the window
%
%   Output: (1) ENL: the ENL map
%
%   Reference: [1] Anfinsen, Stian Normann, Anthony P. Doulgeris, and Torbj?rn Eltoft.
%               "Estimation of the equivalent number of looks in polarimetric synthetic aperture radar imagery.
%               " IEEE Transactions on Geoscience and Remote Sensing 47.11 (2009): 3795-3809.
%              [2] Xiang, Deliang, et al. "Adaptive superpixel generation for polarimetric SAR images with local iterative clustering and SIRV model."
%               IEEE Transactions on Geoscience and Remote Sensing 55.6 (2017): 3115-3131.
%              [3] Shen, P.; Wang, C.; Fu, H.; Zhu, J.; Hu, J. Estimation of Equivalent Number of Looks in Time-Series Pol(In)SAR Data. Remote Sens. 2020, 12, 2715.
%
%   Date: 2020/12/01
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ENL = ENLMap_MtFull_Trace(C3_4D, w, EachNum)
[Nrow, Ncol, ~,nt] = size(C3_4D);
IndList = ConvIndCal(Nrow, Ncol, w);

for t = 1:nt
    C11 = squeeze(C3_4D(:,:,1,t));
    C22 = squeeze(C3_4D(:,:,2,t));
    C33 = squeeze(C3_4D(:,:,3,t));
    C12 = squeeze(C3_4D(:,:,4,t));
    C13 = squeeze(C3_4D(:,:,5,t));
    C23 = squeeze(C3_4D(:,:,6,t));
    
    C3_Local = zeros(6,Nrow*Ncol,w^2);
    C3_Local(1,:,:) = C11(IndList); clear C11;
    C3_Local(2,:,:) = C22(IndList); clear C22;
    C3_Local(3,:,:) = C33(IndList); clear C33;
    C3_Local(4,:,:) = C12(IndList); clear C12;
    C3_Local(5,:,:) = C13(IndList); clear C13;
    C3_Local(6,:,:) = C23(IndList); clear C23;
    
    % C3_Local = C3_Local;
    
    % indivd the C3_Local into multiple sections
    Num = floor((Nrow*Ncol) / EachNum);
    NumList = EachNum:EachNum:EachNum*Num;
    NumStartList = [1;NumList(:)+1];
    NumEndList = [NumList(:);Nrow*Ncol];
    lNum = length(NumEndList);
    for i = 1:lNum
        
        C3_Local_each = C3_Local(:,NumStartList(i):NumEndList(i),:);
        C3_mean = squeeze(mean(C3_Local_each,3));
        d1 = sum(C3_mean(1:3,:),1);
        d1 = d1.^2;
        CC2 = squeeze(sum(C3_Local_each(1:3,:,:).^2,1) +  sum( 2 *(C3_Local_each(4:6,:,:) .* conj(C3_Local_each(4:6,:,:))) ,1));
        d2 = squeeze(mean( CC2  ,2));
        d3 = squeeze(sum(C3_mean(1:3,:).^2, 1) + sum(2 *(C3_mean(4:6,:) .* conj(C3_mean(4:6,:)) ),1) );
        
        if i == 1
            d1Total = d1(:);
            d2Total = d2(:);
            d3Total = d3(:);
        else
            d1Total = [d1Total;d1(:)];
            d2Total = [d2Total;d2(:)];
            d3Total = [d3Total;d3(:)];
        end
    end
    
    if t == 1
        d1sum =  d1Total(:);
        d2sum =  d2Total(:);
        d3sum =  d3Total(:);
    else
        d1sum = d1sum + d1Total(:);
        d2sum = d2sum + d2Total(:);
        d3sum = d3sum + d3Total(:);
    end
    
end
clear d1Total d2Total d3Total;
ENL = d1sum(:) ./ (d2sum(:) - d3sum(:));
ENL = real(reshape(ENL, [Nrow, Ncol]));
% figure;imagesc(real(ENL));

end


