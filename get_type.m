function [type] = get_type(windowed)

    en = sum(windowed.^2); % energy is calculated
    zcr = zerocrossrate(windowed); % zero-crossing rate is calculated
    ratio = en/zcr;

    if en < 1e-5 % if the energy less than threshold 
        type = 2; % type is silence

    elseif ratio > 140 % if ratio exceeds a threshold
        type = 0; % type is voiced

    else % otherwise
        type = 1; % type is unvoiced
        
    end

end