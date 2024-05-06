%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: SRW_C6_Normal.m
%
%   Description: SRW distance calculation based on the C6_3D.mat
%
%   Input:  (1) C6_1: the 3D C6 matrix of the first region, [Nrow, Ncol, 21], 
%               C11, C22, C33, C44, C55, C66, C12, C13, C14, C15, C16, 
%               C23, C24, C34, C35, C36, C45, C46, C56.
%           (2) C6_2: the 3D C6 matrix of the second region, [Nrow,Ncol,21]
%           (3) C6_inv_1: the inverse 3D C6 matrix of the first region, [Nrow, Ncol, 21]
%           (4) C6_inv_2: the inverse 3D C6 matrix of the second region, [Nrow, Ncol, 21]
%           (5) m: the number of polarizaition channels
%
%   Output: (1) d: the SRW distance map
%
%  Reference: Xiang, Deliang, et al. "Adaptive superpixel generation for polarimetric SAR
%            images with local iterative clustering and SIRV model."
%            IEEE Transactions on Geoscience and Remote Sensing 55.6 (2017): 3115-3131.
%
%   Date: 2021/7/14
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = SRW_C6_Normal(C6_1, C6_2, C6_inv_1, C6_inv_2, m)
[r1, c1, chan] = size(C6_1);
[r2, c2, chan] = size(C6_2);

n1 = r1 * c1;
n2 = r2 * c2;


C6_1 = reshape(C6_1, [n1, chan]);
C6_2 = reshape(C6_2, [n2, chan]);
C6_inv_1 = reshape(C6_inv_1, [n1, chan]);
C6_inv_2 = reshape(C6_inv_2, [n2, chan]);

tmp = [ones(1,6), 2.*ones(1,15)];
tmp = repmat(tmp, n2, 1);
% C6_1 = repmat(C6_1, n2, 1);
% C6_inv_1 = repmat(C6_inv_1, n2, 1);
d = sum((real(C6_inv_1 .* conj(C6_2)) .* tmp +  real(C6_inv_2 .* conj(C6_1)).*tmp), 2);
d = 0.5*d - m;
d = real(d);
d(d<0) = 0;
d = reshape(d, [r2, c2]);


end