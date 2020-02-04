function [p,u] = clarinet_modal2(zeta, gamma, T, dt, f, Q, Z, p0, u0, reedModel)
    N = floor(T/dt);

    n = length(f);
    p = zeros(n,N);
    u = zeros(1,N);
    
    if nargin>=9
        u(1) = u0;
    end
    if nargin >= 8
        p(1) = p0;
    end    
    
    %Set parameters 
    w = 2*pi*f;
    A = zeta*(3*gamma-1)/2/sqrt(gamma);
    B = -zeta*(3*gamma+1)/8/gamma^(3/2);
    C = -zeta*(gamma+1)/16/gamma^(5/2);
    F0 = zeta*(1-gamma)*sqrt(gamma);
    s = (w/2./Q.*(-1 + 1i * sqrt(4*Q.^2 - 1)))';
    D = (Z.*w./Q.*(1+1i./sqrt(4*Q.^2 - 1)))';
    
    for i = 2:N
        pr = 2*real(sum(p(:,i-1)));
        if nargin >= 10 && reedModel == 2
            if gamma - pr < 1
                u(i) = zeta.*(1-gamma+pr).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;
            else
                u(i) = 0;
            end
        else
            u(i) = F0 + A*pr + B*pr^2 + C*pr^3;
            %u(i) = 1/(3-pr);
        end
        p(:,i) = (p(:,i-1) + dt*D*u(i))./(1 - dt*s);
    end
end