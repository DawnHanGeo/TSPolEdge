%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: SRW_C3_Normal.m
%
%   Description: SRW distance calculation based on the C4_3D.mat
%
%   Input:  (1) C3_1: the 3D C3 matrix of the first region, [Nrow, Ncol, 10], 
%               C11, C22, C33, C44, C12, C13, C14, C23, C24, C34
%           (2) C3_2: the 3D C3 matrix of the second region, [Nrow,Ncol,10]
%           (3) C3_inv_1: the inverse 3D C3 matrix of the first region, [Nrow, Ncol, 10]
%           (4) C3_inv_2: the inverse 3D C3 matrix of the second region, [Nrow, Ncol, 10]
%           (5) m: the number of polarizaition channels
%
%   Output: (1) d: the SRW distance map
%
%  Reference: Xiang, Deliang, et al. "Adaptive superpixel generation for polarimetric SAR
%            images with local iterative clustering and SIRV model."
%            IEEE Transactions on Geoscience and Remote Sensing 55.6 (2017): 3115-3131.
%
%   Date: 2021/7/7
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = SRW_C3_Normal(C3_1, C3_2, C3_inv_1, C3_inv_2, m)

[r1, c1, chan] = size(C3_1);
[r2, c2, chan] = size(C3_2);

n1 = r1 * c1;
n2 = r2 * c2;

C3_1 = reshape(C3_1, [n1, chan]);
C3_2 = reshape(C3_2, [n2, chan]);
C3_inv_1 = reshape(C3_inv_1, [n1, chan]);
C3_inv_2 = reshape(C3_inv_2, [n2, chan]);

tmp = [1,1,1,2,2,2];
tmp = repmat(tmp, n1, 1);

d = sum((real(C3_inv_1 .* conj(C3_2)) .* tmp +  real(C3_inv_2 .* conj(C3_1)).*tmp), 2);
d = 0.5*d - m;
d = real(d);

% d(d<0) = 0;

d = reshape(d, [r2, c2]);

end