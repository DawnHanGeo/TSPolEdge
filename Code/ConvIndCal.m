%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ConvIndCal function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fast conv indices generation
function IndList = ConvIndCal(Nrow, Ncol, w)

rtmp = 1:Nrow;
RowMat = repmat(rtmp', 1, Ncol);

ctmp = 1:Ncol;
ColMat = repmat(ctmp, Nrow, 1);

RowTotal = zeros(Nrow, Ncol, w^2);
ColTotal = zeros(Nrow, Ncol, w^2);

delta = 1:w;
delta = delta - ( (w - 1)/2 + 1);
k = 1;
for i = 1:w
    for j = 1:w
       dr = delta(i);
       dc = delta(j);
       ermat = RowMat + dr;
       ecmat = ColMat + dc;
       
       ermat(ermat <= 0) = 1;
       ermat(ermat > Nrow) = Nrow;
       ecmat(ecmat <= 0) = 1;
       ecmat(ecmat > Ncol) = Ncol;
       
       RowTotal(:,:,k) = ermat;
       ColTotal(:,:,k) = ecmat;
       
        k = k + 1;        
    end
end

IndList = zeros(Nrow*Ncol, w^2);
for i = 1:w^2
    erlist = reshape(squeeze(RowTotal(:,:,i)), [Nrow*Ncol, 1]);
    eclist = reshape(squeeze(ColTotal(:,:,i)), [Nrow*Ncol, 1]);
    IndList(:,i) = sub2ind([Nrow, Ncol], erlist, eclist);
end
IndList = round(IndList);
end