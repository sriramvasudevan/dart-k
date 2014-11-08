
%Preprocesses the matrix so that all labels are unique
%Returns it as a hashtable of elements to a list of target vertices
function [out,out_hm] = preprocessforUnique(input,num_nodes_out)

    unique_elems = unique(input);
    if nargin <2 
        num_nodes_out = numel(unique_elems);
    end
    numbermap = containers.Map('KeyType','uint64','ValueType','uint64');
    for i = 1:numel(unique_elems)
       numbermap(unique_elems(i)) = i; 
    end
    [outdeg, indeg] = getDegreeForUnique(input);
    newdeg = outdeg+indeg';
    [~, index_newdeg] = sort(newdeg, 'descend');
    unique_o_elems = index_newdeg(1:num_nodes_out);
    out_hm = containers.Map('KeyType','uint64','ValueType','any');
    out_temp = [];
    for i = 1:size(input,1)
       if mod(i,10000) == 0
           disp(i);
       end
       source = numbermap(input(i,1));
       target = numbermap(input(i,2));
       if ~isempty(find(unique_o_elems==source,1)) && ~isempty(find(unique_o_elems==target,1))
           out_temp = [out_temp; source target];
       end
    end
    unique_elems = unique(out_temp);
    numbermap = containers.Map('KeyType','uint64','ValueType','uint64');
    for i = 1:numel(unique_elems)
       numbermap(unique_elems(i)) = i; 
    end
    out=[];
    for i = 1:size(out_temp,1)
        source = numbermap(out_temp(i,1));
        target = numbermap(out_temp(i,2));
        if out_hm.isKey(source)
            out_hm(source) = [out_hm(source) target];
        else
            out_hm(source) = target;
        end
        out = [out; source target];
    end
end