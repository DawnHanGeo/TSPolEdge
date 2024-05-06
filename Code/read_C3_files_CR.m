function C3_3D = read_C3_files_CR(inpath, CR)

if ispc
    dsp = '\';
else
    dsp = '/';
end

[NrowOri, NcolOri] = read_Nrow_Ncol_config([inpath, dsp, 'config.txt']);
chan = 6;

if ~isempty(CR)
    r1 = CR(1); r2 = CR(2); c1 = CR(3); c2 = CR(4);
else
    r1 = 1; r2 = NrowOri; c1 = 1; c2 = NcolOri;
end

Nrow = r2 - r1 + 1;
Ncol = c2 - c1 + 1;
     
C3_3D = zeros(Nrow, Ncol, chan);  % C11, C22, C33, C12, C13,  C23
C11 = freadbk_windows([inpath, dsp, 'C11.bin'], NrowOri, 'float32', r1, r2, c1, c2); C3_3D(:,:,1) = C11; clear C11;
C22 = freadbk_windows([inpath, dsp, 'C22.bin'], NrowOri, 'float32', r1, r2, c1, c2); C3_3D(:,:,2) = C22; clear C22;
C33 = freadbk_windows([inpath, dsp, 'C33.bin'], NrowOri, 'float32' , r1, r2, c1, c2); C3_3D(:,:,3) = C33; clear C33;
C12_real = freadbk_windows([inpath, dsp, 'C12_real.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C12_imag = freadbk_windows([inpath, dsp, 'C12_imag.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C3_3D(:,:, 4) = complex(C12_real, C12_imag); clear C12_real C12_imag;
clear C12_real C12_imag;
C13_real = freadbk_windows([inpath, dsp, 'C13_real.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C13_imag = freadbk_windows([inpath, dsp, 'C13_imag.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C3_3D(:,:,5) = complex(C13_real, C13_imag); 
clear C13_real C13_imag;
C23_real = freadbk_windows([inpath, dsp, 'C23_real.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C23_imag = freadbk_windows([inpath, dsp, 'C23_imag.bin'], NrowOri, 'float32', r1, r2, c1, c2); 
C3_3D(:,:,6) = complex(C23_real, C23_imag); 
clear C23_real C23_imag;


end