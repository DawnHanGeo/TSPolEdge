function [GradMax, Gx, Gy] = EdgeExtraction_TSPolRMS_ENLWeightSta(C3_4D, ENL,template,tempthetaList)

%% input C3_3D
[Nrow, Ncol, chan, nt] = size(C3_4D);

%% input template
NT = length(template); 

%% calculate edge
Grad = zeros(NT,Nrow, Ncol);

for i = 1:NT
    tic;
    disp(['Orientation ', num2str(i), '\', num2str(NT), '......']);
    etemp = squeeze(template{i});
    [temp1, temp2] = TempSeparation(etemp);
    n1 = sum(temp1(temp1 ~= 0));
    n2 = sum(temp2(temp2 ~= 0));
    
    for t = 1:nt
        C3_3D = squeeze(C3_4D(:,:,:,t));
        C3_1_ori = imfilter(C3_3D, temp1, 'corr', 'symmetric', 'same');
        C3_2_ori = imfilter(C3_3D, temp2, 'corr', 'symmetric', 'same');
        
        C3_1 = C3_1_ori ./ n1;
        C3_2 = C3_2_ori ./ n2;
        
        C3_inv_1 = C3_inv_fast_Normal(C3_1);
        C3_inv_2 = C3_inv_fast_Normal(C3_2);
        ed = SRW_C3_Normal(C3_1, C3_2, C3_inv_1, C3_inv_2, 0);
        
        if t == 1
            dsum = ed.^2;
        else
            dsum = dsum + ed.^2;
        end
        
        if t == 1
            C3_1sum = C3_1_ori;
            C3_2sum = C3_2_ori;
            n1sum = n1;
            n2sum = n2;
        else
            C3_1sum = C3_1sum + C3_1_ori;
            C3_2sum = C3_2sum + C3_2_ori;
            n1sum = n1sum + n1;
            n2sum = n2sum + n2;
        end
        
    end
    
    d1 = sqrt(dsum ./ nt) - 3;
   
   C3_ave_1 = C3_1sum ./ n1sum;
   C3_ave_2 = C3_2sum ./ n2sum;
   C3_inv_1 = C3_inv_fast_Normal(C3_ave_1);
   C3_inv_2 = C3_inv_fast_Normal(C3_ave_2);
   d2 = SRW_C3_Normal(C3_ave_1, C3_ave_2, C3_inv_1, C3_inv_2, 3);
    
    d = (d1 + ENL .* d2) ./ (1 + ENL);
    Grad(i,:,:) = d;
    
    disp('Cost times: ');
    toc;
end


%% PolSta
% GradSta = zeros(NT, Nrow, Ncol);
% for i = 1:NT
%    tic;
%    disp(['Orientation ', num2str(i), '\', num2str(NT), '......']);
%    etemp = squeeze(template{i});
%    [temp1, temp2] = TempSeparation(etemp);
%    
%    Sta1 = imfilter(PolSta, temp1, 'corr', 'symmetric', 'same');
%    Sta2 = imfilter(PolSta, temp2, 'corr', 'symmetric', 'same');
%    GradSta(i,:,:) = abs(Sta1 - Sta2);
% 
%    disp('Cost times: ');
%    toc;
% end


%% Combination
% Grad = sqrt(GradPol.^2 + beita .* GradSta.^2);

xidx = find(tempthetaList == pi);
yidx = find(tempthetaList == pi/2);

Gy = squeeze(Grad(yidx, :, :));
Gx = squeeze(Grad(xidx, :, :));

% GradMax = sqrt(Gy.^2 + Gx.^2);

GradMax = squeeze(max(Grad));

end