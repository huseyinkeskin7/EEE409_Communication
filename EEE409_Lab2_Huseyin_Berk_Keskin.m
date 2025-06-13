%% Hüseyin Berk Keskin EEE409 Lab2
clc, clear, close all;

%% Q1
n = 32;

binary_symbols = zeros(1, n); 

for i = 1:n
    x = rand(); 
    if 0 < x && x <= 0.4
        binary_symbols(i) = 0; 
    elseif 0.4 < x && x < 1
        binary_symbols(i) = 1;
    end
end

disp('Binary symbols:');
disp(binary_symbols);

figure;
stem(binary_symbols, 'filled');
title('Binary Symbols');
xlabel('Symbol Index');
ylabel('Binary Value (0 or 1)');

%% Q2
% M-ary Parameters
M = 16;
bits_per_symbol = log2(M); % Number of bits per symbol (4 for M=16)

% Convert binary sequence to M-ary symbols without reshape
M_ary_symbols = zeros(1, n / bits_per_symbol); % Preallocate for M-ary symbols
index = 1; % Initialize index for M-ary symbols

for i = 1:bits_per_symbol:n
    % Take the next 4 bits from the binary symbols
    binary_group = binary_symbols(i:i + bits_per_symbol - 1);
    
    % Convert the 4-bit group to a decimal value (M-ary symbol)
    M_ary_symbols(index) = binary_group(1) * 8 + binary_group(2) * 4 + ...
                           binary_group(3) * 2 + binary_group(4) * 1;
    index = index + 1; % Increment the index
end

% Display M-ary output
disp('M-ary symbols (M=16):');
disp(M_ary_symbols);

% Compute M_ary signal
M_aryy = M_ary_symbols * 2 - (M - 1); 

% Plot M_ary signal
figure; % Create a new figure for a_k signal
stem(M_aryy, 'filled');
title('M-ary Random Signal (M = 16)');
xlabel('Symbol Index');
ylabel('Signal Level (0 to 15)');
grid on;