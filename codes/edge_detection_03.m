clear;
clc;

%read original image
oA = imread("../data/page.jpg");
oA = imresize(oA,0.2);
%convert to grayscale
A = rgb2gray(oA);
%define kernels
line_H = [-1,-1,-1;2,2,2;-1,-1,-1];
line_V = line_H';
%find horizontal edges
B = spatial_filter(A, line_H);
figure("Name","Horizontal Lines of the Image");
imshow(B);
%find index of horizontal edges
[m,i] = max(B);
[~,j] = max(m);
i = i(j);
i1 = i;
hold on
plot(j,i,'o');
B((i1-10):(i1+10),:) = 0;
[m,i] = max(B);
[~,j] = max(m);
i = i(j);
i2 = i;
hold on
plot(j,i,'o');
%find vertical edges
B = spatial_filter(A, line_V);
figure("Name","Vertical Lines of the Image");
imshow(B);
%find index of vertical edges
[m,i] = max(B);
[~,j] = max(m);
i = i(j);
j1 = j;
hold on
plot(j,i,'o');
B(:,(j1-10):(j1+10)) = 0;
[m,i] = max(B);
[~,j] = max(m);
i = i(j);
j2 = j;
hold on
plot(j,i,'o');
%draw the rectangle
x = min(j1,j2);
y = min(i1,i2);
w = max(j1,j2) - min(j1,j2);
h = max(i1,i2) - min(i1,i2);
figure("Name","Detected Edges on the Original Picture");
imshow(oA);
hold on
rectangle('Position',[x y w h],'EdgeColor','r','LineWidth',3);


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
    
    %filter image
    fimg = conv2(pad_img, kernel, 'valid');
    
    %again cast to uint8:
    %   any number more than 255 will be 255
    %   and any negative number will be 0
    fimg = cast(fimg, 'uint8');
end