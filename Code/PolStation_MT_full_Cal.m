function PolSta = PolStation_MT_full_Cal(C3_4D, tempiner)

[Nrow, Ncol, chan, nt] = size(C3_4D);
ni = sum(tempiner(tempiner ~= 0));
nti = ni * nt;
det_1 = cell(nt,1);

for t = 1:nt
    C3_3D = squeeze(C3_4D(:,:,:,t));
    C3_3D = imfilter(C3_3D, tempiner, 'corr', 'symmetric', 'same');
    
    if t == 1
        C3_3Dsum = C3_3D;
    else
        C3_3Dsum = C3_3Dsum + C3_3D;
    end
    
    eC3_3D = C3_3D ./ ni;
    
    edet = detC3_Cal(eC3_3D);
    
    det_1{t} = edet;
    
end

C3_3Dave = C3_3Dsum ./ nti;
avedet = detC3_Cal(C3_3Dave);
det_2 = avedet;
PolSta = 1;
for i = 1:nt
    PolSta = PolSta .* (det_1{i} ./ det_2).^ni;
end
end


function det_result = detC3_Cal(C3_3D)
if length(size(C3_3D)) == 2
    C11 = C3_3D(1); C22 = C3_3D(2); C33 = C3_3D(3);
    C12 = C3_3D(4); C13 = C3_3D(5); C23 = C3_3D(6);
    C21 = conj(C12); C31 = conj(C13); C32 = conj(C23);
else
    C11 = C3_3D(:,:,1); C22 = C3_3D(:,:,2); C33 = C3_3D(:,:,3);
    C12 = C3_3D(:,:,4); C13 = C3_3D(:,:,5); C23 = C3_3D(:,:,6);
    C21 = conj(C12); C31 = conj(C13); C32 = conj(C23);
end
det_1 = C11.*C22.*C33 + C12.*C23.*C31 + C13.*C21.*C32;
det_2 = C13.*C22.*C31 + C23.*C32.*C11 + C33.*C12.*C21;

det_result = det_1 - det_2;
det_result = abs(det_result);

end