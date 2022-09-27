%main code for hdd and measuring error rate between sender and reciever
SER = 0; %nothing to be outputed 
M=3; % bit resolutions
Lavg = 2^M; % Average symbol length 
nsym = 500; % number of PPM symbols 
Lsig=nsym*Lavg; % length of PPM slots
Rb=1e6; % Bit rate
Ts=M/(Lavg*Rb); % slot duration
Tb=1/Rb; % bit duration
EbN0=-10:5; % Energy per slot 
EsN0=EbN0+10*log10(M); % Energy per symbol 
SNR = 10.^(EbN0./10);
for i=1:length(EbN0)
    PPM = generate_PPM(M,nsym);
    MF_out = awgn(PPM,EsN0(i)+3);

    Rx_PPM_th=zeros(1,Lsig);
    Rx_PPM_th(MF_out>0.5)=1;
   % [No_of_Error(i), ser_hdd(i)]= biterr(Rx_PPM_th,PPM);

end
% theoretical calculation 
Pse_ppm_hard=qfunc(sqrt(M*2^M*0.5*SNR)); 
semilogy(EbN0,Pse_ppm_hard,'k--','linewidth',2);

                        