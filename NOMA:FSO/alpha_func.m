%Modelling reciever block with chosen alpha params
function [desM] = alpha_func( Yrx,al,eps1,eps0 )
% Yrx
sM=sort(Yrx,'descend'); %decending sort of sM arr.

dM=bsxfun(@minus,Yrx,sM(al,:));%diff matrix
desM=(dM>=0)*eps1+(dM<0)*eps0; % reliability matrix with max al in cols.
end