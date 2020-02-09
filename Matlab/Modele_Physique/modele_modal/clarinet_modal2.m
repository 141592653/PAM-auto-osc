% args = [T dt reedmodel qr u0 u1 p0 p1];
function [p,u] = clarinet_modal2(zeta, gamma, args,  f, Q, Z)
    T = args(1);
    dt = args(2);
    reedmodel = args(3);
    qr = args(4);
    
    N = floor(T/dt);
    start = 2;

    n = length(f);
    p = zeros(n,N);
    u = zeros(1,N);
    
    u(1) = args(5); u(2) = args(6); p(1) = args(7); p(2) = args(8);
    
    %Set parameters 
    w = 2*pi*f;
%     A = zeta*(3*gamma-1)/2/sqrt(gamma);
%     B = -zeta*(3*gamma+1)/8/gamma^(3/2);
%     C = -zeta*(gamma+1)/16/gamma^(5/2);
%     F0 = zeta*(1-gamma)*sqrt(gamma);
    s = (w/2./Q.*(-1 + 1i * sqrt(4*Q.^2 - 1)))';
    D = (Z.*w./Q.*(1+1i./sqrt(4*Q.^2 - 1)))';

    if(reedmodel==2)
        x = zeros(1,N);
        wr = 2*pi*f(1);
        start = 3;
    end
    
    for i = start:N   
        pr = 2*real(sum(p(:,i-1)));
        if(reedmodel==1)
            % u(i) = F0 + A*pr + B*pr^2 + C*pr^3; DL a l'odre 3
            if gamma - pr < 1
                u(i) = zeta.*(1-gamma+pr).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;
            else
                u(i) = 0;
            end
        elseif(reedmodel==2)
            x(i) = (-pr - 1/wr/wr*(x(i-2)-2*x(i-1))/dt/dt + qr/wr*x(i-1)/dt)/(1/(wr*dt)^2 + qr/(wr*dt)+1);
            u(i) = zeta.*(1+gamma+x(i)).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;   
        end
        p(:,i) = (p(:,i-1) + dt*D*u(i))./(1 - dt*s);
    end
end
