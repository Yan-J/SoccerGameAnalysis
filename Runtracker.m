% Demo for paper "Real-Time Compressive Tracking,"Kaihua Zhang, Lei Zhang, and Ming-Hsuan Yang
% To appear in European Conference on Computer Vision (ECCV 2012), Florence, Italy, October, 2012 
% Implemented by Kaihua Zhang, Dept.of Computing, HK PolyU.
% Email: zhkhua@gmail.com
% Date: 11/12/2011
% Revised by Kaihua Zhang, 15/12/2011
% Revised by Kaihua Zhang, 11/7/2012

clc;clear all;close all;
%----------------------------------
rand('state',0);
%----------------------------------
addpath('./data');
%----------------------------------
load init.txt;
initstate = init;%initial tracker
%----------------------------Set path
avi2img();
img_dir = dir('./data/*.jpg');
%---------------------------
img = imread(img_dir(1).name);
img = double(img(:,:,1));

trparams = [];
clfparams = [];
posx = [];
%% 
negx = [];
ftr = [];

rectNo = size(initstate,1);
for j = 1:rectNo
    [trparams_tmp, clfparams_tmp, posx_tmp, negx_tmp, ftr_tmp] = trackerOneInit( img, initstate(j,:));
    trparams = [trparams; trparams_tmp];
    clfparams = [clfparams; clfparams_tmp];
    posx = [posx; posx_tmp];
    negx = [negx; negx_tmp];
    ftr = [ftr; ftr_tmp];
end
%--------------------------------------------------------
num = length(img_dir);% number of frames
%--------------------------------------------------------
for i = 2:num
    img = imread(img_dir(i).name);
    imgSr = img;% imgSr is used for showing tracking results.
    img = double(img(:,:,1));
    %imshow(uint8(imgSr));
    for j = 1:rectNo
        [initstate(j,:), posx(j), negx(j)] = trackerOne( img, initstate(j,:),trparams(j),ftr(j), posx(j),negx(j)); 
    end   
    text(5, 18, strcat('#',num2str(i)), 'Color','k', 'FontWeight','bold', 'FontSize',20);
    set(gca,'position',[0 0 1 1]); 
    outputname = sprintf('./output/%03d.jpg',i);
    saveas(1,outputname);
    pause(0.00001); 
    hold off;
end

img2avi('./output/','./output/resultVideo.avi',50,'None',2,2,398);
