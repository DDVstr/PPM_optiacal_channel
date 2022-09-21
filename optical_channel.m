function PPM=generate_PPM(M,nsym)
% function to generate PPM;
% ‘M’ bit resolution; % ‘nsym’: number of PPM symbol
PPM=[];
for i= 1:nsym
    temp=randint(1,M); % random binary number
    dec_value=bi2de(temp,’left-msb’) % converting to decimal value
    temp2=zeros(1,2^M); % zero sequence of length 2^M
    temp2(dec_value+1)=1;
    % placing a pulse according to decimal value,
    % note that in Matlab index doe snot start from zero, so need to add 1;
    PPM=[PPM temp2]; % PPM symbol
end
end




M=3; % bit resolutions
Lavg=2^M; % Average symbol length
nsym=500; % number of PPM symbols
Lsig=nsym*Lavg; % length of PPM slots
Rb=1e6; % Bit rate
Ts=M/(Lavg*Rb); % slot duration
Tb=1/Rb; % bit duration
EbN0=-10:5; % Energy per slot
EsN0=EbN0+10*log10(M); % Energy per symbol
SNR = 10.^(EbN0./10);
for ii=1:length(EbN0)
    PPM= generate_PPM(M,nsym);
    MF_out=awgn(PPM,EsN0(ii)+3,'measured');
    %% hard decision decoding
    Rx_PPM_th=zeros(1,Lsig);
    Rx_PPM_th(find(MF_out>0.5))=1;
    [No_of_Error(ii) ser_hdd(ii)]= biterr(Rx_PPM_th,PPM);
end