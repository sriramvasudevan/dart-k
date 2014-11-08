function [indeg, outdeg] = getDegreeForUnique(input)
    unique_elems = unique(input);
    numbermap = containers.Map('KeyType','uint64','ValueType','uint64');
    for i = 1:size(unique_elems)
       numbermap(unique_elems(i)) = i; 
    end
    indeg = zeros(1,size(unique_elems,1));
    outdeg = zeros(size(unique_elems,1),1);
    for i = 1:size(input,1)
       if mod(i,10000) == 0
           disp(i);
       end
       new_elem_id_out = numbermap(input(i,1));
       new_elem_id_in = numbermap(input(i,2));
       indeg(new_elem_id_in) = indeg(new_elem_id_in)+1;
       outdeg(new_elem_id_out) = outdeg(new_elem_id_out)+1;
    end
end