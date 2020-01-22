function output = clarinet_modal(zeta, gamma, L, T, dt, Q1)
    N = floor(T/dt);

    p = zeros(1,N);
    u = zeros(1,N);

    c = 340;
    for i = 2:N
        t = i*dt;
        F1 = 2*c/L;
        f = c/4/L;
        w1 = 2*pi*f;
        Y1 = w1/Q1/F1;
        A = zeta*(3*gamma-1)/2/sqrt(gamma);
        B = -zeta*(3*gamma+1)/8/gamma^(3/2);
        C = -zeta*(gamma+1)/16/gamma^(5/2);
        F0 = zeta*(1-gamma)*sqrt(gamma);
        s1 = w1/2/Q1*(-1 + 1i * sqrt(4*Q1^2 - 1));
        C1 = F1 *(1+1i/sqrt(4*Q1^2 - 1));
        pr = 2*real(p(i-1));
        u(i) = F0 + A*pr + B*pr^2 + C*pr^3;
        p(i) = (p(i-1) + dt*C1*u(i))/(1 - dt*s1);
    end
   output = real(p);
end