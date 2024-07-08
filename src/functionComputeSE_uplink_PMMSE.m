function [SE_P_MMSE] = functionComputeSE_uplink_PMMSE(Hhat,H,D,~,~,C,tau_c,tau_p,nbrOfRealizations,N,K,~,p,~,~)
%Compute uplink SE for different receive combining schemes using the capacity
%bound in Theorem 5.1 for the centralized schemes and the capacity bound
%in Theorem 5.4 for the distributed schemes. Compute the genie-aided uplink
%SE from Corollary 5.9 for the centralized operation and from Corollary 5.10 
%for the distributed operation. 
%
%INPUT:
%Hhat              = Matrix with dimension L*N  x nbrOfRealizations x K
%                    where (:,n,k) is the estimated collective channel to
%                    UE k in channel realization n.
%H                 = Matrix with dimension L*N  x nbrOfRealizations x K
%                    with the true channel realizations. The matrix is
%                    organized in the same way as Hhat.
%D                 = DCC matrix for cell-free setup with dimension L x K 
%                    where (l,k) is one if AP l serves UE k and zero otherwise
%D_small           = DCC matrix for small-cell setup with dimension L x K
%                    where (l,k) is one if AP l serves UE k and zero otherwise
%B                 = Matrix with dimension N x N x L x K where (:,:,l,k) is
%                    the spatial correlation matrix of the channel estimate 
%                    between AP l and UE k, normalized by noise variance
%C                 = Matrix with dimension N x N x L x K where (:,:,l,k) is
%                    the spatial correlation matrix of the channel
%                    estimation error between AP l and UE k,
%                    normalized by noise variance
%tau_c             = Length of coherence block
%tau_p             = Length of pilot sequences
%nbrOfRealizations = Number of channel realizations
%N                 = Number of antennas per AP
%K                 = Number of UEs 
%L                 = Number of APs
%p                 = Uplink transmit power per UE (same for everyone)
%R                 = Matrix with dimension N x N x L x K where (:,:,l,k) is
%                    the spatial correlation matrix between AP l and UE k,
%                    normalized by noise
%pilotIndex        = Vector containing the pilot assigned to each UE
%
%OUTPUT:
%SE_MMSE           = SEs achieved with MMSE combining in (5.11)
%SE_P_MMSE         = SEs achieved with P-MMSE combining in (5.16)
%Gen_SE_P_MMSE     = Genie-aided SEs achieved with P-MMSE combining in (5.16)

%
%
%This Matlab function was developed to generate simulation results to:
%
%Ozlem Tugfe Demir, Emil Bjornson and Luca Sanguinetti (2021),
%"Foundations of User-Centric Cell-Free Massive MIMO", 
%Foundations and Trends in Signal Processing: Vol. 14: No. 3-4,
%pp 162-472. DOI: 10.1561/2000000109
%
%This is version 1.0 (Last edited: 2021-01-31)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%monograph as described above.


%Compute the prelog factor assuming only uplink data transmission
prelogFactor = (1-tau_p/tau_c);

%Prepare to store simulation results
SE_P_MMSE = zeros(K,1);


%% Go through all channel realizations
for n = 1:nbrOfRealizations

    %Consider the centralized schemes
    
    
    %Go through all UEs
    for k = 1:K
        
        
        %Determine the set of serving APs for UE k
        servingAPs = find(D(:,k)==1); %cell-free setup
        
        %Compute the number of APs that serve UE k
        La = length(servingAPs);
        
        %Determine which UEs that are served by partially the same set
        %of APs as UE k, i.e., the set in (5.15)
        servedUEs = sum(D(servingAPs,:),1)>=1;
        
        %Extract channel realizations and estimation error correlation
        %matrices for the APs that involved in the service of UE k
        Hallj_active = zeros(N*La,K);
        Hhatallj_active = zeros(N*La,K);
        C_tot_blk = zeros(N*La,N*La);
        C_tot_blk_partial = zeros(N*La,N*La);
        
        for l = 1:La
            Hallj_active((l-1)*N+1:l*N,:) = reshape(H((servingAPs(l)-1)*N+1:servingAPs(l)*N,n,:),[N K]);
            Hhatallj_active((l-1)*N+1:l*N,:) = reshape(Hhat((servingAPs(l)-1)*N+1:servingAPs(l)*N,n,:),[N K]);
            C_tot_blk((l-1)*N+1:l*N,(l-1)*N+1:l*N) = sum(C(:,:,servingAPs(l),:),4);
            C_tot_blk_partial((l-1)*N+1:l*N,(l-1)*N+1:l*N) = sum(C(:,:,servingAPs(l),servedUEs),4);
        end
        
        %Compute P-MMSE combining according to (5.16)
        v = p*((p*(Hhatallj_active(:,servedUEs)*Hhatallj_active(:,servedUEs)')+p*C_tot_blk_partial+eye(La*N))\Hhatallj_active(:,k));
        
        %Compute numerator and denominator of instantaneous SINR in (5.5)
        numerator = p*abs(v'*Hhatallj_active(:,k))^2;
        denominator = p*norm(v'*Hhatallj_active)^2 + v'*(p*C_tot_blk+eye(La*N))*v - numerator;
          
        %Update the SE by computing the instantaneous SE for one
        %channel realization according to (5.4)
        SE_P_MMSE(k) = SE_P_MMSE(k) + prelogFactor*real(log2(1+numerator/denominator))/nbrOfRealizations;     
    end
    
end