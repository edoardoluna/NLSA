function [ model, In, Out ] = climateNLSAModel_ose( experiment )
%% CLIMATENLSAMODEL_OSE NLSA model with out-of-sample extension (OSE) for
%  for climate datasets
% 
%  In and Out are data structures containing the in-sample and out-of-sample model parameters, respectively
%
%  The following scripts are provided for data import: 
%
%      hadisstData.m: HadISST1 dataset  
%      noaaData.m:    NOAA 20th Century Reanalysis dataset
%
%  For additional information on the arguments of nlsaModel_den_ose( ... ) 
%  see 
%
%      nlsa/classes/nlsaModel_base/parseTemplates.m
%      nlsa/classes/nlsaModel/parseTemplates.m
%      nlsa/classes/nlsaModel_ose/parseTemplates.m
% 
% Structure fields Src represent different physical variables (e.g., SST) 
% employed in the kernel definition
%
% Structure fields Res represent different realizations (ensemble members)
%
% For HadISST1: Longitude range is [ 0.5 359.5 ] at 1 degree increments
%               Latitude range is [ -89.5 89.5 ] at 1 degree increements
%               Date range is Jan 1870 to Feb 2019 at 1 month increments 
%               
% For NOAA: Longitude range is [ 0 359 ] at 1 degree increments
%           Latitude range is [ -89 89 ] at 1 degree increments
%           Date range is is Jan 1854 to Feb 2019  at 1 month increments
%
% For GPCP1DDv1.2: Longitude range is [ 0.5 359.5 ] at 1 degree increments
%                  Latitude range is [ -89.5 89.5 ] at 1 degree increements
%                  Date range is 01 Oct 1996 to 31 Oct 2015 at 1 day increments 
%
% Modified 2019/08/24
 
if nargin == 0
    experiment = 'ip_sst'; % Indo-Pacific SST
end


