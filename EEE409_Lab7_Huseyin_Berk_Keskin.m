%% Hüseyin Berk Keskin EEE409 Lab7
clc, clear all, close all;

%%%%% Monte Carlo Simulations Parameters %%%%%
M = 2; % modulation order: M=2 binary; M=4; etc.
K0=20; %Carrier frequency multiplier
Tb = 1; % bit interval(sec)
br = 1/Tb; % Bit rate
Fc = br*K0; % Carrier frequency
Tc=1/Fc;
fs=Fc*10; % sampling rate
ts = 1/fs; % sampling time of the pulse (for Matlab realization)
Nbits = 10000; %number of transmitted bits
sig_dur=Nbits*Tb;
symbol_dur=Tb*ts;
t = (0: ts : sig_dur-ts ); % defining pulse duration
N_samp=Tb*fs; %nb
Ac = 1; % Carrier amplitude for binary input '1'
Delta_f=10; %Freq deviation

F_1 = Fc + Delta_f; % Frequency for binary '1'
F_0 = Fc - Delta_f; % Frequency for binary '0'

% SNR values for BER calculation
SNR_val = [0 3 6 9 12 15 18]; % dB
BER = zeros(1, length(SNR_val)); % Pre-allocate BER

% Monte Carlo Simulations for SNR values
for idx = 1:length(SNR_val)
    SNR = SNR_val(idx);
    
    % Step 1: Generate input binary data sequence
    binary_data = randi([0 1], 1, Nbits);
    disp('Binary Input Data: ');
    disp(binary_data);
    
    % Step 2: Generate FSK transmitted signal
    fsk_modulation = [];
    time_bit = (0:N_samp-1) * ts; % Time vector for one bit
    for i = 1:Nbits
        if binary_data(i) == 1
            y = Ac * cos(2 * pi * F_1 * time_bit); % Carrier for binary '1'
        else
            y = Ac * cos(2 * pi * F_0 * time_bit); % Carrier for binary '0'
        end
        fsk_modulation = [fsk_modulation, y]; % Append modulated signal
    end
    
    % Step 3: Generate Gaussian noise by using the current SNR value
    Energy_b = (Ac^2*Tb)/2;  
    N_p = Energy_b/(10^(SNR/10)); 
    std_noise = sqrt(N_p/(2*ts)); 
    noise = std_noise*randn(size(fsk_modulation));
    rx_signal = fsk_modulation + noise; % Received signal
    
    % Step 4: Generate the received signal at the receiver
    h1_matched = sqrt(2/Tb)*cos(2*pi*F_1*time_bit);
    h0_matched = sqrt(2/Tb)*cos(2*pi*F_0*time_bit);

    % Matched Filter Output
    y1RX = conv(rx_signal, h1_matched, 'same') * ts;
    y0RX = conv(rx_signal, h0_matched, 'same') * ts;
    
    % Step 5: Detect the received data
    t0 = (N_samp / 2); % Sampling offset
    t_sampling = (t0:N_samp:length(rx_signal)); % Sampling points
    y1_sampling = y1RX(t_sampling);
    y0_sampling = y0RX(t_sampling);

    % Decision device
    detected_sig = zeros(1, Nbits);
    for i = 1:Nbits
        if y1_sampling(i) > y0_sampling(i)
            detected_sig(i) = 1;
        else
            detected_sig(i) = 0;
        end
    end
    
    % Error counting
    errors = sum(detected_sig ~= binary_data);
    
    % Calculate BER for current SNR
    BER(idx) = errors/Nbits;

end

% Plot BER vs. SNR
figure;
semilogy(SNR_val, BER, 'o-', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. SNR for Binary FSK Communication');
ylim([1e-4 1]);