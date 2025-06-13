clear
close all

ts = 0.01; % sampling time
fs = 1/ts;   % Sampling Frequency (fs=1/ts)
t  = (0: ts : 2.1 ); % defining time duration
tt  =(0:ts:4.2); % defining time duration of convolution output
T=1
SNR = 15; %dB
SNR_lin = (10.^(SNR/10)); %SNR values in linear scale

%====================================================
%----- Generate transmit signal (s_TX) Triangular Input signal------
   
    s_Tx=triangle(t,T);

    figure, plot(t,s_Tx,'b');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    %axis([-1 3 -0.3 1.1])
    title('Triangular Signal ');
    hold on
    pause
%===========================================================
%----------------Signal Power (Ps) and Signal Energy (Es)-----------------------------
'Signal Power (Watts)'

Ps_true=0.333 %True signal power
Ps=sum(s_Tx.^2)*ts/T % signal power

Es=Ps*T %Sigan energy
pause
%===========================================================




%-----Matched Filter (MF) Impulse Response-------------------  

     h_MF=triangle(T-t,T);

     plot(t,h_MF,'r');

     pause
%===========================================================
%-----Matched Filter output-------------------  

    Y=conv(s_Tx,h_MF)*ts;
    
    figure
    plot(tt,Y,'r');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    title('Matched Filter Output ');
    hold on
    pause
 %===============================================
    % Generate Gaussian noise samples  
    noise_var = Ps/(SNR_lin); 
    sigma = sqrt(noise_var);
    noise = sigma * randn(1,length(t));
    figure, plot(t,noise,'b');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    title('Noise Signal ');
    hold on
    pause
%===================================================
% Generate Receive Signal(s_Rx)

  s_Rx=s_Tx+noise;
    figure 
    plot(t,s_Rx,'b');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    title('Receive Signal (s_{Rx)}=s_{Tx}+noise');
    hold on
    pause
%===================================================   
%----------Output of Matched Filter (Y)----------
    Y=conv(s_Rx,h_MF)*ts; 
    figure 
    plot(tt,Y,'r');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    title('Matched filter output)')

    pause
%===================================================   
%----------Output of Sampling Device( t_sample=T)----------
%-------------Sampling Instants----------------------------
ts=0.01
k=(1:1:4);
t_sampling=(k-1)*(T/ts)+1
Y_k=Y(t_sampling)
pause
%============================Sample at T=1 =====================
Y_max = max(Y_k);
[t_max]=find(Y_k==Y_max);
t_max=(t_max-1)*(T/ts)+1
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------Compute input SNR----------------------
SNR_in=Ps/noise_var  % Input SNR
SNR_in_dB=10*log(SNR_in); % Input SNR in dB
pause
%=============================================================
%-------------------Compute output SNR----------------------
BW=1/T;% input signal bandwidth
N0=noise_var/BW;
SNR_out=2*Es/N0 % Output SNR 
SNR_out_dB=10*log(SNR_out) %Output SNR in dB
pause
%-------------------Compute  SNR Gain of the Matched Filter----------------------

SNR_gain=SNR_out_dB-SNR_in_dB 




