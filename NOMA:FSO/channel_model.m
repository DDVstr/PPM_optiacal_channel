%channel amplitudes modelling (AmAR block)
const_number = 50;
K=50;
m = 5; % normilizing const
q = 2^m; %length of slots
N = 10; %code length
num_user = 5; %number of users
Q = q* const_number; % overall number of slots
frAR =  randi([1,Q],1,num_user*N); % array of overall number of slots
L_i = randi([500,2000],1,K*N); %Multiple user  access(distance to each user)


%AmAR modelling
L = 2000; %distance approx evaluation (let L = 2000 as a rough example)
lambda = 1550 * 1e-9; %Wavelength (meters, m)
C_n2 = 1e-14; %Refractive index structure coefficient
std_L_y= 0.124*(2*pi/lambda)*L^11/C_n;  %standart deviation of normally distributed length
% L_i_norm = 500:100:2000;
% L_i_rand = L_i_norm(randperm(length(L_i_norm))); %randomly shuffled distance

varA=((2*pi/lambda)^(7/6))*((2000)^(11/6))*(C_n2)+((2*pi/lambda)^(7/6))*((L_i).^(11/6))*(C_n2); 
%считаем дисперсии
meanA=((2*pi/lambda)^(7/6))*((2000)^(11/6))*(C_n2)-((2*pi/lambda)^(7/6))*((L_i).^(11/6))*(C_n2); 
L_h = ((varA).^(1/2)).*randn(1,K*N) + meanA;
AmAR =10.^(L_h/2);



