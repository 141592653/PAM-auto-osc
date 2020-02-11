function [f,Q,Z] = paraResonator(resonator, f0)

    if(strcmpi(resonator, 'clarinet'))
        % 2 modes
        % f = 200*[1 3];
        % Z = 10*[1 0.75];
        % Q = [10 15];

        c = 340;
            
        f_ratio = [1 3 5 7 9];
        
        kn = 2*pi*f0*f_ratio/c;
        
        a1 = 1.044;
        R = 0.03;
        rho = 1.4;
        S = pi*R^2;
        Zc = rho*c/S;
        rv = 1/R * 2*(1e-4)./sqrt(kn);
        

        f = f0*f_ratio.*(1 - a1*rv);
        Q = 1./(2*a1*rv);
        Z = Zc*8*f0*Q./(2*pi*f);
        Z = 10*Z/Z(1);
        
%         %7 modes
%         f = 235.5*[1 3 5 7 9 11 13];
%         Z = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
%         Q = [10 15 20 25 30 40 50];
%         Z = [10 7.5];
%         Q = [1 c 0 15];
    elseif(strcmpi(resonator, 'saxophone'))
        % 2 modes
        % f = 500*[1 2];
        % A = 10*[1 0.75];
        % Q = [10 15];

        % 7 modes
        c = 340;
            
        f_ratio = [1 2 3 4 5 6];
        
        kn = 2*pi*f0*f_ratio/c;
        
        a1 = 1.044;
        R = 0.03;
        rho = 1.4;
        S = pi*R^2;
        Zc = rho*c/S;
        rv = 1/R * 2*(1e-4)./sqrt(kn);
        

        f = f0*f_ratio.*(1 - a1*rv);
        Q = 1./(2*a1*rv);
        Z = Zc*8*f0*Q./(2*pi*f);
        Z = 10*Z/Z(1);
        
    elseif(strcmpi(resonator, 'trompet'))
        f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63]*2;
        f = f0*f/f(1);
        Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
        Z = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];
    end

end