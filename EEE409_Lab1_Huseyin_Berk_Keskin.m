clc;
clear all;

%% Task 1: Plot q, p, and z functions

% Define variables x and y 
x = 0:0.01:5;  
y = 0.05.*x + 2.01; 

% Define q, p, and z.
q = 5*cos(x.^3) + 4*sin(y.^2);  
p = 10*cos(x.*y) + 5*(x.^2);  
z = q + p; 

% Plot q, p, and z
figure;
subplot(2,1,1); % Subplot 1 for q, p, and z
plot(x, q, 'r', x, p, 'g', x, z, 'b');
legend('q(x, y)', 'p(x, y)', 'z(x, y)');
title('Plots of q, p, and z functions');
xlabel('x');
ylabel('Function values');
grid on;

%% Task 1: Sine wave with 10 Hz frequency

% Define time variable t 
t = 0:0.001:5;  

% Define sine_wave 
sine_wave = sin(2*pi*10*t); 

% Plot sine wave
subplot(2,1,2);
plot(t, sine_wave, 'm', 'LineWidth', 1.5); 
title('Sine Wave with 10 Hz Frequency', 'FontSize', 14, 'FontWeight', 'bold'); 
xlabel('Time (s)', 'FontSize', 12);  
ylabel('Amplitude', 'FontSize', 12);  
grid on;


%% Task 2: SNR and Information Calculation

% Define SNR in dB 
SNR_dB = [0, 5, 10, 15, 20, 25];  

% Convert SNR from dB to linear scale 
SNR_linear = 10.^(SNR_dB./10);  %dB_val=10*log(linear_val)

% Signal power Ps = 1 watt
Ps = 1;  

% Compute noise variance 
noise_variance = Ps ./ SNR_linear;  

% Given alphabet and symbol probabilities
A = [-3  -1  1  3]; % Amplitude levels
P = [0.15 0.20 0.25 0.40]; % Probabilities
Rs = 300; % Symbol rate in symbols per second

% Compute the amount of information per symbol (in bits)
Ik = -1*log2(P);  
disp('Amount of information carried by each symbol (I_k) in bits:');
disp(Ik);

% Compute entropy of the information source 
H = sum(P .* Ik);  % Entropy in bits per symbol 
disp('Entropy of the information source (H) in bits/symbol:');
disp(H);

% Compute total information transmitted in 15 seconds 
T = 15; % seconds
Info_transmitted = H * Rs * T;  % Total information transmitted
disp('Total information transmitted in 15 seconds (in bits):');
disp(Info_transmitted);

% Generate Nsym 4-level symbols (M=4) with given probabilities
Nsym = 12;  % Number of symbols
data_symbols = randsrc(1, Nsym, [A; P]);  % Generates random symbols based on probabilities

% Create separate plots for each SNR
for i = 1:length(SNR_dB)
    % Generate Gaussian noise samples with computed variance 
    noise = sqrt(noise_variance(i)) * randn(1, Nsym); 

    % Add noise to the data symbols 
    signal_plus_noise = data_symbols + noise;  

    % Create separate figure for each SNR
   
    figure(2)
    % Data Symbols plot
    subplot(3, length(SNR_dB), i);
    stem(data_symbols, 'filled', 'g', 'LineWidth', 1); 
    title(['Data Symbols, SNR = ', num2str(SNR_dB(i))], 'FontSize', 12);
    xlabel('Symbol Index');
    ylabel('Amplitude');
    grid on;
    
    % Noise plot
    subplot(3, length(SNR_dB), i + length(SNR_dB));
    stem(noise, 'filled', 'r', 'LineWidth', 1); 
    title(['Noise, SNR = ', num2str(SNR_dB(i))], 'FontSize', 12);
    xlabel('Sample Index');
    ylabel('Amplitude');
    grid on;
    
    % Signal + Noise plot
    subplot(3, length(SNR_dB), i + 2 * length(SNR_dB));
    stem(signal_plus_noise, 'filled', 'b', 'LineWidth', 1);
    title(['Signal + Noise, SNR = ', num2str(SNR_dB(i))], 'FontSize', 12);
    xlabel('Sample Index');
    ylabel('Amplitude');
    grid on;
end
