function [SE_MR_dist] = functionComputeSE_uplink_MR_dist(Hhat,H,D,~,B,C,tau_c,tau_p,nbrOfRealizations,N,K,L,p,R,pilotIndex)
%Store the N x N identity matrix
eyeN = eye(N);

%Compute the prelog factor assuming only uplink data transmission
prelogFactor = (1-tau_p/tau_c);

%Prepare to store simulation results
% SE_opt_L_MMSE = zeros(K,1);
% SE_nopt_LP_MMSE = zeros(K,1);
% SE_nopt_MR = zeros(K,1);
% SE_L_MMSE = zeros(K,1);
% SE_LP_MMSE = zeros(K,1);
SE_MR_dist = zeros(K,1);

%Prepare to store the terms that appear in SEs
gki_MR = zeros(K,L,K);
gki2_MR = zeros(K,L,K);
Fk_MR = zeros(L,K);

% gki_L_MMSE = zeros(K,K,L);
% gki2_L_MMSE = zeros(K,K,L);
% Fk_L_MMSE = zeros(L,K);
% 
% gki_LP_MMSE = zeros(K,K,L);
% gki2_LP_MMSE = zeros(K,K,L);
% Fk_LP_MMSE = zeros(L,K);
% 
% gen_gki_MR = zeros(K,L,K,nbrOfRealizations);
% gen_Fk_MR = zeros(L,K,nbrOfRealizations);
% 
% gen_gki_L_MMSE = zeros(K,L,K,nbrOfRealizations);
% gen_Fk_L_MMSE = zeros(L,K,nbrOfRealizations);
% 
% gen_gki_LP_MMSE = zeros(K,L,K,nbrOfRealizations);
% gen_Fk_LP_MMSE = zeros(L,K,nbrOfRealizations);


%% Compute MR closed-form expectations according to Corollary 5.6

%Go through each AP
for l = 1:L
    %Extract which UEs are served by the AP l
    servedUEs = find(D(l,:)==1);
    
    %Go through all UEs served by the AP l
    for ind = 1:length(servedUEs)
        
        %Extract UE index
        k = servedUEs(ind);
        
        
        %Noise scaling according to (5.35)
        Fk_MR(l,k) = trace(B(:,:,l,k));
        
     
        for i = 1:K
            
            %Compute the first term in (5.34)
            gki2_MR(i,l,k) = real(trace(B(:,:,l,k)*R(:,:,l,i))); 
            
            %If UE i shares the same pilot with UE k
            if pilotIndex(k) == pilotIndex(i)
                
                %The term in (5.33)
                gki_MR(i,l,k) = real(trace((B(:,:,l,k)/R(:,:,l,k))*R(:,:,l,i)));
                %The second term in (5.34)
                gki2_MR(i,l,k) = gki2_MR(i,l,k) + (real(trace((B(:,:,l,k)/R(:,:,l,k))*R(:,:,l,i))))^2;
            end
            
        end
        
    end
    
end


