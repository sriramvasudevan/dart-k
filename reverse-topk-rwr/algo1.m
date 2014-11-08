function [Pcap, R, W, S, PH] = algo1(A, K, H, alpha, delta, eta, eps)
    
PH = zeros(size(A,1),size(A,1));
for i=1:size(H,2)
    k=H(i);
    eu = zeros(size(A,1),1);
    eu(k) = 1;
    old_p = ones(size(A,1),1);
    while(true)
        PH(:,k) = (1-alpha)*A*old_p + alpha*eu;
        if norm(PH(:,k)-old_p)<eps
            break;
        end
        old_p = PH(:,k);
    end
end

disp('Hubs done');
V = (1:size(A,1));
V(H) = 0;
V = nonzeros(V);
V2 = (1:size(A,1));
newH = zeros(size(A,1),size(A,1));
R = zeros(size(A,1),size(A,1));
W = zeros(size(A,1),size(A,1));
S = zeros(size(A,1),size(A,1));

for i=1:size(V2,2)
    oldru = zeros(size(A,1),1);
    oldru(V2(i)) = 1;
    oldsu = 0;
    oldwu = 0;
    while norm(oldru,1) > delta
        tempindex = (oldru>=eta);
        tempindex(H) = 0;
        tempru = oldru.*tempindex;
        Lt = V(oldru(V)>=eta);
        total = sum((1-alpha)*bsxfun(@times,oldru(Lt)',A(:,Lt)),2);
        ru = total + oldru - tempru;
        
        oldru(V) = 0;
        su = oldru+oldsu;
        
        wu = alpha*tempru + oldwu;
       
        if(ru==oldru)
            if(oldsu~=0)
                su=oldsu;
            end
            break;
        end
        % Updates
        oldru = ru;
        oldsu = su;
        oldwu = wu;
    end
    newH(:,V2(i)) = wu + PH*su;
    ru = ru - su;
    R(:,V2(i)) = ru;
    W(:,V2(i)) = wu;
    S(:,V2(i)) = su;
end
PH(newH~=0) = newH(newH~=0);
newH = sort(PH, 'descend');
Pcap = newH(1:K,:);

end


