clear;
clc;

%read original image
A = imread("../data/house.jpg");
figure("Name","Original Image");
image(A);
%define kernels
sharpen = [0,-1,0;-1,5,-1;0,-1,0];
blur = [0.0625,0.125,0.0625;0.125,0.25,0.125;0.0625,0.125,0.0625];
outline = [-1,-1,-1;-1,8,-1;-1,-1,-1];
gauss = [0.0113,0.0838,0.0113;0.0838,0.6193,0.0838;0.0113,0.1111,0.0113];
avg_moving = 0.1111*ones(3,3);
line_H = [-1,-1,-1;2,2,2;-1,-1,-1];
line_V = line_H';
identity = [0,0,0;0,1,0;0,0,0];
%filter with kernels
fA = spatial_filter(A, sharpen);
figure("Name","Sharpened Image");
image(fA);

fA = spatial_filter(A, blur);
figure("Name","Blured Image");
image(fA);

fA = spatial_filter(A, outline);
figure("Name","Outlines of the Image");
image(fA);

fA = spatial_filter(A, gauss);
figure("Name","Gaussian Blured Image");
image(fA);

fA = spatial_filter(A, avg_moving);
figure("Name","Average Blured Image");
image(fA);

fA = spatial_filter(A, line_H);
figure("Name","Horizontal Lines of the Image");
image(fA);

fA = spatial_filter(A, line_V);
figure("Name","Vertical Lines of the Image");
image(fA);

fA = spatial_filter(A, identity);
figure("Name","Identical to the Original Image");
image(fA);

%------------------------------------------------------------
function fimg = spatial_filter(img, kernel)
    %set parameters
    P = 1;  %size of padding
    S = 1;  %size of stride
    F = size(kernel,1); %size of filter
    [rowsIn, colsIn, depthIn] = size(img);
    sizeRowsOut = ((rowsIn-F+2*P)/S) + 1;
    sizeColsOut = ((colsIn-F+2*P)/S) + 1;
    
    %initialize output
    fimg = zeros(sizeRowsOut, sizeColsOut, depthIn);
    
    %cast to 'double' for better precision
    img = cast(img, 'double');
    
    %pad image
    pad_img = padarray(img, [1 1], 0, 'both');
    
    %filter all three channels (red, green & blue) with given kernel
    fimg(:,:,1) = conv2(pad_img(:,:,1), kernel, 'valid');
    fimg(:,:,2) = conv2(pad_img(:,:,2), kernel, 'valid');
    fimg(:,:,3) = conv2(pad_img(:,:,3), kernel, 'valid');
    
    %again cast to uint8:
    %   any number more than 255 will be 255
    %   and any negative number will be 0
    fimg = cast(fimg, 'uint8');
end