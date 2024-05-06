%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: SRW_C2_Normal.m
%
%   Description: SRW distance calculation based on the C2_3D.mat
%
%   Input:  (1) C2_1: the 3D C2 matrix of the first region, [Nrow, Ncol, 3], C11, C22, C12,
%           (2) C2_2: the 3D C2 matrix of the second region, [Nrow, Ncol, 3], C11, C22, C12,
%           (3) C2_inv_1: the inverse 3D C2 matrix of the first region, [Nrow, Ncol, 3], C11, C22, C12,
%           (4) C2_inv_2: the inverse 3D C2 matrix of the second region, [Nrow, Ncol, 3], C11, C22, C12,
%           (5) m: the number of polarizaition channels
%
%   Output: (1) d: the SRW distance map
%
%  Reference: Xiang, Deliang, et al. "Adaptive superpixel generation for polarimetric SAR
%            images with local iterative clustering and SIRV model."
%            IEEE Transactions on Geoscience and Remote Sensing 55.6 (2017): 3115-3131.
%
%   Date: 201/7/7
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = SRW_C2_Normal(C2_1, C2_2, C2_inv_1, C2_inv_2, m)

[r1, c1, chan] = size(C2_1);
[r2, c2, chan] = size(C2_2);

n1 = r1 * c1;
n2 = r2 * c2;


C2_1 = reshape(C2_1, [n1, chan]);
C2_2 = reshape(C2_2, [n2, chan]);
C2_inv_1 = reshape(C2_inv_1, [n1, chan]);
C2_inv_2 = reshape(C2_inv_2, [n2, chan]);


tmp = [1,1,2];
tmp = repmat(tmp, n1, 1);

d = sum((real(C2_inv_1 .* conj(C2_2)) .* tmp +  real(C2_inv_2 .* conj(C2_1)).*tmp), 2);
d = 0.5*d - m;
d = real(d);

% d(d<0) = 0;

d = reshape(d, [r2, c2]);


end