%BER Performance of a scrambled binary baseband Commmunications Systems
%SNR per bit (dB) --> Eb/N0

clc
clear
close all

NT = 10^6; %number of trials
SNR = 0 : 12; %dB
SNR_lin = (10.^(SNR/10)); %SNR values in linear scale

scramblerPoly = [1 0 0 1 0 1]; % Feedback taps (Polynomial: 1 + x^3 + x^5, example)
scramblerInitState = [1 1 1 0 1]; 

BER_Bob = zeros(1, length(SNR));
BER_Eve = zeros(1, length(SNR));
BER_Theoretical = zeros(1, length(SNR));

%Find the BER for different SNR (Eb/N0) values
for i = 1 : length(SNR_lin)

  % ================================================
  % Produce binary input sequence
   M=2;
   binary_seq=randi([0 M-1], 1, NT); 
   %================================================
   %scramble input binary sequency
    scram = comm.Scrambler(M, scramblerPoly, scramblerInitState);
    descram = comm.Descrambler(M, scramblerPoly, scramblerInitState);
    scrambledBits = (step(scram, binary_seq'))'; 

    %=====================================================
    % %convert   random binary 0-1 sequence  to  two-levels -1,+1  sequence  TX signals
    TX_data = 2 * scrambledBits - 1; % 0 -> -1, 1 -> +1
    %===============================================
    % Generate Gaussian noise samples  
    noise_var = 1 ./ (2 * SNR_lin(i));
    sigma = sqrt(noise_var);
    noise_signal = sigma * randn(1, NT); 
    %===============================================
    % Generate Signal+Noise
    RX_data = TX_data + noise_signal;
    %===============================================
     %%%%%%% Data detection by Legitimate User (Bob)%%%%%%%%
      det_dataBob=RX_data > 0;
    %%%%%%%%%%%%%%%%%Pefrom Descrabling%%%%%%%%%%%%%%%%%%%%%%
      
      %Perform descramble
    descrambledData = (step(descram, det_dataBob'))';
     %%%%%%%%%%%% Compute BER performance of Bob%%%%%%%%%%%%%%%%%
    BER_Bob(i) = sum(binary_seq ~= descrambledData) / NT;

      %%%%%%%% Data Detection by Eavesdropper (Eve)%%%%%%%%%%%%%
     
    det_dataEve = RX_data > 0; 
    BER_Eve(i) = sum(binary_seq ~= det_dataEve) / NT;
    BER_Theoretical(i) = qfunc(sqrt(2 * SNR_lin(i)));
end


% Plot BER_bob vs. SNR and BER_eve vs. SNR on the same  semilogy graph

disp('SNR (dB), BER_Bob, BER_Eve, BER_Theoretical');
disp([SNR' BER_Bob' BER_Eve' BER_Theoretical']);

% Plot BER vs. SNR
figure;
semilogy(SNR, BER_Bob, '-o', 'LineWidth', 2); hold on;
semilogy(SNR, BER_Eve, '-x', 'LineWidth', 2);
semilogy(SNR, BER_Theoretical, '-s', 'LineWidth', 2);
xlabel('SNR per bit (dB)');
ylabel('BER');
legend('BER - Bob', 'BER - Eve', 'Theoretical BER');
title('BER Performance of Scrambled Binary Baseband Communication System');
grid on;
