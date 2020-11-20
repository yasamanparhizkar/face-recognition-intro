clear;
clc;

%read image of person A
A = imread("../data/att-database-of-faces/s7/1.pgm");
figure("Name","Original Image of Person A");
imshow(A);
title("Person A");
%calculate fourier transform
fA = fft2(A);
fA = fftshift(fA);
%plot magnitude and phase of fourier transform
plot_mag_and_phase(fA, 'A');
%draw images with noisy magnitude and intact phase and vice versa
%with three snrs: 1, 0.5, 0.25
draw_noisy_images(fA, 1);
draw_noisy_images(fA, 0.5);
draw_noisy_images(fA, 0.25);

%read images of person B and C
B = imread("../data/att-database-of-faces/s11/1.pgm");
C = imread("../data/att-database-of-faces/s13/1.pgm");
figure("Name","Original Images of Person B and C");
subplot(1,2,1);
imshow(B);
title("Person B");
subplot(1,2,2);
imshow(C);
title("Person C");
%calculate fourier transform
fB = fft2(B);
fB = fftshift(fB);
fC = fft2(C);
fC = fftshift(fC);
%rebuild signals
nfB = abs(fB).*exp(1i*angle(fC));
nfC = abs(fC).*exp(1i*angle(fB));
%display images
nfB = fftshift(nfB);
nB = ifft2(nfB);
nB = real(nB);
nfC = fftshift(nfC);
nC = ifft2(nfC);
nC = real(nC);
figure("Name","Mixed Images of Persons B and C");
subplot(1,2,1);
imshow(cast(nB,'uint8'));
title("Person B w/ Person C Phase");
subplot(1,2,2);
imshow(cast(nC,'uint8'));
title("Person C w/ Person B Phase");




%-------------------------------------------------------------------
function plot_mag_and_phase(fA,name)
    [X,Y] = meshgrid(linspace(-pi,pi,size(fA,2)),linspace(-pi,pi,size(fA,1)));
    %plot magnitude
    figure("Name",['Fourier Magnitude of Person ',name]);
    mesh(X,Y,abs(fA));
    title(['Fourier Magnitude of Person ',name]);
    xlabel("Frequency by Columns [radians]");
    ylabel("Frequency by Rows [radains]");
    %plot phase
    figure("Name",['Fourier Phase of Person ',name]);
    mesh(X,Y,angle(fA));
    title(['Fourier Phase of Person ',name,' [radians]']);
    xlabel("Frequency by Columns [radians]");
    ylabel("Frequency by Rows [radains]");
end



function draw_noisy_images(fA, snr)
    %add noise to fourier transform
    nmA = awgn(abs(fA),snr,'measured');
    npA = awgn(angle(fA),snr,'measured');

    %create signal with intact magnitude and noisy phase
    nfA = abs(fA).*exp(1i*npA);
    %display picture
    nfA = fftshift(nfA);
    nA = ifft2(nfA);
    nA = real(nA);
    figure("Name",['Noisy Image with SNR = ',num2str(snr)]);
    subplot(1,2,1);
    imshow(cast(nA,'uint8'));
    title("Noisy Phase");

    %create signal with intact phase and noisy magnitude
    nfA = nmA.*exp(1i*angle(fA));
    %display noisy picture
    nfA = fftshift(nfA);
    nA = ifft2(nfA);
    nA = real(nA);
    subplot(1,2,2);
    imshow(cast(nA,'uint8'));
    title("Noisy Magnitude");
end


