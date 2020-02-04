<<<<<<< HEAD
function [p,u] = clarinet_modal2(zeta, gamma, T, dt, f, Q, Z, p0, u0, reedModel)
=======
function [p,u] = clarinet_modal2(zeta, gamma, T, dt, f, Q, qr, Z)
>>>>>>> 632df36a14cd9fbea4fd65cd3c15b356176524ca
    N = floor(T/dt);

    n = length(f);
    p = zeros(n,N);
    u = zeros(1,N);
    x = zeros(1,N);
    
<<<<<<< HEAD
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
=======
    wr = 2*pi*f(1);
    
    for i = 3:N
        w = 2*pi*f;
        A = zeta*(3*gamma-1)/2/sqrt(gamma);
        B = -zeta*(3*gamma+1)/8/gamma^(3/2);
        C = -zeta*(gamma+1)/16/gamma^(5/2);
        F0 = zeta*(1-gamma)*sqrt(gamma);
        s = (w/2./Q.*(-1 + 1i * sqrt(4*Q.^2 - 1)))';
        D = (Z.*w./Q.*(1+1i./sqrt(4*Q.^2 - 1)))';
        pr = 2*real(sum(p(:,i-1)));
        
        %clarinet reed simplified
        %u(i) = F0 + A*pr + B*pr^2 + C*pr^3;
        
        %clarinet reed
%         if gamma - pr < 1
%             u(i) = zeta.*(1-gamma+pr).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;
%         else
%             u(i) = 0;
%         end
        %lippal reed
        %x(i) = (x(i-1)-pr - 1/wr/wr*(x(i-2)-2*x(i-1))/dt/dt + qr/wr*x(i-1)/dt)/(1/(wr*dt)^2 + qr/(wr*dt));
        x(i) = (-pr - 1/wr/wr*(x(i-2)-2*x(i-1))/dt/dt + qr/wr*x(i-1)/dt)/(1/(wr*dt)^2 + qr/(wr*dt)+1);
        u(i) = zeta.*(1+gamma+x(i)).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;
        
        %violon excitator
        
>>>>>>> 632df36a14cd9fbea4fd65cd3c15b356176524ca
        p(:,i) = (p(:,i-1) + dt*D*u(i))./(1 - dt*s);
    end
end