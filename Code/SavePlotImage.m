%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: SavePlotImage.m
%
%   Description: saveas image for a png file
%
%   Input:  (1) h: jubing of figure
%           (2) Im: the 2D image mat
%           (2) lenImage: the length of saving image file 
%           (3) OutPath: the out path
%           (4) OutName: the name of file
%
%
%   Date: 2022/02/05
%
%   Author: GaoHan
%
%   Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SavePlotImage(h, Im, lenImage, OutPath, OutName)
if ispc
    dsp = '\';
else
    dsp = '/';
end

[Nrow, Ncol] = size(Im);
ratio = Nrow / Ncol;

% figure;imagesc(Im); axis image; colormap gray; axis off;
set(gcf,'unit','centimeters','position',[10 5 lenImage lenImage*ratio]);
print(gcf,'-dpng',[OutPath, dsp, OutName]);
close(h);

end