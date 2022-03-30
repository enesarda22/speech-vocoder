function [pitch] = pda2(windowed, a, Fs)
    
    y = filter([0; a], 1, windowed); % prediction
    res = windowed - y; % residual
    
    % residual acf is calculated
    res_acf = xcorr(res); 
    half_idx = ceil(length(res_acf)/2); 
    res_acf = res_acf(half_idx+10:end);
    
    % pitch is the peak in the residual acf
    [~, max_idx] = max(abs(res_acf));
    pitch = Fs/max_idx;

end