%% Information Theory Project
%%Read from file
fileid = fopen('Test_text_file.txt','r'); %finds the file ID
data=fscanf(fileid,'%c'); %reads the file writing each char into an array
fclose(fileid);
%The only allowed characters are lower case English characters a-z,
%the symbols ( ) . , / - and space
% define an array of the allowed chars
chars=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t',...
'u','v','w','x','y','z','(',')','.',',','/','-',' '];
stringchars = [string('a'),string('b'),string('c'),string('d'),string('e'),string('f')...
,string('g'),string('h'),string('i'),string('j'),string('k'),string('l'),string('m'),...
string('n'),string('o'),string('p'),string('q'),string('r'),string('s'),string('t'),...
string('u'),string('v'),string('w'),string('x'),string('y'),string('z'),string('('),...
string(')'),string('.'),string(','),string('/'),string('-'),string(' ')];

%% Probability of Symbols
prob=CalculateCharProb(data,chars);%vector of probability symbols
%the first 26 entries are the probabilites of the 26 lowercase english letters
%the rest of the entries are the probabilities of ( ) . , / - and space in
%the same order
entropy= Entropy(prob);
%% Fixed Length Code
wordlength=ceil(log(length(chars))/log(2));
averagelength=sum(prob*wordlength);
efficiency=entropy/averagelength;
%% Huffman Enoding and Decoding
[dict,averagelenHuff,~, fulldict, tree]=HuffDict(stringchars,prob,1);
encoded=HuffEncode(data,dict);
decoded=HuffDecode(encoded,dict);
efficiencyHuff=entropy/averagelenHuff;
%% Output to a file
fileid1 = fopen('decodedHuff.txt','w'); %finds the file ID
fwrite(fileid1,char(decoded),'char');%writes the decoded text into the file
fclose(fileid1);%closes the file
%% Tree Visualization
g=HuffTree(fulldict,tree);
plot(g,'Nodelabel',g.Nodes.Names,'Edgelabel',g.Edges.Weight,'NodeColor','r','EdgeColor','r');
%% Example on Variance
% assume a discrete source whose alphabet is {a,b,c,d,e}, and 
%probability distribution is [0.4 0.2 0.2 0.1 0.1] 
newstringchars=[string('a'),string('b'),string('c'),string('d'),string('e')];
newprob=[0.4 0.2 0.2 0.1 0.1];
%% High Variance
[dict1,averagelenHuff1,variance1, fulldict1, tree1]=HuffDict(newstringchars,newprob,1);
g1=HuffTree(fulldict1,tree1);
plot(g1,'Nodelabel',g1.Nodes.Names,'Edgelabel',g1.Edges.Weight,'NodeColor','r','EdgeColor','r');
disp(averagelenHuff1);
disp(variance1);
%% Low Variance
[dict2,averagelenHuff2,variance2, fulldict2, tree2]=HuffDict(newstringchars,newprob,0);
g2=HuffTree(fulldict2,tree2);
plot(g2,'Nodelabel',g2.Nodes.Names,'Edgelabel',g2.Edges.Weight,'NodeColor','r','EdgeColor','r');
disp(averagelenHuff2);
disp(variance2);
