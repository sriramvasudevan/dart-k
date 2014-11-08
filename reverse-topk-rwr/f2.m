G = zeros(n,n);
for i=1:size(cit_s,1)
    G(cit_s(i,1),cit_s(i,2)) = 1;
end

outdeg = sum(G,2);
indeg = sum(G,1);
a_temp = zeros(size(outdeg));
for i=1:numel(outdeg)
    if outdeg(i)==0
        a_temp(i) = 0;
    else
        a_temp(i) = 1/outdeg(i);
    end
end
A =  bsxfun(@times,a_temp',G');
B = 1;
[sort_indeg, index_indeg] = sort(indeg, 'descend');
[sort_outdeg, index_outdeg] = sort(outdeg, 'descend');

H = cat(2, index_indeg(1:B), index_outdeg(1:B)');
K = 3;
alpha = 0.15;
delta = 0.8;
eta = 10^-4;
eps = 10^-10;

%Offline Indexing
disp('Starting Offline Indexing...');
[Pcap, R, W, S, PH] = algo1(A, K, H, alpha, delta, eta, eps);

disp('Starting Online Querying (q=1, k=2)...');
%Online Querying
q = 1;
k = 2;
[C, Pcap, R, W, S] = algo4(q, k, Pcap, R, W, S, A, K, H, PH, alpha, eta, eps);
disp('Results:');
disp(C);