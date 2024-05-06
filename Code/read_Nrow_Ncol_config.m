%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: read_Nrow_Ncol_config.m
%   Author: GaoHan
%   Description: read Nrow and Ncol of image from config.txt
%   Input: (1) config_inpath: config.txt的路径
%   Output: (1) Nrow: 图像的行数
%           (2) Ncol: 图像的列数
%   Date: 2019/06/29
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Nrow,Ncol,PolarCase,PolarType] = read_Nrow_Ncol_config(config_inpath)
%% read config file
fid = fopen(config_inpath,'r+');

i = 0;

while ~feof(fid) % feof为判断是否为文本结尾函数，结尾则返回非零值    
    tline = fgets(fid);
    i = i + 1;
    newline{i,1} = tline;    
end

%% read Nrow and Ncol
Nrow = str2num(newline{2});
Ncol = str2num(newline{5});
PolarCase = newline{8};
PolarType = newline{11};
PolarCase = DeleteHuiche(PolarCase);
PolarType = DeleteHuiche(PolarType);
end
