%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: read_Nrow_Ncol_config.m
%   Author: GaoHan
%   Description: read Nrow and Ncol of image from config.txt
%   Input: (1) config_inpath: config.txt��·��
%   Output: (1) Nrow: ͼ�������
%           (2) Ncol: ͼ�������
%   Date: 2019/06/29
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Nrow,Ncol,PolarCase,PolarType] = read_Nrow_Ncol_config(config_inpath)
%% read config file
fid = fopen(config_inpath,'r+');

i = 0;

while ~feof(fid) % feofΪ�ж��Ƿ�Ϊ�ı���β��������β�򷵻ط���ֵ    
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
