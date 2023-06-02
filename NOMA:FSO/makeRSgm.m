
function Gr=makeRSgm(m,k,n1)
% m--extension power (field GF(2^m))
% k-- number of information  symbols
% n -code length
q=2^m;
% n=q;
d=q-k+1; % Singleton distance (code distance)
% k=k-1;
G=[];
al=gf(2,m); % primitive element in GF(2^M)
% matrix compilation
for ii=1:k
    G = [G;al.^(ii*[0:q-2])];
end

% цикл приводит матрицу к виду, при котором подматрица из первых k столбцов
% -- upper-triangle matrix
for ind1=1:k-1

 for ind2=ind1+1:k
     G(ind2,:)=G(ind2,:)-G(ind1,:)*(G(ind1,ind1)^(-1))*G(ind2,ind1);
     G(ind2,:)=G(ind2,:)*(G(ind2,ind2)^(-1));
 end
end
% цикл приводит матрицу к виду, при котором подматрица из первых k столбцов
% -- eye matrix
for ind1=k:-1:1
for ind2=ind1-1:-1:1
G(ind2,:)=G(ind2,:)-G(ind1,:)*(G(ind1,ind1)^(-1))*G(ind2,ind1);
G(ind2,:)=G(ind2,:)*(G(ind2,ind2)^(-1));
end
end   

Gr=G(:,1:n1);