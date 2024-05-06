function ENL = CoV_PolStaMap_MtDp(PolSta, w)

[Nrow, Ncol] = size(PolSta);
IndList = ConvIndCal(Nrow, Ncol, w);

PolStaLocal = PolSta(IndList);
CVPolSta = std(PolStaLocal') ./ mean(PolStaLocal');

ENL = real(reshape(CVPolSta, [Nrow, Ncol]));

end


