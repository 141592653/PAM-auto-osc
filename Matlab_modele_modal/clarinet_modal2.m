function [p,u] = clarinet_modal2(zeta, gamma, T, dt, f, Q, Z)
    N = floor(T/dt);

    n = length(f);
    p = zeros(n,N);
    u = zeros(1,N);
    
    for i = 2:N
        w = 2*pi*f;
        A = zeta*(3*gamma-1)/2/sqrt(gamma);
        B = -zeta*(3*gamma+1)/8/gamma^(3/2);
        C = -zeta*(gamma+1)/16/gamma^(5/2);
        F0 = zeta*(1-gamma)*sqrt(gamma);
        s = (w/2./Q.*(-1 + 1i * sqrt(4*Q.^2 - 1)))';
        D = (Z.*w./Q.*(1+1i./sqrt(4*Q.^2 - 1)))';
        pr = 2*real(sum(p(:,i-1)));
        u(i) = F0 + A*pr + B*pr^2 + C*pr^3;
        p(:,i) = (p(:,i-1) + dt*D*u(i))./(1 - dt*s);
    end
end