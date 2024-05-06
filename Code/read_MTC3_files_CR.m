function C3_4D = read_MTC3_files_CR(TrackPath, DateListStr, CR)

if ispc
    dsp = '\';
else
    dsp = '/';
end

Nt = length(DateListStr);
chan = 6;

for i = 1:Nt
   edate = DateListStr{i};
   epath = [TrackPath, dsp, edate, dsp, 'C3'];
   
   if i == 1
      [Nrow,Ncol,~,~] = read_Nrow_Ncol_config([epath, dsp, 'config.txt']);
      if ~isempty(CR)
          Nrow = CR(2) - CR(1) + 1;
          Ncol = CR(4) - CR(3) + 1;
      end
      C3_4D = zeros(Nrow, Ncol, chan, Nt);
   end
   
   C3_3D = read_C3_files_CR(epath, CR);
   C3_4D(:,:,:,i) = C3_3D;

end

end