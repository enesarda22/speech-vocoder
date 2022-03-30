% this function calculates the gain
function gain = get_gain(type, acf, a, Fs, pitch)

    p = length(a); % filter order

    switch type
        case 0 % if type is voiced
            gain = sqrt((Fs/pitch)*(acf(1) - acf(2:p+1)'*a)); % gain is calculated
            
        case 1 % if type is unvoiced
            gain = sqrt(acf(1) - acf(2:p+1)'*a); % gain is calculated

        otherwise % if type is silence
            gain = 0; % gain is 0

    end

end