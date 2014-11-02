function pq = algo2(A, alpha, q, eps)
eq = zeros(size(A,1),1);
eq(q) = 1;
old_x = ones(size(A,1),1);
while(true)
        x = (1-alpha)*A'*old_x + alpha*eq;
        if norm(x-old_x)<eps;
            break;
        end
        old_x = x;
end
pq = x';
end