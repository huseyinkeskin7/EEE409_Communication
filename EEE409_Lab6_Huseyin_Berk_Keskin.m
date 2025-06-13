clear; close all; clc;

SNR_input_dB = [3, 6, 9, 12, 15, 18, 21];  
SNR_output_dB = zeros(size(SNR_input_dB));
SNR_gain_dB = zeros(size(SNR_input_dB));
trials = 10;

% Time vector
t = linspace(0, 3.0001, 1000); 
tt  = linspace(0, 6, 2000);
dt = t(2) - t(1); 

% Step 1: Input signal s(t) definition
s = rectangular_pulse(t, 0, 2, 1) + rectangular_pulse(t, 2, 3, -0.5); 
s(t > 3) = 0; 

% Step 2: Plot the input signal s(t)
figure;
plot(t, s, 'LineWidth', 1.5);
hold on;
yline(0, '--k'); % Draw y-axis at y = 0
xline(0, '--k'); % Draw x-axis at t = 0
xlabel('t (sec)');
ylabel('s(t) (Volts)');
title('Input Signal s(t)');
grid on;
xlim([-0.5 3.5]);
ylim([-1 1.5]);
% Compute the power of the input signal
E = sum(s.^2) * dt; % Numerical integration of s^2(t)

T = max(t) - min(t); % Total time duration

% Step 3: Compute signal power
Ps = E / T;
fprintf('Signal Power (E/T): %.4f Watts\n', Ps);

for i = 1:length(SNR_input_dB)
    % Step 3: Gaussian Noise Generation
    SNR_lin = 10^(SNR_input_dB(i)/10); % Linear SNR
    noise_var = Ps / SNR_lin; % Variance of the noise
    sigma = sqrt(noise_var); % Standard deviation of the noise

    snr_out_dB_trial = zeros(trials, 1); 
    for trial = 1:trials
        noise = sigma * randn(1, length(t));   

        % Step 4: Generate received signal r(t)
        r = s + noise;
    
        % Step 5: Design the matched filter h(t)
        h = fliplr(s) / trapz(t, s.^2); % Impulse response of matched filter (normalized)
    
        % Step 6: Convolve received signal with matched filter
        y = conv(r, h, 'same') * dt; % Convolution output scaled by dt to match `t`

        noise_energy_after_filter = trapz(t, (conv(noise, h, 'same') *0.01).^2); % Gürültü enerjisi
        signal_energy = trapz(t, h.^2);  % Filtre sonrası sinyal enerjisi
        snr_out_linear = signal_energy / noise_energy_after_filter;
        snr_out_dB_trial(trial) = 10 * log10(snr_out_linear);
    end
    
    SNR_output_dB(i) = mean(snr_out_dB_trial);
    SNR_gain_dB(i) = SNR_output_dB(i) - SNR_input_dB(i);

    % Plot noisy and noise-reduced signals for this SNR value
    figure;
    subplot(2, 1, 1);
    plot(t, r, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(['Noisy Signal (SNR = ', num2str(SNR_input_dB(i)), ' dB)']);

    subplot(2, 1, 2);
    plot(t, y(1:length(t)), 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(['Filtered Signal (SNR = ', num2str(SNR_input_dB(i)), ' dB)']);
end

% Display results
fprintf('SNR Input (dB) | SNR Output (dB) | SNR Gain (dB)\n');
fprintf('-----------------------------------------------\n');
for i = 1:length(SNR_input_dB)
    fprintf('%13.2f | %14.2f | %12.2f\n', SNR_input_dB(i), SNR_output_dB(i), SNR_gain_dB(i));
end

% Plot results
figure;
plot(SNR_input_dB, SNR_output_dB, '-o', 'LineWidth', 1.5);
hold on;
plot(SNR_input_dB, SNR_gain_dB, '-x', 'LineWidth', 1.5);
xlabel('Input SNR (dB)');
ylabel('Output SNR / Gain (dB)');
legend('Output SNR', 'SNR Gain', 'Location', 'NorthWest');
grid on;
title('Matched Filter Performance');