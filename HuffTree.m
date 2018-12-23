function [gtree] = HuffTree(fulldict,tree)
%fulldict is the full huffman dictionary which contains three fields
%symbol, frequency and codeword 
%tree is the full huffman tree without removing the unnecessary columns
[r,c]=size(tree);
no_nodes=0;%no of nodes
%constructs a tree visualization structure
%each node has max two children
for i=1:c
    treevis(i)=struct('parent',[],'child1',[],'child2',[]);
end
for i=1:c
   if i~=c
       %the two summed nodes at each iteration share a parent which is the
       %sum if their frequencies
       treevis(c-i+1).parent=tree(r-i+1,i).frequency+tree(r-i,i).frequency;
       no_nodes=no_nodes+1;
   else
       treevis(c-i+1).parent=100;%%the first parent node is 100
       no_nodes=no_nodes+1;
   end
   %assigns the child symbolic nodes to their parent if they exist 
   if strlength(tree(r-i+1,i).symbol)==1
       treevis(c-i+1).child1=tree(r-i+1,i).symbol;
       no_nodes=no_nodes+1;
   end
   if strlength(tree(r-i,i).symbol)==1
       treevis(c-i+1).child2=tree(r-i,i).symbol;
       no_nodes=no_nodes+1;
   end
end
nodesarray=strings(1,no_nodes);%%array of nodes indices
[~,c]=size(treevis);
i=1;
%%gets the names of the nodes and stores them in an array
while i<=no_nodes
    for j=1:c
        if~isempty(treevis(j).parent)
            nodesarray(i)=string(treevis(j).parent);
            i=i+1;
        end
        if~isempty(treevis(j).child1)
            nodesarray(i)=string(treevis(j).child1);
            i=i+1;
        end
        if~isempty(treevis(j).child2)
            nodesarray(i)=string(treevis(j).child2);
            i=i+1;
        end
    end
end
[r,~]=size(fulldict);
levels=0;%no of levels in the binary tree
%finds the longest codeword in order to compute the levels of the binary
%tree
for i=1:r
    if strlength(fulldict(i).codeword)>levels
        levels=strlength(fulldict(i).codeword);
    end
end
nodes=1:2^(levels+1)-1;%all possible nodes of a binary tree of the desired size
L=length(nodes);
gtree=graph;
%constructs a binary tree with all possible paths
for i=1:1/2*(L-1)
    gtree=addedge(gtree,[nodes(i) nodes(i)],[nodes(2*i) nodes(2*i+1)]);
end
nodes_names=strings(1,L);
allsequences=strings;
%defines an array of all the possible paths on the binary tree
for i=1:levels
    allsequences=cat(2,allsequences,bincombinations(i));
end
allsequences(1)=[];
%defines an array of all nodes names on the full binary tree
%the unnamed nodes are left as empty strings
for i=1:L-1
    for j=1:r
        if allsequences(i)==fulldict(j).codeword
            temp=MapCodetoNode(fulldict(j).codeword);
            temp=bin2dec(char(temp));
            nodes_names(temp)=strcat('"',fulldict(j).symbol,'" ',' (',...
string(fulldict(j).frequency),')');
        end
    end
end
%assigns the nodes names to the graph
gtree.Nodes.Names=cellstr(transpose(nodes_names));
edges=zeros(1,length(gtree.Nodes.Names)-1);
for i=2:2:length(edges)
    edges(i)=1;
end
%assigns the weights of the edges to the graph
gtree.Edges.Weight=transpose(edges);
%loops over the whole tree starting from its leaves deleting all the paths
%which are not supposed to exist
for i=levels:-1:1
    m=1;
    codes=string;
    %%finds all the codewords (paths) of size i
    for l=1:r
     if strlength(fulldict(l).codeword)==i
         codes(m)=fulldict(l).codeword;
         tempstring=char(fulldict(l).codeword);
         tempstring=tempstring(1:i-1);
         fulldict(l).codeword=tempstring;
         m=m+1;
     end
    end
     allcodes=bincombinations(i);
     L=length(allcodes);
     index=zeros(1,L);
    %compares the existing paths of size i to all the possible paths of size i
    %in order to determine the indices that are going to be deleted 
     for j=1:length(codes)
         if sum(allcodes==codes(j))==1 
             temp=find(allcodes==codes(j));
             index(temp)=1;
         end
     end
     index=~index;
     for k=L:-1:1
         if index(k)==0
             allcodes(k)=[];
         end
     end
      codes_to_remove=allcodes;
     %removes the extra nodes
     if length(codes_to_remove)~=0
         nodes_to_remove=(MapCodetoNode(codes_to_remove));
         for s=1:length(nodes_to_remove)
             nodes_to_remove(s)=bin2dec(char(nodes_to_remove(s)));
         end
         gtree=rmnode(gtree,double(nodes_to_remove));
     end  
end
end