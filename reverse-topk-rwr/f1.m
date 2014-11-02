G = [0, 1, 0, 1, 0, 1;
1, 0, 1, 0, 0, 0;
1, 1, 0, 0, 0, 0;
0, 1, 0, 0, 1, 0;
0, 1, 0, 0, 0, 0;
0, 1, 0, 1, 0, 0];
outdeg = sum(G, 2);
indeg = sum(G,1);
a_temp = outdeg.^-1;
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
[Pcap, R, W, S, PH] = algo1(A, K, H, alpha, delta, eta, eps);

%Online Querying
q = 1;
k = 2;
[C, Pcap, R, W, S] = algo4(q, k, Pcap, R, W, S, A, K, H, PH, alpha, eta, eps);
disp(C);