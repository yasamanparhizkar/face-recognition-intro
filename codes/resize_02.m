clear;
clc;

%read original image
A = imread("../data/kobe.jpeg");
figure("Name","Original Image");
image(A);
%resize with bicubic method
B = imresize(A,0.2);
figure("Name","Resized Image at 1/5 Bicubic Interpolation");
image(B);
%resize with nearest neighbor method
C = imresize(A,5,'nearest');
figure("Name","Resized Image at 1/5 Nearest Neighbor Interpolation");
image(C);
%define kernels
gauss = [0.0113,0.0838,0.0113;0.0838,0.6193,0.0838;0.0113,0.1111,0.0113];
avg_moving = 0.1111*ones(3,3);
%filter with kernels
D = spatial_filter(C, gauss);
figure("Name","Nearest Neighbor Image After Guassian Filtering");
image(D);
D = spatial_filter(D, avg_moving);
figure("Name","Nearest Neighbor Image After Gaussian and Moving Average Filtering");
image(D);


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
