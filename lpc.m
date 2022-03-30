% this function finds the lp coefficients by solving yule-walker equations
function a = lpc(acf, p)

    % form autocorrelation matrix
    c = acf(1:p);
    R = toeplitz(c);
    
    % form autocorrelation vector
    r = acf(2:p+1);

    a = R\r; % poles

end