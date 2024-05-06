%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: C3_inv_fast.m
%   Author: Wang Guanya
%   Description: C3 inv fast
%   Date: 2021/07/06
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C3_inv, C3_abs] = C3_inv_fast_Normal(C3_3D)

%% Input:
%  (1) C3: 3-D matrix [Nrow,Ncol,6]
%          C11,    C22,    C33, 
%          C12,    C13,    C23,
%% Output:
%  (1) C3_inv: 3-D matrix [Nrow,Ncol,6]


%% Input parameters
[Nrow, Ncol, ~] = size(C3_3D);

a = C3_3D(:,:,1);  % C11
b = C3_3D(:,:,2);  % C22
c = C3_3D(:,:,3);  % C33
e = real(C3_3D(:,:,4));  % C12_real
f = imag(C3_3D(:,:,4));  % C12_imag
g = real(C3_3D(:,:,5));  % C13_real
h = imag(C3_3D(:,:,5));  % C13_imag
l = real(C3_3D(:,:,6));  % C23_real
k = imag(C3_3D(:,:,6));  % C23_imag

clear C3_3D;


%% Determinant
C3_abs = a.*b.*c + 2.*( e.*l.*g - f.*k.*g + f.*l.*h + e.*k.*h )+...
         -b.*(g.^2+h.^2) - c.*(e.^2+f.^2) - a.*(l.^2+k.^2);

     
%% Inv
% C11 = (b.*c - (l.^2+k.^2))./C3_abs;
% C22 = (a.*c - (g.^2+h.^2))./C3_abs;
% C33 = (a.*b - (e.^2+f.^2))./C3_abs;
% C12 = ((g.*l + h.*k - c.*e) + (g.*k + c.*f - h.*l).*1i)./C3_abs;
% C13 = ((e.*l - f.*k - b.*g) + (b.*h - f.*l - e.*k).*1i)./C3_abs;
% C23 = ((e.*g + f.*h - a.*l) + (a.*k + f.*g - e.*h).*1i)./C3_abs;


C3_inv = zeros(Nrow, Ncol, 6);
C3_inv(:,:,1) = (b.*c - (l.^2+k.^2))./C3_abs;
C3_inv(:,:,2) = (a.*c - (g.^2+h.^2))./C3_abs;
C3_inv(:,:,3) = (a.*b - (e.^2+f.^2))./C3_abs;
C3_inv(:,:,4) = (conj(((g.*l + h.*k - c.*e) + (g.*k + c.*f - h.*l).*1i)./C3_abs));
C3_inv(:,:,5) = (conj(((e.*l - f.*k - b.*g) + (b.*h - f.*l - e.*k).*1i)./C3_abs));
C3_inv(:,:,6) = (conj(((e.*g + f.*h - a.*l) + (a.*k + f.*g - e.*h).*1i)./C3_abs));


end

