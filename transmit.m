
%Module for generating sequence of finite length
k0 = 2; %word length
q = 16; %symbol sequence of transmitted word

%coeff = 0.25:0.04:1; %testing coefficient for 

al = q*0.75;

Tx = de2bi([0:q^(k0)-1].',[],q); %chosen transmitted word
m = log2(q); %Galoi field polynom grade
n1 = 14; %code length
k1=2;
K = 20;
Q = 4096;
L = 2000; %distance approx evaluation (let L = 2000 as a rough example)
lambda = 1550 * 1e-9; %Wavelength (meters, m)
C_n2 = 1e-14; %Refractive index structure coefficient
std_L_y= 0.124*(2*pi/lambda)*L^11/C_n2;  %standart deviation of normally distributed length

%Modellling transmitting block Tx (Tx + RS-code)
Tx_GF = gf(Tx,m); %Galois field class of generated MDR code
GF = Tx_GF * makeRSgm(m, k1 ,n1);
CB = double(GF.x+1);
hIND = repmat([1:n1].',K,1).';
%modified code book
CD = bsxfun(@plus,CB,[0:n1-1]*q); 


Prob_err_rate = []; 
Prob_rej_rate = [];

Prob_rej_rate_al = [];
Prob_err_rate_al = [];

for SNR = -10:2:-2
    err_counter = 0;
    err_reject  = 0;
    block_count = 0;
    err_rej_al  = 0;
    err_count_al= 0;

    while (err_counter < 200) && (block_count<1e5)
        L_i = randi([500,2000],1,K*n1);
        varA=((2*pi/lambda)^(7/6))*((2000)^(11/6))*(C_n2)+((2*pi/lambda)^(7/6))*((L_i).^(11/6))*(C_n2); 
        %считаем дисперсии
        meanA=((2*pi/lambda)^(7/6))*((2000)^(11/6))*(C_n2)-((2*pi/lambda)^(7/6))*((L_i).^(11/6))*(C_n2); 
        L_h = ((varA).^(1/2)).*randn(1,K*n1) + meanA;
        AmAR =10.^(L_h/2);
        frAR = randi([1,Q],1,K*n1);
        fP_ind = randi([1, q^k0],1,1);
        fP = CB(fP_ind,:);
        block_count  = block_count + 1;
        tP = 1:n1; 
        isINb = (frAR<=q);
        k=sqrt((10^(-SNR/10))/(2*log2(q)));
        Nm=k*randn(Q,n1);
        Nm1=Nm(1:q,:);
        a=ones(1,sum(isINb));
        b = [ones(1,n1),[1000*ones(1,sum(isINb))]];
        %display(a)
        CHm=sparse([fP,frAR(isINb)],[tP,hIND(isINb)],[ones(1,n1),(AmAR(isINb))],q,n1);
        Y=CHm+Nm1;
        %reciver without alpha condition
        E = Y.*conj(Y);
        CD_V = sum(E(CD).');
        max_index_position = (CD_V == max(CD_V));
        %reciever with alpha condition
        D=alpha_func(E,al,1,0);
        CD_V2 = sum(D(CD).');
        max_index_pos_al = (CD_V2 == max(CD_V2));
        %Decision block modelling
        %measuring probability rejection and probability error
        if sum(max_index_position)~=1
            err_reject = err_reject + 1;
        else
            if find(max_index_position)~= fP_ind
                err_counter =  err_counter + 1; 
%                 CB(find(max_index_position),:)
%                 fP
%                 pause;
            end
        end
        %measuring probability rejection and error rate with alpha
        %condition
         if sum(max_index_pos_al)~=1
            err_rej_al = err_rej_al + 1;
        else
            if find(max_index_pos_al)~= fP_ind
                err_count_al =  err_count_al + 1; 
%                 CB(find(max_index_position),:)
%                 fP
%                 pause;
            end
        end
    end


    Prob_rej_rate = [Prob_rej_rate,err_reject/block_count];
    Prob_err_rate = [Prob_err_rate,err_counter/block_count];
    Prob_rej_rate_al = [Prob_rej_rate_al,err_rej_al/block_count];
    Prob_err_rate_al = [Prob_err_rate_al,err_count_al/block_count];
    %probality measuring
end
snr = -10:2:-2;
semilogy(snr,Prob_err_rate,'b-', snr , Prob_err_rate_al ,'r-'); %probability error rate to block
grid on;
xlim([-10,-2]);
ylabel('P_e');
xlabel('SNR, (dB)')
title(['Probability of error over FSO/MISO channel'])
legend('Rx','Rx-alpha','Location','northeast')


% L_i_norm = 500:100:2000;
% L_i_rand = L_i_norm(randperm(length(L_i_norm))); %randomly shuffled distance


