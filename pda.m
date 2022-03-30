% this function calculates the pitch of frame
function [pitch] = pda(acf, Fs)
    
    % acf is smoothened by taking its autocorrelation
    ACF = fft(acf);
    PSD = ACF .* conj(ACF);
    smoothened_acf = ifft(PSD);
    
    half_idx = round(length(smoothened_acf)/2); % half index is calculated
    [~, locs] = findpeaks(smoothened_acf(1:half_idx)); % peaks are found

    % if there is no peak
    if isempty(locs)
        locs = 1;
    end
    pitch = Fs/locs(1); % pitch is the fundamental frequency

end