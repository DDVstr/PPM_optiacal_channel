
%Module for generating sequence of finite length
k0 = 2; %word length
q = 10; %symbol sequence of transmitted word
Tx = de2bi([0:q^(k0)-1].',[],q); %chosen transmitted word
m = 2; %Galoi field polynom grade
n1 = 1000; %code length
k1=2;

%Modellling transmitting block Tx (Tx + RS-code)
Tx_GF = gf(Tx,5); %Galois field class of generated MDR code
GF = Tx_GF * makeRSgm(5, k1 ,n1);

%Modelling channel with AWGN noise
k=sqrt((10^(-SNR/10))/(2*log2(q)*Q)); %coefficient to multiply noise to get SNR rate precise
Nm=k*randn(Q,N); %Noise matrix 
Nm1=Nm(1:q,:); %Matrix Nm1 to add to CHm
CHm=sparse([fP,frAR(isINb)],[tP,hIND(isINb)],[ones(1,N),(AmAR(isINb))],q,N);
Y=CHm+Nm1;

%Decision block modelling

E = Y*conj(Y);