switch experiment

    % INDO-PACIFIC SST
    case 'ip_sst'

        % In-sample dataset parameters 
        % Source (covariate) data is area-weighted Indo-Pacific SST
        % Target (response) data is Nino 3.4 index
        In.tFormat             = 'yyyymm';    % time format
        In.freq                = 'monthly'; % sampling frequency
        %In.Res( 1 ).tLim       = { '187001' '197712' }; % time limit  
        %In.Res( 1 ).tLim       = { '187001' '198712' }; % time limit  
        In.Res( 1 ).tLim       = { '187001' '201312' }; % time limit  
        %In.Res( 1 ).tLim       = { '187001' '200712' }; % time limit  
        In.Res( 1 ).experiment = 'hadisst';      % NOAA dataset
        In.Src( 1 ).field      = 'sstw';       % physical field
        In.Src( 1 ).xLim       = [ 28 290 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -60  20 ]; % latitude limits
        In.Trg( 1 ).field      = 'sstmawav_198101-201012';      % physical field
        In.Trg( 1 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -5 5 ]; % latitude limits

        % Out-of-sample dataset parameters
        %Out.Res( 1 ).tLim      = { '200801' '201902' }; % time limits (years)
        Out.Res( 1 ).tLim      = { '201301' '201902' }; % time limits (years)
        Out.Res( 1 ).experiment = 'hadisst';    % NOAA dataset

        % NLSA parameters, in-sample data
        In.Src( 1 ).idxE      = 1 : 12;    % delay embedding indices 
        In.Src( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Src( 1 ).nXA       = 1;  % samples to leave out after main interval
        In.Src( 1 ).fdOrder   = 2;         % finite-difference order 
        In.Src( 1 ).fdType    = 'central'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Trg( 1 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Res( 1 ).nB        = 1;   % partition batches
        In.Res( 1 ).nBRec     = 1; % batches for reconstructed data
        In.nN           = 0;   % nearest neighbors; defaults to max. value if 0
        In.lDist        = 'cone';   % local distance
        In.tol          = 0;      % 0 distance threshold (for cone kernel)
        In.zeta         = 0.995;  % cone kernel parameter 
        In.coneAlpha    = 1;      % velocity exponent in cone kernel
        In.nNS          = In.nN;  % nearest neighbors for symmetric distance
        %In.diffOpType   = 'gl_mb_bs'; % diffusion operator type
        In.diffOpType   = 'gl'; % diffusion operator type
        In.epsilon      = 2;          % kernel bandwidth parameter 
        In.epsilonB     = 2;          % kernel bandwidth base
        In.epsilonE     = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon     = 200;      % number of exponents for bandwidth tuning
        In.alpha        = 0.5;        % diffusion maps normalization 
        In.nPhi         = 1001;     % diffusion eigenfunctions to compute
        In.nPhiPrj      = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec    = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD    = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec     = 1 : 1;    % SVD termporal patterns for reconstruction

        % NLSA parameters, out-of-sample data
        Out.Res( 1 ).nB  = 1; % batches to partition the in-sample data (realization 1)
        Out.Res( 1 ).nBRec = 1;      % batches for reconstructed data
    
    % INDO-PACIFIC SST "OPERATIONAL" FORECAST
    case 'ip_sst_operational'

        % In-sample dataset parameters 
        % Source (covariate) data is area-weighted Indo-Pacific SST
        % Target (response) data is Nino 3.4 index
        In.tFormat             = 'yyyymm';    % time format
        In.freq                = 'monthly'; % sampling frequency
        In.Res( 1 ).tLim       = { '187001' '201705' }; % time limit  
        In.Res( 1 ).experiment = 'noaa';      % NOAA dataset
        In.Src( 1 ).field      = 'sstaw_198101-201012';       % physical field
        In.Src( 1 ).xLim       = [ 28 290 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -60  20 ]; % latitude limits
        In.Trg( 1 ).field      = 'sstawav_198101-201012';      % physical field
        In.Trg( 1 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -5 5 ]; % latitude limits

        % Out-of-sample dataset parameters
        Out.Res( 1 ).tLim       = { '201705' '201906' }; % time limits (years)
        Out.Res( 1 ).experiment = 'noaa';    % NOAA dataset

        % NLSA parameters, in-sample data
        In.Src( 1 ).idxE      = 1 : 24;    % delay embedding indices 
        In.Src( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Src( 1 ).nXA       = 1;  % samples to leave out after main interval
        In.Src( 1 ).fdOrder   = 2;         % finite-difference order 
        In.Src( 1 ).fdType    = 'central'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Trg( 1 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        

        In.Res( 1 ).nB        = 1;   % partition batches
        In.Res( 1 ).nBRec     = 1; % batches for reconstructed data
        In.nN           = 0;   % nearest neighbors; defaults to max. value if 0
        In.lDist        = 'cone';   % local distance
        In.tol          = 0;      % 0 distance threshold (for cone kernel)
        In.zeta         = 0.995;  % cone kernel parameter 
        In.coneAlpha    = 1;      % velocity exponent in cone kernel
        In.nNS          = In.nN;  % nearest neighbors for symmetric distance
        %In.diffOpType   = 'gl_mb_bs'; % diffusion operator type
        In.diffOpType   = 'gl'; % diffusion operator type
        In.epsilon      = 1;          % kernel bandwidth parameter 
        In.epsilonB     = 2;          % kernel bandwidth base
        In.epsilonE     = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon     = 200;      % number of exponents for bandwidth tuning
        In.alpha        = 1;        % diffusion maps normalization 
        In.nPhi         = 1001;     % diffusion eigenfunctions to compute
        In.nPhiPrj      = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec    = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD    = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec     = 1 : 1;    % SVD termporal patterns for reconstruction

        % NLSA parameters, out-of-sample data
        Out.Res( 1 ).nB  = 1; % batches to partition the in-sample data (realization 1)
        Out.Res( 1 ).nBRec = 1;      % batches for reconstructed data
    

    % INDO-PACIFIC SST - NINO INDICES AS TARGET DATA
    case 'ip_sst_nino'

        % In-sample dataset parameters 
        % Source (covariate) data is area-weighted Indo-Pacific SST
        % Target (response) data are various Nino indices
        In.tFormat             = 'yyyymm';    % time format
        In.freq                = 'monthly';   % sampling frequency
        In.Res( 1 ).tLim       = { '187001' '200712' }; % time limit  
        In.targetComponentName = 'ninoRegions';
        In.Res( 1 ).experiment = 'noaa';      % NOAA dataset
        % Indo-Pacific SST
        In.Src( 1 ).field      = 'sstw';      % physical field
        In.Src( 1 ).xLim       = [ 28 290 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -60  20 ]; % latitude limits
        % Nino 3.4 index
        In.Trg( 1 ).field      = 'sstmawav_198101-201012';      % physical field
        In.Trg( 1 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 3.4 region SST
        In.Trg( 2 ).field      = 'sstwav';      % physical field
        In.Trg( 2 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 2 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 1+2 region SST
        In.Trg( 3 ).field      = 'sstwav';      % physical field
        In.Trg( 3 ).xLim       = [ 270 280 ];  % longitude limits
        In.Trg( 3 ).yLim       = [ -10 0 ]; % latitude limits
        % Nino 3 region SST
        In.Trg( 4 ).field      = 'sstwav';      % physical field
        In.Trg( 4 ).xLim       = [ 210 270 ];  % longitude limits
        In.Trg( 4 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 4 region SST
        In.Trg( 5 ).field      = 'sstwav';      % physical field
        In.Trg( 5 ).xLim       = [ 160 210 ];  % longitude limits
        In.Trg( 5 ).yLim       = [ -5 5 ]; % latitude limits


        % Out-of-sample dataset parameters
        Out.Res( 1 ).tLim      = { '200801' '201906' }; % time limits (years)
        Out.Res( 1 ).experiment = 'noaa';    % NOAA dataset

        % NLSA parameters, in-sample data
        % Indo-Pacific SST
        In.Src( 1 ).idxE      = 1 : 18;    % delay embedding indices 
        In.Src( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Src( 1 ).nXA       = 1;  % samples to leave out after main interval
        In.Src( 1 ).fdOrder   = 2;         % finite-difference order 
        In.Src( 1 ).fdType    = 'central'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3.4 index
        In.Trg( 1 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3.4 region SST
        In.Trg( 2 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 2 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 2 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 2 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 2 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 2 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 1+2 region SST
        In.Trg( 3 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 3 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 3 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 3 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 3 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 3 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3 region SST
        In.Trg( 4 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 4 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 4 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 4 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 4 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 4 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 4 region SST
        In.Trg( 5 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 5 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 5 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 5 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 5 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 5 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Res( 1 ).nB        = 1;   % partition batches
        In.Res( 1 ).nBRec     = 1; % batches for reconstructed data
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.lDist      = 'cone';   % local distance
        In.tol        = 0;      % 0 distance threshold (for cone kernel)
        In.zeta       = 0.995;  % cone kernel parameter 
        In.coneAlpha  = 1;      % velocity exponent in cone kernel
        In.nNS        = In.nN;  % nearest neighbors for symmetric distance
        In.diffOpType = 'gl';   % diffusion operator type
        In.epsilon    = 3;          % kernel bandwidth parameter 
        In.epsilonB   = 2;          % kernel bandwidth base
        In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon   = 200;      % number of exponents for bandwidth tuning
        In.alpha      = 0.5;        % diffusion maps normalization 
        In.nPhi       = 1001;     % diffusion eigenfunctions to compute
        In.nPhiPrj    = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec  = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD  = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec   = 1 : 1;    % SVD termporal patterns for reconstruction

        % NLSA parameters, out-of-sample data
        Out.Res( 1 ).nB  = 1; % batches to partition the in-sample data (realization 1)
        Out.Res( 1 ).nBRec = 1;      % batches for reconstructed data

    % INDO-PACIFIC SST CONTROL - NINO INDICES AS TARGET DATA
    case 'ip_sst_control_nino'

        % In-sample dataset parameters 
        % Source (covariate) data is area-weighted Indo-Pacific SST
        % Target (response) data are various Nino indices
        In.tFormat             = 'yyyymm';    % time format
        In.freq                = 'monthly';   % sampling frequency
        In.Res( 1 ).tLim       = { '000101' '119912' }; % time limit  
        In.targetComponentName = 'ninoRegions';
        In.Res( 1 ).experiment = 'ccsm4_b40.1850';      % NOAA dataset
        % Indo-Pacific SST
        In.Src( 1 ).field      = 'sstw';      % physical field
        In.Src( 1 ).xLim       = [ 28 290 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -60  20 ]; % latitude limits
        % Nino 3.4 index
        In.Trg( 1 ).field      = 'sstmawav_000101-130012';      % physical field
        In.Trg( 1 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 3.4 region SST
        In.Trg( 2 ).field      = 'sstwav';      % physical field
        In.Trg( 2 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 2 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 1+2 region SST
        In.Trg( 3 ).field      = 'sstwav';      % physical field
        In.Trg( 3 ).xLim       = [ 270 280 ];  % longitude limits
        In.Trg( 3 ).yLim       = [ -10 0 ]; % latitude limits
        % Nino 3 region SST
        In.Trg( 4 ).field      = 'sstwav';      % physical field
        In.Trg( 4 ).xLim       = [ 210 270 ];  % longitude limits
        In.Trg( 4 ).yLim       = [ -5 5 ]; % latitude limits
        % Nino 4 region SST
        In.Trg( 5 ).field      = 'sstwav';      % physical field
        In.Trg( 5 ).xLim       = [ 160 210 ];  % longitude limits
        In.Trg( 5 ).yLim       = [ -5 5 ]; % latitude limits


        % Out-of-sample dataset parameters
        Out.Res( 1 ).tLim      = { '120001' '121212' }; % time limits (years)
        Out.Res( 1 ).experiment = 'ccsm4_b40.1850';    % NOAA dataset

        % NLSA parameters, in-sample data
        % Indo-Pacific SST
        In.Src( 1 ).idxE      = 1 : 18;    % delay embedding indices 
        In.Src( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Src( 1 ).nXA       = 1;  % samples to leave out after main interval
        In.Src( 1 ).fdOrder   = 2;         % finite-difference order 
        In.Src( 1 ).fdType    = 'central'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3.4 index
        In.Trg( 1 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3.4 region SST
        In.Trg( 2 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 2 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 2 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 2 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 2 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 2 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 1+2 region SST
        In.Trg( 3 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 3 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 3 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 3 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 3 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 3 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 3 region SST
        In.Trg( 4 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 4 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 4 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 4 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 4 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 4 ).embFormat = 'overlap'; % storage format for delay embedding
        % Nino 4 region SST
        In.Trg( 5 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 5 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 5 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 5 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 5 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 5 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Res( 1 ).nB        = 1;   % partition batches
        In.Res( 1 ).nBRec     = 1; % batches for reconstructed data
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.lDist      = 'cone';   % local distance
        In.tol        = 0;      % 0 distance threshold (for cone kernel)
        In.zeta       = 0.995;  % cone kernel parameter 
        In.coneAlpha  = 1;      % velocity exponent in cone kernel
        In.nNS        = In.nN;  % nearest neighbors for symmetric distance
        In.diffOpType = 'gl';   % diffusion operator type
        In.epsilon    = 1;          % kernel bandwidth parameter 
        In.epsilonB   = 2;          % kernel bandwidth base
        In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon   = 200;      % number of exponents for bandwidth tuning
        In.alpha      = 0.5;        % diffusion maps normalization 
        In.nPhi       = 3001;     % diffusion eigenfunctions to compute
        In.nPhiPrj    = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec  = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD  = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec   = 1 : 1;    % SVD termporal patterns for reconstruction

        % NLSA parameters, out-of-sample data
        Out.Res( 1 ).nB  = 1; % batches to partition the in-sample data (realization 1)
        Out.Res( 1 ).nBRec = 1;      % batches for reconstructed data



    % SOUTH ASIAN SUMMER MONSOON PRECIP
    case 'monsoon_precip'

        % In-sample dataset parameters 
        % Source (covariate) data is South Asian summer Monsoon precip
        % Target (response) data is South Asian summer Monsoon precip
        In.tFormat             = 'yyyymmdd';    % time format
        In.freq                = 'daily';       % sampling frequency
        In.Res( 1 ).tLim       = { '19961001' '20101231' }; % time limit  
        In.Res( 1 ).experiment = 'gpcp_1dd_v1.2';      % GPCP dataset
        % South Asian summer Monsoon domain 
        In.Src( 1 ).field      = 'precip';       % physical field
        In.Src( 1 ).xLim       = [ 30 160 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -20 40 ]; % latitude limits
        % South Asian summer Monsoon domain
        In.Trg( 1 ).field      = 'precip';      % physical field
        In.Trg( 1 ).xLim       = [ 30 160 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -20 40 ]; % latitude limits

        % Out-of-sample dataset parameters
        Out.Res( 1 ).tLim      = { '20110101' '20151031' }; % time limits (years)
        Out.Res( 1 ).experiment = 'gpcp_1dd_v1.2';    % NOAA dataset

        % NLSA parameters, in-sample data
        % South Asian summer Monsoon domain 
        In.Src( 1 ).idxE      = 1 : 64;    % delay embedding indices 
        In.Src( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Src( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Src( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Src( 1 ).fdType    = 'backward'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        % South Asian summer Monsoon domain 
        In.Trg( 1 ).idxE      = 1 : 1;     % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;   % samples to leave out before main interval
        In.Trg( 1 ).nXA       = 0;  % samples to leave out after main interval
        In.Trg( 1 ).fdOrder   = 1;         % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap'; % storage format for delay embedding
        In.Res( 1 ).nB        = 1;   % partition batches
        In.Res( 1 ).nBRec     = 1; % batches for reconstructed data
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.nN         = 0;   % nearest neighbors; defaults to max. value if 0
        In.lDist      = 'l2';   % local distance
        In.tol        = 0;      % 0 distance threshold (for cone kernel)
        In.zeta       = 0.995;  % cone kernel parameter 
        In.coneAlpha  = 1;      % velocity exponent in cone kernel
        In.nNS        = In.nN;  % nearest neighbors for symmetric distance
        In.diffOpType = 'gl_mb_bs'; % diffusion operator type
        In.epsilon    = 1;          % kernel bandwidth parameter 
        In.epsilonB   = 2;          % kernel bandwidth base
        In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon   = 200;      % number of exponents for bandwidth tuning
        In.alpha      = 0.5;        % diffusion maps normalization 
        In.nPhi       = 101;     % diffusion eigenfunctions to compute
        In.nPhiPrj    = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec  = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD  = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec   = 1 : 1;    % SVD termporal patterns for reconstruction

        % NLSA parameters, out-of-sample data
        Out.Res( 1 ).nB  = 1; % batches to partition the in-sample data (realization 1)
        Out.Res( 1 ).nBRec = 1;      % batches for reconstructed data


end


%% ROOT DIRECTORY NAMES
inPath   = fullfile( pwd, 'data/raw' );  % in-sample data
outPath  = fullfile( pwd, 'data/raw' );  % out-of-sample data
nlsaPath = fullfile( pwd, 'data/nlsa' ); % nlsa output

%% ABBREVIATED SOURCE AND TARGET COMPONENT NAMES
componentNames = {};
if isfield( In, 'sourceComponentName' )
    componentNames = [ componentNames ...
                       'sourceComponentName' In.sourceComponentName ];
end
if isfield( In, 'targetComponentName' )
    componentNames = [ componentNames ...
                       'targetComponentName' In.targetComponentName ];
end

%% DELAY-EMBEDDING ORIGINGS
In.nC  = numel( In.Src ); % number of source components
In.nCT = numel( In.Trg ); % number of target compoents

% Maximum number of delay embedding lags, sample left out in the 
% beginning/end of the analysis interval for source data
In.nE = In.Src( 1 ).idxE( end ); 
In.nXB = In.Src( 1 ).nXB; 
In.nXA = In.Src( 1 ).nXA;
for iC = 2 : In.nC
    In.nE = max( In.nE, In.Src( iC ).idxE( end ) );
    In.nXB = max( In.nXB, In.Src( iC ).nXB );
    In.nXA = max( In.nXA, In.Src( iC ).nXA );
end

% Maximum number of delay embedding lags, sample left out in the 
% beginning/end of the analysis interval for targe data
nETMin  = In.Trg( 1 ).idxE( end ); % minimum number of delays for target data
In.nET  = In.Trg( 1 ).idxE( end ); % maximum number of delays for target data
In.nXBT = In.Trg( 1 ).nXB;
In.nXAT = In.Trg( 1 ).nXA;
for iC = 2 : In.nCT
    In.nET = max( In.nET, In.Trg( iC ).idxE( end ) );
    nETMin = min( In.nET, In.Trg( iC ).idxE( end ) );
    In.nXBT = min( In.nXBT, In.Trg( iC ).nXB );
    In.nXAT = min( In.nXAT, In.Trg( iC ).nXA );
end
nEMax = max( In.nE, In.nET );
nXBMax = max( In.nXB, In.nXBT );
nXAMax = max( In.nXA, In.nXAT );

%% NUMBER OF STAMPLES AND TIMESTAMPS FOR IN-SAMPLE DATA
In.nR  = numel( In.Res ); % number of realizations, in-sample data
% Number of samples and timestaamps for in-sample data
nSETot = 0;
idxT1 = zeros( 1, In.nR );
tNum = cell( 1, In.nR ); % Matlab serial date numbers
for iR = In.nR : -1 : 1
    limNum = datenum( In.Res( iR ).tLim, In.tFormat );
    switch In.freq
    case 'daily'
        tNum{ iR } = limNum( 1 ) : limNum( 2 ); 
        In.Res( iR ).nS = numel( tNum{ iR } ); % number of daily samples
    case 'monthly'
        In.Res( iR ).nS   = months( limNum( 1 ), limNum( 2 ) ) + 1; % number of monthly samples
        tNum{ iR } = datemnth( limNum( 1 ), 0 : In.Res( iR ).nS - 1 ); 
    end
    In.Res( iR ).idxT1 = nEMax + nXBMax;     % time origin for delay embedding
    idxT1( iR ) = In.Res( iR ).idxT1;
    In.Res( iR ).nSE = In.Res( iR ).nS - In.Res( iR ).idxT1 + 1 - nXAMax; % sample number after embedding
    nSETot = nSETot + In.Res( iR ).nSE;
    In.Res( iR ).nSRec = In.Res( iR ).nSE + nETMin - 1; % sample number for reconstruction 
end
if In.nN == 0
   In.nN = nSETot;
end 
if In.nNS == 0
    In.nNS = nSETot;
end

%% OUT-OF-SAMPLE PARAMETER VALUES INHERITED FROM IN-SAMPLE DATA
Out.tFormat      = In.tFormat; 
Out.freq         = In.freq;
Out.nC           = In.nC;  % number of source components
Out.nCT          = In.nCT; % number of target components
Out.Src          = In.Src; % source component specification
Out.Trg          = In.Trg; % target component specification
Out.nE           = In.nE;  % number of delays for source data
Out.nET          = In.nET; % number of delays for target data
Out.nXB          = In.nXB; % left-out source samples before main interval
Out.nXA          = In.nXA; % left-out source samples after main interval
Out.nXBT         = In.nXBT; % left-out target samples before main interval
Out.nXAT         = In.nXAT; % left-out target samples after main interval 
Out.lDist        = In.lDist; % local distance function
Out.tol          = In.tol; % cone kernel tolerance
Out.zeta         = In.zeta; % cone kernel parameter zeta 
Out.coneAlpha    = In.coneAlpha; % cone kernel parameter alpha 
Out.diffOpType   = In.diffOpType; % diffusion operator type
Out.alpha        = In.alpha; % diffusion maps parameter alpha
Out.nN           = In.nN; % nearest neighbors for OSE pairwise distance 
Out.nNO          = Out.nN; % nearest neighbors for OSE diffusion operator
Out.epsilon      = 1; % Bandwidth parameter
Out.nPhi         = In.nPhi; % diffusion eigenfunctions to compute
Out.nNO          = In.nN; % number of nearest neighbors for OSE 
Out.idxPhiRecOSE = In.idxPhiRec; % eigenfunctions to reconstruct


%% NUMBER OF SAMPLES AND TIMESTAMPS FOR OUT-OF-SAMPLE DATA
Out.nR  = numel( Out.Res ); % number of realizations, out-of-sample data
idxT1O = zeros( 1, Out.nR );
tNumO = cell( 1, Out.nR ); % Matlab serial date numbers
for iR = Out.nR : -1 : 1
    limNum = datenum( Out.Res( iR ).tLim, Out.tFormat );
    switch Out.freq
    case 'daily'
        tNumO{ iR } = limNum( 1 ) : limNum( 2 ); 
        Out.Res( iR ).nS = numel( tNumO{ iR } ); % number of daily samples
    case 'monthly'
        Out.Res( iR ).nS = months( limNum( 1 ), limNum( 2 ) ) + 1; % number of monthly samples
        tNumO{ iR } = datemnth( limNum( 1 ), 0 : Out.Res( iR ).nS - 1 ); 
    end
    Out.Res( iR ).idxT1 = nEMax + nXBMax;     % time origin for delay embedding
    idxT1O( iR ) = Out.Res( iR ).idxT1;
    Out.Res( iR ).nSE = Out.Res( iR ).nS - Out.Res( iR ).idxT1 + 1 -nXAMax; % sample number after embedding
    Out.Res( iR ).nSERec = Out.Res( iR ).nSE + nETMin - 1; % number of samples for reconstruction
end


%% IN-SAMPLE DATA COMPONENTS
fList = nlsaFilelist( 'file', 'dataX.mat' ); % filename for source data

% Loop over realizations for in-sample data
for iR = In.nR : -1 : 1

    tStr = [ In.Res( iR ).tLim{ 1 } '-' In.Res( iR ).tLim{ 2 } ]; 
    tagR = [ In.Res( iR ).experiment '_' tStr ];
                                    
    partition = nlsaPartition( 'nSample', In.Res( iR ).nS ); % source data assumed to be stored in a single batch
    embPartition( iR ) = nlsaPartition( 'nSample', In.Res( iR ).nSE, ...
                                        'nBatch',  In.Res( iR ).nB  );
    recPartition( iR ) = nlsaPartition( 'nSample', In.Res( iR ).nSRec, ...
                                        'nBatch',  In.Res( iR ).nBRec );

    % Loop over source components
    for iC = In.nC : -1 : 1

        xyStr = sprintf( 'x%i-%i_y%i-%i', In.Src( iC ).xLim( 1 ), ...
                                          In.Src( iC ).xLim( 2 ), ...
                                          In.Src( iC ).yLim( 1 ), ...
                                          In.Src( iC ).yLim( 2 ) );

        pathC = fullfile( inPath,  ...
                          In.Res( iR ).experiment, ...
                          In.Src( iC ).field,  ...
                          [ xyStr '_' tStr ] );
                                                   
        tagC = [ In.Src( iC ).field '_' xyStr ];

        load( fullfile( pathC, 'dataGrid.mat' ), 'nD' )
        
        srcComponent( iC, iR ) = nlsaComponent( 'partition',      partition, ...
                                                'dimension',      nD, ...
                                                'path',           pathC, ...
                                                'file',           fList, ...
                                                'componentTag',   tagC, ...
                                                'realizationTag', tagR  );

    end

    % Loop over target components 
    for iC = In.nCT : -1 : 1

        xyStr = sprintf( 'x%i-%i_y%i-%i', In.Trg( iC ).xLim( 1 ), ...
                                          In.Trg( iC ).xLim( 2 ), ...
                                          In.Trg( iC ).yLim( 1 ), ...
                                          In.Trg( iC ).yLim( 2 ) );

        pathC = fullfile( inPath,  ...
                          In.Res( iR ).experiment, ...
                          In.Trg( iC ).field,  ...
                          [ xyStr '_' tStr ] );
                                                   
        tagC = [ In.Trg( iC ).field '_' tStr ];


        load( fullfile( pathC, 'dataGrid.mat' ), 'nD'  )

        trgComponent( iC, iR ) = nlsaComponent( 'partition',      partition, ...
                                                'dimension',      nD, ...
                                                'path',           pathC, ...
                                                'file',           fList, ...
                                                'componentTag',   tagC, ...
                                                'realizationTag', tagR  );
    end

end

% Loop over source components to create embedding templates
for iC = In.nC : -1 : 1
    switch In.Src( iC ).embFormat
        case 'evector'
            if In.Src( iC ).fdOrder < 0
                embComponent( iC, 1 ) = nlsaEmbeddedComponent( ...
                                    'idxE',    In.Src( iC ).idxE, ... 
                                    'nXB',     In.Src( iC ).nXB, ...
                                    'nXA',     In.Src( iC ).nXA );
            else
                embComponent( iC, 1 )= nlsaEmbeddedComponent_xi_e( ...
                                    'idxE',    In.Src( iC ).idxE, ... 
                                    'nXB',     In.Src( iC ).nXB, ...
                                    'nXA',     In.Src( iC ).nXA, ...
                                    'fdOrder', In.Src( iC ).fdOrder, ...
                                    'fdType',  In.Src( iC ).fdType );
            end
        case 'overlap'
            if In.Src( iC ).fdOrder < 0
                embComponent( iC, 1 ) = nlsaEmbeddedComponent_o( ...
                                    'idxE',    In.Src( iC ).idxE, ...
                                    'nXB',     In.Src( iC ).nXB, ...
                                    'nXA',     In.Src( iC ).nXA );
            else
                embComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_o( ...
                                    'idxE',    In.Src( iC ).idxE, ...
                                    'nXB',     In.Src( iC ).nXB, ...
                                    'nXA',     In.Src( iC ).nXA, ...
                                    'fdOrder', In.Src( iC ).fdOrder, ...
                                    'fdType',  In.Src( iC ).fdType );
            end
    end
end

% Loop over target components to create embedding templates
for iC = In.nCT : -1 : 1
    switch In.Trg( iC ).embFormat
        case 'evector'
            if In.Trg( iC ).fdOrder < 0
                trgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_e( ...
                                      'idxE',    In.Trg( iC ).idxE, ... 
                                      'nXB',     In.Trg( iC ).nXB, ...
                                      'nXA',     In.Trg( iC ).nXA );
            else
                trgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_e( ...
                                      'idxE',    In.Trg( iC ).idxE, ... 
                                      'nXB',     In.Trg( iC ).nXB, ...
                                      'nXA',     In.Trg( iC ).nXA, ...
                                      'fdOrder', In.Trg( iC ).fdOrder, ...
                                      'fdType',  In.Trg( iC ).fdType );
             end
        case 'overlap'
            if In.Trg( iC ).fdOrder < 0 
                trgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_o( ...
                                       'idxE',    In.Trg( iC ).idxE, ...
                                       'nXB',     In.Trg( iC ).nXB, ...
                                       'nXA',     In.Trg( iC ).nXA );
            else
                trgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_o( ...
                                       'idxE',    In.Trg( iC ).idxE, ...
                                       'nXB',     In.Trg( iC ).nXB, ...
                                       'nXA',     In.Trg( iC ).nXA, ...
                                       'fdOrder', In.Trg( iC ).fdOrder, ...
                                       'fdType',  In.Trg( iC ).fdType );
            end
    end
end


%% PROJECTED COMPONENTS
for iC = In.nCT : -1 : 1
    if isa( trgEmbComponent( iC, 1 ), 'nlsaEmbeddedComponent_xi' )
        prjComponent( iC ) = nlsaProjectedComponent_xi( ...
                             'nBasisFunction', In.nPhiPrj );
    else
        prjComponent( iC ) = nlsaProjectedComponent( ...
                             'nBasisFunction', In.nPhiPrj );
    end
end

%% OUT-OF-SAMPLE DATA COMPONENTS 
fList = nlsaFilelist( 'file', 'dataX.mat' ); % filename for source data
for iR = Out.nR : -1 : 1

    tStr = [ Out.Res( iR ).tLim{ 1 } '-' Out.Res( iR ).tLim{ 2 } ];
    tagR = [ Out.Res( 1 ).experiment '_' tStr ];
    partition = nlsaPartition( 'nSample', Out.Res( iR ).nS ); % source data assumed to be stored in a single batch
    outEmbPartition( iR ) = nlsaPartition( 'nSample', Out.Res( iR ).nSE, ...
                                        'nBatch',  Out.Res( iR ).nB  );
    oseRecPartition( iR ) = nlsaPartition( 'nSample', Out.Res( iR ).nSERec, ...
                                           'nBatch', Out.Res( iR ).nBRec ); 

    % Loop over out-of-sample source components
    for iC = Out.nC : -1 : 1

        xyStr = sprintf( 'x%i-%i_y%i-%i', Out.Src( iC ).xLim( 1 ), ...
                                          Out.Src( iC ).xLim( 2 ), ...
                                          Out.Src( iC ).yLim( 1 ), ...
                                          Out.Src( iC ).yLim( 2 ) );

        pathC = fullfile( outPath,  ...
                          Out.Res( iR ).experiment, ...
                          Out.Src( iC ).field,  ...
                          [ xyStr '_' tStr ] );

        tagC = [ Out.Src( iC ).field '_' xyStr ];
        
        load( fullfile( pathC, 'dataGrid.mat' ), 'nD' ) % number of gridpoints

        outComponent( iC, iR ) = nlsaComponent( 'partition',      partition, ...
                                                'dimension',      nD, ...
                                                'path',           pathC, ...
                                                'file',           fList, ...
                                                'componentTag',   tagC, ...
                                                'realizationTag', tagR  );
    end

    % Loop over out-of-sample target components
    for iC = Out.nCT : -1 : 1

        xyStr = sprintf( 'x%i-%i_y%i-%i', Out.Trg( iC ).xLim( 1 ), ...
                                          Out.Trg( iC ).xLim( 2 ), ...
                                          Out.Trg( iC ).yLim( 1 ), ...
                                          Out.Trg( iC ).yLim( 2 ) );

        pathC = fullfile( outPath,  ...
                          Out.Res( iR ).experiment, ...
                          Out.Trg( iC ).field,  ...
                          [ xyStr '_' tStr ] );

        tagC = [ Out.Trg( iC ).field '_' xyStr ];

        load( fullfile( pathC, 'dataGrid.mat' ), 'nD' ) % number of gridpoints

        outTrgComponent( iC, iR ) = nlsaComponent( 'partition',      partition, ...
                                                'dimension',      nD, ...
                                                'path',           pathC, ...
                                                'file',           fList, ...
                                                'componentTag',   tagC, ...
                                                'realizationTag', tagR  );
    end
end
       
% Loop over out-of-sample source components to create embedding templates
for iC = Out.nC : -1 : 1
    switch In.Src( iC ).embFormat
        case 'evector'
            if Out.Src( iC ).fdOrder < 0
                outEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_e( ...
                                        'idxE',    Out.Src( iC ).idxE, ... 
                                        'nXB',     Out.Src( iC ).nXB, ...
                                        'nXA',     Out.Src( iC ).nXA );
            else
                outEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_e( ...
                                        'idxE',    Out.Src( iC ).idxE, ... 
                                        'nXB',     Out.Src( iC ).nXB, ...
                                        'nXA',     Out.Src( iC ).nXA, ...
                                        'fdOrder', Out.Src( iC ).fdOrder, ...
                                        'fdType',  Out.Src( iC ).fdType );
            end
        case 'overlap'
            if Out.Src( iC ).fdOrder < 0
                outEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_o( ...
                                        'idxE',    Out.Src( iC ).idxE, ...
                                        'nXB',     Out.Src( iC ).nXB, ...
                                        'nXA',     Out.Src( iC ).nXA );
            else

                outEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_o( ...
                                        'idxE',    Out.Src( iC ).idxE, ...
                                        'nXB',     Out.Src( iC ).nXB, ...
                                        'nXA',     Out.Src( iC ).nXA, ...
                                        'fdOrder', Out.Src( iC ).fdOrder, ...
                                        'fdType',  Out.Src( iC ).fdType );
            end
    end
end

    
% Loop over out-of-sample target components to create embedding templates
for iC = Out.nCT : -1 : 1
    switch Out.Trg( iC ).embFormat
        case 'evector'
            if Out.Trg( iC ).fdOrder < 0
                outTrgEmbComponent( iC, 1 )= nlsaEmbeddedComponent_e( ...
                                  'idxE',    Out.Trg( iC ).idxE, ... 
                                  'nXB',     Out.Trg( iC ).nXB, ...
                                  'nXA',     Out.Trg( iC ).nXA );
            else
                outTrgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_e( ...
                                  'idxE',    Out.Trg( iC ).idxE, ... 
                                  'nXB',     Out.Trg( iC ).nXB, ...
                                  'nXA',     Out.Trg( iC ).nXA, ...
                                  'fdOrder', Out.Trg( iC ).fdOrder, ...
                                  'fdType',  Out.Trg( iC ).fdType );
             end
        case 'overlap'
            if Out.Trg( iC ).fdOrder < 0
                outTrgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_o( ...
                                       'idxE',    Out.Trg( iC ).idxE, ...
                                       'nXB',     Out.Trg( iC ).nXB, ...
                                       'nXA',     Out.Trg( iC ).nXA );
            else
                outTrgEmbComponent( iC, 1 ) = nlsaEmbeddedComponent_xi_o( ...
                                       'idxE',    Out.Trg( iC ).idxE, ...
                                       'nXB',     Out.Trg( iC ).nXB, ...
                                       'nXA',     Out.Trg( iC ).nXA, ...
                                       'fdOrder', Out.Trg( iC ).fdOrder, ...
                                       'fdType',  Out.Trg( iC ).fdType );
            end
    end
end


%% PAIRWISE DISTANCES FOR IN-SAMPLE DATA
if all( strcmp( { In.Src.embFormat }, 'overlap' ) )
    modeStr = 'implicit';
else
    modeStr = 'explicit';
end

switch In.lDist
    case 'l2' % L^2 distance
        lDist = nlsaLocalDistance_l2( 'mode', modeStr );

    case 'at' % "autotuning" NLSA kernel
        lDist = nlsaLocalDistance_at( 'mode', modeStr ); 

    case 'cone' % cone kernel
        lDist = nlsaLocalDistance_cone( 'mode', modeStr, ...
                                        'zeta', In.zeta, ...
                                        'tolerance', In.tol, ...
                                        'alpha', In.coneAlpha );
end
dFunc = nlsaLocalDistanceFunction( 'localDistance', lDist ); 
pDist = nlsaPairwiseDistance( 'distanceFunction', dFunc, ...
                              'nearestNeighbors', In.nN );

%% PAIRWISE DISTANCES FOR OUT-OF-SAMPLE DATA
switch Out.lDist
    case 'l2' % L^2 distance
        lDist = nlsaLocalDistance_l2( 'mode', modeStr );

    case 'at' % "autotuning" NLSA kernel
        lDist = nlsaLocalDistance_at( 'mode', modeStr ); 

    case 'cone' % cone kernel
        lDist = nlsaLocalDistance_cone( 'mode', modeStr, ... 
                                        'zeta', In.zeta, ...
                                        'tolerance', In.tol, ...
                                        'alpha', In.coneAlpha );
end

oseDFunc = nlsaLocalDistanceFunction( 'localDistance', lDist );
                                          
osePDist = nlsaPairwiseDistance( 'distanceFunction', oseDFunc, ...
                                 'nearestNeighbors', Out.nN );

%% SYMMETRIZED PAIRWISE DISTANCES
sDist = nlsaSymmetricDistance_gl( 'nearestNeighbors', In.nNS );



%% DIFFUSION OPERATOR FOR IN-SAMPLE DATA
switch In.diffOpType
    % global storage format, fixed bandwidth
    case 'gl'
        diffOp = nlsaDiffusionOperator_gl( 'alpha',          In.alpha, ...
                                           'epsilon',        In.epsilon, ...
                                           'nEigenfunction', In.nPhi );

    % global storage format, multiple bandwidth (automatic bandwidth selection)
    case 'gl_mb' 
        diffOp = nlsaDiffusionOperator_gl_mb( ...
                     'alpha',                  In.alpha, ...
                     'epsilon',                In.epsilon, ...
                     'nEigenfunction',         In.nPhi, ...
                     'bandwidthBase',          In.epsilonB, ...
                     'bandwidthExponentLimit', In.epsilonE, ...
                     'nBandwidth',             In.nEpsilon );

    % global storage format, multiple bandwidth (automatic bandwidth selection and SVD)
    case 'gl_mb_svd' 
        diffOp = nlsaDiffusionOperator_gl_mb_svd( ...
                     'alpha',                  In.alpha, ...
                     'epsilon',                In.epsilon, ...
                     'nEigenfunction',         In.nPhi, ...
                     'bandwidthBase',          In.epsilonB, ...
                     'bandwidthExponentLimit', In.epsilonE, ...
                     'nBandwidth',             In.nEpsilon );

    case 'gl_mb_bs'
        diffOp = nlsaDiffusionOperator_gl_mb_bs( ...
                     'alpha',                  In.alpha, ...
                     'epsilon',                In.epsilon, ...
                     'nEigenfunction',         In.nPhi, ...
                     'bandwidthBase',          In.epsilonB, ...
                     'bandwidthExponentLimit', In.epsilonE, ...
                     'nBandwidth',             In.nEpsilon );

end

%% DIFFUSION OPERATOR FOR OUT-OF-SAMPLE DATA
switch Out.diffOpType
    case 'gl_mb_svd'
        oseDiffOp = nlsaDiffusionOperator_ose_svd( 'alpha',          Out.alpha, ...
                                       'epsilon',        Out.epsilon, ...
                                       'epsilonT',       In.epsilon, ...
                                       'nNeighbors',     Out.nNO, ...
                                       'nNeighborsT',    In.nNS, ...
                                       'nEigenfunction', Out.nPhi );
    case 'gl_mb_bs'
        oseDiffOp = nlsaDiffusionOperator_ose_bs( 'alpha',          Out.alpha, ...
                                       'epsilon',        Out.epsilon, ...
                                       'epsilonT',       In.epsilon, ...
                                       'nNeighbors',     Out.nNO, ...
                                       'nNeighborsT',    In.nNS, ...
                                       'nEigenfunction', Out.nPhi );

    otherwise
        oseDiffOp = nlsaDiffusionOperator_ose( 'alpha',          Out.alpha, ...
                                       'epsilon',        Out.epsilon, ...
                                       'epsilonT',       In.epsilon, ...
                                       'nNeighbors',     Out.nNO, ...
                                       'nNeighborsT',    In.nNS, ...
                                       'nEigenfunction', Out.nPhi );
end
 

%% LINEAR MAP FOR SVD OF TARGET DATA
linMap = nlsaLinearMap_gl( 'basisFunctionIdx', In.idxPhiSVD );


%% RECONSTRUCTED TARGET COMPONENTS -- IN-SAMPLE DATA
% Reconstructed data from diffusion eigenfnunctions
recComponent = nlsaComponent_rec_phi( 'basisFunctionIdx', In.idxPhiRec );

% Reconstructed data from SVD 
svdRecComponent = nlsaComponent_rec_phi( 'basisFunctionIdx', In.idxVTRec );


%% RECONSTRUCTED TARGET COMPONENTS -- OUT-OF-SAMPLE DATA
% Nystrom extension
oseEmbTemplate = nlsaEmbeddedComponent_ose_n( 'eigenfunctionIdx', Out.idxPhiRecOSE );
oseRecComponent = nlsaComponent_rec();

%% BUILD NLSA MODEL    
model = nlsaModel_ose( 'path',                            nlsaPath, ...
                       'sourceComponent',                 srcComponent, ...
                       'targetComponent',                 trgComponent, ...
                       componentNames{ : }, ...
                       'srcTime',                         tNum, ...
                       'embeddingOrigin',                 idxT1, ...
                       'embeddingTemplate',               embComponent, ...
                       'targetEmbeddingTemplate',         trgEmbComponent, ...
                       'embeddingPartition',              embPartition, ...
                       'pairwiseDistanceTemplate',        pDist, ...
                       'symmetricDistanceTemplate',       sDist, ...
                       'diffusionOperatorTemplate',       diffOp, ...
                       'projectionTemplate',              prjComponent, ...
                       'reconstructionTemplate',          recComponent, ...                            
                       'reconstructionPartition',         recPartition, ...
                       'linearMapTemplate',               linMap, ...
                       'svdReconstructionTemplate',       svdRecComponent, ...
                       'outComponent',                    outComponent, ...
                       'outTargetComponent',              outTrgComponent, ...
                       'outTime',                         tNumO, ...
                       'outEmbeddingOrigin',              idxT1O, ...
                       'outEmbeddingTemplate',            outEmbComponent, ...
                       'outEmbeddingPartition',           outEmbPartition, ... 
                       'osePairwiseDistanceTemplate',     osePDist, ...
                       'oseDiffusionOperatorTemplate',    oseDiffOp, ...
                       'oseEmbeddingTemplate',            oseEmbTemplate, ...
                       'oseReconstructionPartition',      oseRecPartition );
                    
