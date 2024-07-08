function [SE_MR_DCC] = Uplink_OP_MR_WR(squareLength,L,N,K)

%% Define simulation setup

%Number of Monte-Carlo setups
nbrOfSetups = 50; % Valor Estandar: 50

%Number of channel realizations per setup
nbrOfRealizations = 100; % Valor Estandar: 100

    
% %Number of APs 
% L = 100;
% 
% %Number of antennas per AP
% N = 4;
% 
% %Number of UEs in the network
% K = 40;

%Length of coherence block
tau_c = 200;

%Length of pilot sequences
tau_p = 10;

%Compute the prelog factor assuming only uplink data transmission
% prelogFactor = (1-tau_p/tau_c);

%Angular standard deviation in the local scattering model (in radians)
ASD_varphi = deg2rad(15);  %azimuth angle
ASD_theta = deg2rad(15);   %elevation angle

%% Propagation parameters

%Total uplink transmit power per UE (mW)
p = 100;

%Prepare to save simulation results
SE_MR_DCC = zeros(K,nbrOfSetups); %Centralized MR (DCC)

%% Go through all setups
for n = 1:nbrOfSetups
    
    %Display simulation progress
    disp(['Setup ' num2str(n) ' out of ' num2str(nbrOfSetups)]);
    
    %Generate one setup with UEs and APs at random locations
    [~,R,pilotIndex,D,D_small] = generateSetup_border_esquina(squareLength,L,K,N,tau_p,1,n,ASD_varphi,ASD_theta);
    
    %Generate channel realizations with estimates and estimation
    %error correlation matrices
    [Hhat,H,B,C] = functionChannelEstimates(R,nbrOfRealizations,L,K,N,tau_p,pilotIndex,p);  
    
    %% Cell-Free Massive MIMO with DCC
    
    %Compute SE using combiners and results in Section 5 for centralized
    %and distributed uplink operations for DCC
    [SE_MR_cent] = functionComputeSE_uplink_MR_dist(Hhat,H,D,D_small,B,C,tau_c,tau_p,nbrOfRealizations,N,K,L,p,R,pilotIndex);    
    
    %Save SE values
    SE_MR_DCC(:,n) =  SE_MR_cent;
    
    %Remove large matrices at the end of analyzing this setup
    clear Hhat H B C R;
    
end