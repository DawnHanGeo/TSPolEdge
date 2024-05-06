%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TSPolEdge: main function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Name: TSPolEdge: main.m
%
%   Description: The edge extraction based on the time series
%   multi-polarization SAR data. If use, please cite the following reference.
%
%   References: H. Gao, et al.,“TVPol-Edge: An Edge Detection Method with Time-varying Polarimetric 
%               Characteristics for Crop Field Edge Delineation” IEEE Transactions on Geoscience and Remote Sensing, 2024
%
%   Author: Han Gao
%
%   Date: 2024/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ispc
    dsp = '\';
else
    dsp = '/';
end

%% Parameter Setting
w = 5;  % the window size of the ENL Calculation
en_beita = 4; % the weighting coefficient of the enhancement of the polarimetric stationarity 
Thigh = 0.45; % the highest edge strength thresholds in the non-maximum suppression method 
Tlow = 0.15; % the lowest edge strength thresholds in the non-maximum suppression method

%% read time series polarimetric covariance matrices
Path = 'E:\GaoHan\EXPERIMENT\48.Edge_TSPol\TSPolEdge_GitHub_Release'; % main path
codepath = [Path, dsp, 'Code'];
datapath = [Path, dsp, 'Data'];
outpath = [Path, dsp, 'Results']; mkdir(outpath);

DateListStr = SLCListExtract(datapath, 'DateList'); % read date list
CR = [];
C3_4D = read_MTC3_files_CR(datapath, DateListStr, CR);

%% read the Gaussian templates
temp_Gaf = 'GaussianTemplate21_1_1.5_1_8.mat'; % the Gaussian template 
temp_Ga = load([codepath, dsp, temp_Gaf]);
template = temp_Ga.template;
templateiner = temp_Ga.template_iner;
sitalist = 1:8;
lensita = length(sitalist);
tempthetaList = pi * sitalist / lensita;


%% Calculate the equivalent number of look
EachNum = 500 * 1000;
ENLPath = [outpath, dsp, 'ENL']; mkdir(ENLPath);
ENL = ENLMap_MtFull_Trace(C3_4D, w, EachNum);
save([ENLPath, dsp, 'ENL.mat'], 'ENL');


%% Calculate the polarimetric stationarity 
stapath = [outpath, dsp, 'PolSta']; mkdir(stapath);
PolStaf = [stapath, dsp, 'PolSta_3.mat'];

tempiner = ones(3,3);stemp = size(tempiner, 1);
PolSta = PolStation_MT_full_Cal(C3_4D, tempiner);
save(PolStaf, 'PolSta');

dbPolSta = log(PolSta);
dbPolSta(dbPolSta>0) = 0;
minValue = min(OutlierElimination(dbPolSta(:), 'maxmin'));
dbPolSta = dbPolSta - minValue;
dbPolSta(dbPolSta<0) = 0;

%% Calculate the enhanced polarimetric stationarity and the corresponding 
[PolStaEn] = TSPol_PolSta_Enhance(dbPolSta, template, templateiner, en_beita);
PolStaEnNor = NorOnetime(PolStaEn);

CoVPolSta = CoV_PolStaMap_MtDp(PolStaEnNor, 5);
ENLPolSta = (ENL./max(ENL(:))) ./ (CoVPolSta./max(CoVPolSta(:)));
save([ENLPath, dsp, 'ENLPolSta.mat'], 'ENLPolSta');

LOG_ENLPolSta = log10(ENLPolSta);
LOG_ENLPolSta(LOG_ENLPolSta < 0) = 0;

%% Edge Strength Extraction
oedgepath = [outpath, dsp, 'EDGE_Results']; mkdir(oedgepath);
[Grad, Gx, Gy] = EdgeExtraction_TSPolRMS_ENLWeightSta(C3_4D, LOG_ENLPolSta, template, tempthetaList);
SAVE_GradMax(oedgepath, Grad, Gx, Gy);

% save figure of edge strength
lim1 = 0;
lim2 = 1.3;
lenImage = 200;
h1 = figure(1); imagesc(Grad); caxis([lim1 lim2]); axis image; colormap gray; axis off;
SavePlotImage(h1, Grad, lenImage, oedgepath, 'GradMax.png');

%% Extract the binarization boundary based on the non-maximum suppression method
Edge = thinAndThreshold(Gx, Gy, Grad, Tlow, Thigh);
h = figure; 
imagesc(Edge);  axis image; colormap gray; axis off;    
SavePlotImage(h, Edge, lenImage, oedgepath, 'Edge.png');
cd(oedgepath);





