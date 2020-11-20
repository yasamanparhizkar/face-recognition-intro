clear;
clc;

%create train data
trainData = cell(40,8);
for i=1:40
    for j=1:8
        trainData{i,j} = imread(['../data/att-database-of-faces/s', ...
            num2str(i),'/',num2str(j),'.pgm']); 
    end
end

%create test data
testData = cell(40,2);
for i=1:40
    for j=9:10
        testData{i,j-8} = imread(['../data/att-database-of-faces/s', ...
            num2str(i),'/',num2str(j),'.pgm']); 
    end
end

%train autoencoder
%autoenc = trainAutoencoder(trainData,100,'MaxEpochs',1000);

%load autoencoder
load('autoenc.mat');

%test performance of autoencoder
A = cell(1,1);
A{1,1} = imread("../data/att-database-of-faces/s7/1.pgm");
reA = predict(autoenc, A);
reA{1} = cast(reA{1},'uint8');
figure("Name","Performace Test of Autoencoder");
subplot(1,2,1);
imshow(A{1});
title("Original");
subplot(1,2,2);
imshow(reA{1});
title("Reconstructed");

%encode train and test database
encTrainData = encode(autoenc, trainData');
encTestData = encode(autoenc, testData');

%creat targets
targets = zeros(40,size(encTrainData,2));
for i=1:40
    for j=1:8
        targets(i,8*(i-1)+j) = 1; 
    end
end

%train softmax layer
%   net = trainSoftmaxLayer(encTrainData, targets);

%load softmax layer
load('net.mat');

%stack autoencoder and softmax layer
stackednet = stack(autoenc, net);
view(stackednet);

%detect images
encData = [encTrainData,encTestData];
Y = net(encData);
d = zeros(40,400);
for i=1:40
    d(i,:) = sum(( Y - repmat(targets(:,i*8),1,400) ).^2);
end
[~, c] = min(d);

%calculate acc
correct = zeros(1,400);
for i=1:40
    for j=1:8
        correct(1,(i-1)*8+j) = i;
    end
end
for i=1:40
    for j=1:2
        correct(1,320+(i-1)*2+j) = i;
    end
end
accTrain = (sum(correct(1:320) == c(1:320)))/320;
accTest = (sum(correct(321:400) == c(321:400)))/80;



