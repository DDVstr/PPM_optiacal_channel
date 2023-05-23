%channel NOMA model


const_number = 50;
m = 5; % normilizing const
q = 2^m; %length of slots
N = 1000; %code length
L = 2000; %distance approx evaluation (let L = 2000 as a rough example)
num_user = 5; %number of users
Q = q* const_number; % overall number of slots

frAR =  randi([1,Q],1,num_user*N); % array of overall number of slots
L_i = randi([500,2000],15,1);

mean_AmAr = 
std_Amar = sqrt
AmAr = 10.^(l_h/2); %array of amplitude