function s = rectangular_pulse(t, t_start, t_end, height)
    % RECTANGULAR_PULSE Generates a rectangular pulse
    % t       : Time vector (input)
    % t_start : Start time of the pulse
    % t_end   : End time of the pulse
    % height  : Amplitude of the pulse
    % s       : Output signal values corresponding to t

    % Initialize the output signal
    s = zeros(size(t));
    
    % Set the pulse values for the given time range
    s(t >= t_start & t <= t_end) = height;
end
