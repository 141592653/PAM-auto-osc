% args = {fixe reedmodel F Q Z T dt qr u0 u1 p0 p1}
function p = clarinet_modal2(x, y, args)
    fixe = args{1};
    reedmodel = args{2};
    F = args{3};
    Q = args{4};
    Z = args{5};
    T = args{6};
    dt = args{7};
    qr = args{8};
    u0 = args{9};  u1 = args{10}; p0 = args{11}; p1 = args{12}; 
    
    if(strcmpi(fixe, 'L'))
        L = 0.5;
        zeta = x;
        gamma = y;
    elseif(strcmpi(fixe, 'zeta'))
        zeta = 0.8;
        gamma = x;
        L = y;
    elseif(strcmpi(fixe, 'gamma'))
        gamma = 0.8;
        zeta = x;
        L = y;
    end

    %!!!!!!!!!!!!!! faire L!!!!!!!!  
    
    N = floor(T/dt);
    start = 2;
    
    c = 340;
    f =1;%c/2/L;
    F = F;

    n = length(F);
    p = zeros(n,N);
    u = zeros(1,N);
    
    u(1) = u0; u(2) = u1; p(1) = p0; p(2) = p1;
    
    %Set parameters 
    w = 2*pi*F;
%     A = zeta*(3*gamma-1)/2/sqrt(gamma);
%     B = -zeta*(3*gamma+1)/8/gamma^(3/2);
%     C = -zeta*(gamma+1)/16/gamma^(5/2);
%     F0 = zeta*(1-gamma)*sqrt(gamma);
    s = (w/2./Q.*(-1 + 1i * sqrt(4*Q.^2 - 1)))';
    D = (Z.*w./Q.*(1+1i./sqrt(4*Q.^2 - 1)))';

    if(strcmpi(reedmodel, 'lippal'))
        x = zeros(1,N);
        wr = 2*pi*F(1);
        start = 3;
    end
    
    for i = start:N   
        pr = 2*real(sum(p(:,i-1)));
        if(strcmpi(reedmodel, 'reed'))
            % u(i) = F0 + A*pr + B*pr^2 + C*pr^3; DL a l'odre 3
            if gamma - pr < 1
                u(i) = zeta.*(1-gamma+pr).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;
            else
                u(i) = 0;
            end
        elseif(strcmpi(reedmodel, 'lippal'))
            x(i) = (-pr - 1/wr/wr*(x(i-2)-2*x(i-1))/dt/dt + qr/wr*x(i-1)/dt)/(1/(wr*dt)^2 + qr/(wr*dt)+1);
            u(i) = zeta.*(1+gamma+x(i)).*sqrt(abs(gamma-pr)).*sign(gamma - pr) ;   
        end
        p(:,i) = (p(:,i-1) + dt*D*u(i))./(1 - dt*s);
    end
    %plot(real(sum(p)))
end
