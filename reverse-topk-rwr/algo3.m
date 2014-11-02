function ubu = algo3(k, pcap, ru)

z = zeros(k,1);
for j=1:k-1
    delta = pcap(k-j) - pcap(k-j+1);
    z(j+1) = z(j) + j*delta;
    if(z(j)<norm(ru,1)<=z(j+1))
        ubu = pcap(k-j) - (z(j+1)-norm(ru,1))/j;
        return;
    end
end
ubu = pcap(1) + (norm(ru,1)-z(k))/k;
return;

end