function [C, Pcap, R, W, S] = algo4(q, k, Pcap, R, W, S, A, K, H, PH, alpha, eta, eps)

pq = algo2(A, alpha, q, eps);
C = [];
V = (1:size(A,1));
V2 = (1:size(A,1));
V2(H) = 0;
V2 = nonzeros(V2);
%tolerance = 1e-10;
for i=1:size(V,2)
    %disp(V(i));
    pq(V(i)) = floor(pq(V(i))*100000)/100000;
    Pcap(k,V(i)) = floor(Pcap(k,V(i))*100000)/100000;
    %disp(pq(V(i)));
    %disp(Pcap(k,V(i)));
    %while (pq(V(i)) >= Pcap(k,V(i))-tolerance)
    while (pq(V(i)) >= Pcap(k,V(i)))
        if(norm(R(:,V(i)),1)==0)
            C = union(C, V(i));
            break;
        end
        ubu = algo3(k, Pcap(:,V(i)), R(:,V(i)));
        if(pq(V(i))>=ubu)
            C = union(C, V(i));
            break;
        else
            oldru = R(:,V(i));
            tempindex = (oldru>=eta);
            tempindex(H) = 0;
            tempru = oldru.*tempindex;
            Lt = V2(oldru(V2)>=eta);
            total = sum((1-alpha)*bsxfun(@times,oldru(Lt)',A(:,Lt)),2);
            ru = total + oldru - tempru;
            
            oldru(V2) = 0;
            su = oldru+S(:,V(i));
            
            wu = alpha*tempru + W(:,V(i));
            
            pu = sort(wu + PH*su, 'descend');
            Pcap(:,V(i)) = pu(1:K);
            ru = ru - su;
            
            R(:,V(i)) = ru;
            W(:,V(i)) = wu;
            S(:,V(i)) = su;
        end
    end
end

end