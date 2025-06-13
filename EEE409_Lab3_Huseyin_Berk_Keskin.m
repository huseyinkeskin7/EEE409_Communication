function EEE409_Lab3_Huseyin_Berk_Keskin()

    % 1
    A = compute_amplitude();
    % 2
    data = datagen(A);
    % 3
    noisy_signal_0dB = add_noise(data, A, 0);
    noisy_signal_20dB = add_noise(data, A, 20);
    % 4
    plot_signals(data, noisy_signal_0dB, noisy_signal_20dB);
end

function A = compute_amplitude()
    A = sqrt(4 / 20);  
end

function data = datagen(A)
    % -2*(randi(M,[1,n]) - (M+1)/2)
    M = 4;  
    n = 15; 
    data = -2 * (randi(M, [1, n]) - (M + 1) / 2); 
end

function noisy_signal = add_noise(signal, A, SNR_dB)
    Ps = 5 * A^2; 
    SNR_linear = 10^(SNR_dB / 10);  
    noise_variance = Ps / SNR_linear;  
    
    k = length(signal); 
    M = 0; 
    
    % sqrt(sigma^2) * randn([k,1]) + M
    noise = sqrt(noise_variance) * randn([k, 1]) + M;
    noisy_signal = signal + noise';
end

function plot_signals(clean_signal, noisy_signal_0dB, noisy_signal_20dB)
    t = 1:length(clean_signal);
    figure (1);
    % Clean signal
    subplot(3,1,1);
    stem(t, clean_signal, 'b', 'LineWidth', 1.5);
    title('Transmitted Signal (Clean)');
    xlabel('Time');
    ylabel('Amplitude');
    
    % Noisy signal SNR = 0 dB
    subplot(3,1,2);
    stem(t, noisy_signal_0dB, 'r', 'LineWidth', 1.5);
    title('Noisy Signal (SNR = 0 dB)');
    xlabel('Time');
    ylabel('Amplitude');
    
    % Noisy signal SNR = 20 dB
    subplot(3,1,3);
    
    stem(t, clean_signal, 'b', 'LineWidth', 1.5);
    hold on;
    stem(t, noisy_signal_0dB, 'g', 'LineWidth', 1.5);
    title('Noisy Signal and Clean Signal  (SNR = 0 dB)');
    xlabel('Time');
    ylabel('Amplitude');
    
    figure(2);
        % Clean signal
    subplot(3,1,1);
    stem(t, clean_signal, 'b', 'LineWidth', 1.5);
    title('Transmitted Signal (Clean)');
    xlabel('Time');
    ylabel('Amplitude');
    
    % Noisy signal SNR = 0 dB
    subplot(3,1,2);
    stem(t, noisy_signal_20dB, 'r', 'LineWidth', 1.5);
    title('Noisy Signal (SNR = 0 dB)');
    xlabel('Time');
    ylabel('Amplitude');
    
    % Noisy signal SNR = 20 dB
    subplot(3,1,3);
    
    stem(t, clean_signal, 'b', 'LineWidth', 1.5);
    hold on;
    stem(t, noisy_signal_20dB, 'g', 'LineWidth', 1.5);
    title('Noisy Signal and Clean Signal  (SNR = 20 dB)');
    xlabel('Time');
    ylabel('Amplitude');
end