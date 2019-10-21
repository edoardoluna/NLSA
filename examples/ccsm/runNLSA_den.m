function [ model, In ] = runNLSA_den( experiment, iProc, nProc, ifPlot )
%
% This function creates an NLSA model with kernel density estimation and 
% executes the various NLSA steps for data from the CCSM/CESM models 
%
% Each step saves the results on disk, so a partially completed calculation can
% be resumed by commenting out the steps in this function which have been 
% already exectuted. 
%
% Similarly, if the NLSA model parameters specified in the function 
% ccsmNLSAModel_den are changed, it is only necessary to repeat the steps 
% affected by the parameter changes. (E.g., if the diffusion maps bandwidth 
% parameter is changed, the steps up to the distance symmetrization can be
% skipped.)
%
% Input arguments:
%
% experiment:   a string identifier for the NLSA model, passed to
%               the function ccsmNLSAModel_den
%
% iProc, nProc: These arguments provide rudimentary parallelization features 
%               for the steps in the code that support it. Setting nProc > 1 
%               means that the computation is divided into nProc batches. These
%               batches can be executed in parallel by launching nProc 
%               instances of Matlab and running this function with iProc set to
%               1 for instance #1, 2 for instance #2, ...     
%
% ifPlot:       Set to true to make basic eigenfunction and density scatterplots
%               
% To display the optimal bandwidth from automatic bandwidth for kernel 
% density estimation and the diffusion operator, run the following commands:
%
% Density estimation:
% [ epsilonOpt, Info ] = computeDensityOptimalBandwidth( model );
% 
% Diffusion operator (only available for gl_mb diffusion operators):
% [ epsilonOpt, Info ] = computeOptimalBandwidth( model );
%
% To recover the estimated density, diffusion eigenfunctions, and the 
% projected and reconstructed data, run the following commands:
%
% Density estimation
% rho = getDensity( model );
% 
% Diffusion eigenfunctions:
% phi = getDiffusionEigenfunctions( model ); 
% 
% Projected target data onto the diffusion eigenfunctions:
% a = getProjectedData( model );
%
% Reconstructed data: 
% x = getReconstructedData( model );
%  
% Modified 2016/04/04

% Default input arguments
if nargin == 0
    experiment = 'np_sst'; 
end
if nargin <= 1 
    iProc = 1;
    nProc = 1;
end

if nargin <= 3
    ifPlot = false;
end

disp( experiment )
[ model, In ] = ccsmNLSAModel_den( experiment ); 


disp( 'Takens delay embedding' ); computeDelayEmbedding( model )

% The next step is only needed for velocity-dependent distances such as 
% the "at" and "cone" distances
disp( 'Phase space velocity' ); computeVelocity( model )

% The next step is only needed if the target data are different from the 
% source data
%disp( 'Takens delay embedding, target data' ); computeTrgDelayEmbedding( model )

% The next step is only needed if the density estimation data are different
% from the source data
%disp( 'Takens delay embedding, density data' ); computeDenDelayEmbedding( model )

% The next step is only needed if the density estimatmion data are different
% from the source data and velocity dependent distances are used for kernel
% density estimation
%disp( 'Phase space velocity for density data' ); computeDenVelocity( model );
 
fprintf( 'Pairwise distances for density data, %i/%i\n', iProc, nProc ); 
computeDenPairwiseDistances( model, iProc, nProc )

% The next step is only needed if the kernel density estimation is of type "vb"
disp( 'Density bandwidth normalization' ); computeDenBandwidthNormalization( model );

disp( 'Density kernel sum' ); computeDenKernelDoubleSum( model );

disp( 'Density' ); computeDensity( model );

disp( 'Density delay embedding' ); computeDensityDelayEmbedding( model );

fprintf( 'Pairwise distances, %i/%i\n', iProc, nProc ); 
computePairwiseDistances( model, iProc, nProc )

disp( 'Distance symmetrization' ); symmetrizeDistances( model )

% The next step is only needed for automatic bandwidth selection
disp( 'Kernel sum' ); computeKernelDoubleSum( model )

disp( 'Diffusion eigenfunctions' ); computeDiffusionEigenfunctions( model )

disp( 'Projection of target data onto diffusion eigenfunctions' );
computeProjection( model );

disp( 'Reconstruction of the projected data' )
computeReconstruction( model )