% %% Go through all channel realizations
% for n = 1:nbrOfRealizations
% 
%     %Consider the distributed schemes
% 
% 
%     %Go through all APs
%     for l = 1:L
% 
%         %Extract channel realizations from all UEs to AP l
%         Hallj = reshape(H((l-1)*N+1:l*N,n,:),[N K]);
% 
%         %Extract channel estimates from all UEs to AP l
%         Hhatallj = reshape(Hhat((l-1)*N+1:l*N,n,:),[N K]);
% 
%         %Extract which UEs are served by AP l
%         servedUEs = find(D(l,:)==1);
% 
%         %Compute sum of estimation error covariance matrices of the UEs
%         %served by AP l
%         Cserved = sum(C(:,:,l,servedUEs),4);
% 
%         %Compute MR combining according to (5.32)
%         V_MR = Hhatallj(:,servedUEs);
% 
%         %Compute L-MMSE combining according to (5.29)
%         V_L_MMSE = p*((p*(Hhatallj*Hhatallj'+sum(C(:,:,l,:),4))+eyeN)\V_MR);
% 
%         %Compute LP-MMSE combining according to (5.39)
%         V_LP_MMSE = p*((p*(V_MR*V_MR'+Cserved)+eyeN)\V_MR);
% 
%         %Compute the conjugates of the vectors g_{ki} in (5.23) for three
%         %combining schemes above for the considered channel realization
%         TemporMatr_MR = Hallj'*V_MR;
%         TemporMatr_L_MMSE = Hallj'*V_L_MMSE;
%         TemporMatr_LP_MMSE = Hallj'*V_LP_MMSE;
% 
%         %Update the sample mean estimates of the expectations in (5.27) 
%         Fk_L_MMSE(l,servedUEs) = Fk_L_MMSE(l,servedUEs) + vecnorm(V_L_MMSE).^2/nbrOfRealizations;
%         Fk_LP_MMSE(l,servedUEs) = Fk_LP_MMSE(l,servedUEs) + vecnorm(V_LP_MMSE).^2/nbrOfRealizations;
% 
%         %Store the instantaneous combining vector norms for the channel
%         %realization n to be used later
%         gen_Fk_MR(l,servedUEs,n) = vecnorm(V_MR).^2;
%         gen_Fk_L_MMSE(l,servedUEs,n) = vecnorm(V_L_MMSE).^2;
%         gen_Fk_LP_MMSE(l,servedUEs,n) = vecnorm(V_LP_MMSE).^2;
% 
%         %Update the sample mean estimates of the expectations related to g_{ki} in
%         %(5.23) to be used in the SE expression of Theorem 5.4
%         gki_L_MMSE(:,servedUEs,l) = gki_L_MMSE(:,servedUEs,l) + TemporMatr_L_MMSE/nbrOfRealizations;
%         gki_LP_MMSE(:,servedUEs,l) = gki_LP_MMSE(:,servedUEs,l) + TemporMatr_LP_MMSE/nbrOfRealizations;
% 
%         gki2_L_MMSE(:,servedUEs,l) = gki2_L_MMSE(:,servedUEs,l) + abs(TemporMatr_L_MMSE).^2/nbrOfRealizations;
%         gki2_LP_MMSE(:,servedUEs,l) = gki2_LP_MMSE(:,servedUEs,l) + abs(TemporMatr_LP_MMSE).^2/nbrOfRealizations;
% 
%         %Store the instantaneous entries of g_{ki} in (5.23) for the channel
%         %realization n to be used later
%         gen_gki_MR(:,l,servedUEs,n) = TemporMatr_MR;
%         gen_gki_L_MMSE(:,l,servedUEs,n) = TemporMatr_L_MMSE;
%         gen_gki_LP_MMSE(:,l,servedUEs,n) = TemporMatr_LP_MMSE;
% 
% 
% 
%     end    
% end
% 
% %Permute the arrays that consist of the expectations that appear in Theorem
% %5.4 to compute LSFD vectors and the corresponding SEs
% gki_L_MMSE = permute(gki_L_MMSE,[1 3 2]);
% gki_LP_MMSE = permute(gki_LP_MMSE,[1 3 2]);
% gki2_L_MMSE = permute(gki2_L_MMSE,[1 3 2]);
% gki2_LP_MMSE = permute(gki2_LP_MMSE,[1 3 2]);
% 
% 
% 
% %Prepare to store n-opt LSFD vectors to be used later
% a_nopt1 = zeros(L,K);
% a_nopt2 = zeros(L,K);

%% Compute the SEs for Distributed Case
for k = 1:K
    
    %Determine the set of serving APs for UE k
    servingAPs = find(D(:,k)==1);
    %The number of APs that serve UE k 
    La = length(servingAPs);
    
    %Determine which UEs that are served by partially the same set
    %of APs as UE k, i.e., the set in (5.15)
    servedUEs = find(sum(D(servingAPs,:),1)>=1);
    
 
    % %Expected value of g_{kk}, scaled by \sqrt{p} for L-MMSE combining
    % num_vector = conj(vec(sqrt(p)*gki_L_MMSE(k,servingAPs,k)));
    % %Compute the matrix whose inverse is taken in (5.30) using the first-
    % %and second-order moments of the entries in the vectors g_{ki}
    % temporMatr = gki_L_MMSE(:,servingAPs,k)'*gki_L_MMSE(:,servingAPs,k);
    % denom_matrix = p*(diag(sum(gki2_L_MMSE(:,servingAPs,k),1))...
    %     +temporMatr-diag(diag(temporMatr)))...
    %     -num_vector*num_vector'+diag(Fk_L_MMSE(servingAPs,k));
    % 
    % %Compute the opt LSFD according to (5.30)
    % a_opt = denom_matrix\num_vector;
    % 
    % %Compute the corresponding weights for the case without LSFD
    a_dist = ones(La,1);
    % 
    % %Compute the SE achieved with opt LSFD and L-MMSE combining according to
    % %(5.25)
    % SE_opt_L_MMSE(k) = prelogFactor*real(log2(1+abs(a_opt'*num_vector)^2/(a_opt'*denom_matrix*a_opt)));
    % 
    % %Compute the SE achieved with L-MMSE combining and without LSFD according to
    % %(5.25)
    % SE_L_MMSE(k) = prelogFactor*real(log2(1+abs(a_dist'*num_vector)^2/(a_dist'*denom_matrix*a_dist)));
    
    
    

    % %Expected value of g_{kk}, scaled by \sqrt{p} for LP-MMSE combining
    % num_vector = conj(vec(sqrt(p)*gki_LP_MMSE(k,servingAPs,k)));
    % %Compute the denominator matrix to compute SE in Theorem 5.4 using the first-
    % %and second-order moments of the entries in the vectors g_{ki}
    % temporMatr = gki_LP_MMSE(:,servingAPs,k)'*gki_LP_MMSE(:,servingAPs,k);
    % denom_matrix = p*(diag(sum(gki2_LP_MMSE(:,servingAPs,k),1))...
    %     +temporMatr-diag(diag(temporMatr)))...
    %     -num_vector*num_vector'+diag(Fk_LP_MMSE(servingAPs,k));
    % 
    % %Compute the matrix whose inverse is taken in (5.41) using the first-
    % %and second-order moments of the entries in the vectors g_{ki}
    % temporMatr = gki_LP_MMSE(servedUEs,servingAPs,k)'*gki_LP_MMSE(servedUEs,servingAPs,k);
    % 
    % denom_matrix_partial =  p*(diag(sum(gki2_LP_MMSE(servedUEs,servingAPs,k),1))...
    %     +temporMatr-diag(diag(temporMatr)))...
    %     -num_vector*num_vector'+diag(Fk_LP_MMSE(servingAPs,k));
    
    
    % %Compute the n-opt LSFD according to (5.41) for LP-MMSE combining
    % a_nopt = denom_matrix_partial\num_vector;
    % 
    % %Compute the SE achieved with n-opt LSFD and LP-MMSE combining according to
    % %(5.25)
    % SE_nopt_LP_MMSE(k) = prelogFactor*real(log2(1+abs(a_nopt'*num_vector)^2/(a_nopt'*denom_matrix*a_nopt)));
    % %Compute the SE achieved with LP-MMSE combining and without LSFD according to
    % %(5.25)
    % SE_LP_MMSE(k) = prelogFactor*real(log2(1+abs(a_dist'*num_vector)^2/(a_dist'*denom_matrix*a_dist)));
    % 
    % %Store the n-opt LSFD vector for LP-MMSE combining to be used later
    % a_nopt1(servingAPs,k) = a_nopt;
    
    
 
    %Expected value of g_{kk}, scaled by \sqrt{p} for local MR combining
    num_vector = vec(sqrt(p)*gki_MR(k,servingAPs,k));
    %Compute the denominator matrix to compute SE in Theorem 5.4 using the first-
    %and second-order moments of the entries in the vectors g_{ki}
    temporMatrrr =  gki_MR(:,servingAPs,k).'*conj(gki_MR(:,servingAPs,k));
    denom_matrix = p*(diag(sum(gki2_MR(:,servingAPs,k),1))...
        +temporMatrrr-diag(diag(temporMatrrr)))...
        -num_vector*num_vector'...
        +diag(Fk_MR(servingAPs,k));
    
    %Compute the matrix whose inverse is taken in (5.41) using the first-
    %and second-order moments of the entries in the vectors g_{ki}
    temporMatrrr =  gki_MR(servedUEs,servingAPs,k).'*conj(gki_MR(servedUEs,servingAPs,k));
    
    denom_matrix_partial =  p*(diag(sum(gki2_MR(servedUEs,servingAPs,k),1))...
        +temporMatrrr-diag(diag(temporMatrrr)))...
        -num_vector*num_vector'...
        +diag(Fk_MR(servingAPs,k));
    
    
    %Compute the n-opt LSFD according to (5.41) for local MR combining
    a_nopt = denom_matrix_partial\num_vector;
    
    % %Compute the SE achieved with n-opt LSFD and local MR combining according to
    % %(5.25)
    % SE_nopt_MR(k) = prelogFactor*real(log2(1+abs(a_nopt'*num_vector)^2/(a_nopt'*denom_matrix*a_nopt)));
    %Compute the SE achieved with local MR combining and without LSFD according to
    %(5.25)
    SE_MR_dist(k) = prelogFactor*real(log2(1+abs(a_dist'*num_vector)^2/(a_dist'*denom_matrix*a_dist)));
    
    %Store the n-opt LSFD vector for local MR combining to be used later
    % a_nopt2(servingAPs,k) = a_nopt;
    
    
end

%Remove unused large arrays
clear gki_MR gki2_MR gki_L_MMSE gki2_L_MMSE gki_LP_MMSE gki2_LP_MMSE;
clear gen_gki_MR gen_Fk_MR gen_gki_L_MMSE gen_Fk_L_MMSE gen_gki_LP_MMSE gen_Fk_LP_MMSE;
