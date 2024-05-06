%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: SRW_C4_Normal.m
%
%   Description: SRW distance calculation based on the C4_3D.mat, the C4
%                means the dual-pol Pol-InSAR covariance matrix 
%
%   Input:  (1) C4_1: the 3D C4 matrix of the first region, [Nrow, Ncol, 10], 
%               C11, C22, C33, C44, C12, C13, C14, C23, C24, C34
%           (2) C4_2: the 3D C4 matrix of the second region, [Nrow,Ncol,10]
%           (3) C4_inv_1: the inverse 3D C4 matrix of the first region, [Nrow, Ncol, 10]
%           (4) C4_inv_2: the inverse 3D C4 matrix of the second region, [Nrow, Ncol, 10]
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
function d = SRW_C4_Normal(C4_1, C4_2, C4_inv_1, C4_inv_2, m)

[r1, c1, chan] = size(C4_1);
[r2, c2, chan] = size(C4_2);

n1 = r1 * c1;
n2 = r2 * c2;

C4_1 = reshape(C4_1, [n1, chan]);
C4_2 = reshape(C4_2, [n2, chan]);
C4_inv_1 = reshape(C4_inv_1, [n1, chan]);
C4_inv_2 = reshape(C4_inv_2, [n2, chan]);

tmp = [1,1,1,1,2,2,2,2,2,2];
tmp = repmat(tmp, n2, 1);

d = sum((real(C4_inv_1 .* conj(C4_2)) .* tmp +  real(C4_inv_2 .* conj(C4_1)).*tmp), 2);
d = 0.5*d - m;
d = abs(real(d));

% d(d<0) = 0;

d = reshape(d, [r2, c2]);

end