function computeData( obj, src, iR )
% COMPUTEDATA Perform delay embedding of the data in src using explicit
% storage format. iR is a "realization" index, set to 1 if unspecified,
% used to select data from a particular realization in src. 
%
% Modified 2017/07/20

if nargin == 2
    iR = 1;
end

nD  = getDimension( obj );               % physical space dimension
nDE = getEmbeddingSpaceDimension( obj ); % embedding space dimension
nE  = getEmbeddingWindow( obj );         % max time index in lag window

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VALIDATE INPUT ARGUMENTS
if isa( src, 'nlsaComponent' )
    if getDimension( src ) ~= nD
        error( 'Invalid source data dimension' )
    end
elseif isa( src, 'nlsaKernelDensity' )
    if nDE ~= nE
        error( 'Invalid embedding space dimension' )
    end
else
    error( 'Invalid source data' )
end
if getNSample( obj ) + obj.idxO - 1 > getNSample( src, iR )
    error( 'End index for embedding must be less than or equal to the number of source data' )
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION
% Read the source batch containing the start index, taking into 
% account extra samples needed for embedding and/or nXB.
% Below, iSBSrc1 is the batch-local index in the source data
iWant   = obj.idxO - ( nE - 1 + obj.nXB );
iBSrc   = findBatch( src, iWant, iR );
xSrc    = getData( src, iBSrc, iR );
lSrc    = getBatchLimit( src, iBSrc, iR );
nSBSrc  = getBatchSize( src, iBSrc, iR );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAMPLES BEFORE MAIN INTERVAL
if obj.nXB > 0
    iSBE1 = 1; % iSBE is the batch-local index in the embedded data
    nSBE  = obj.nXB;
    x     = zeros( nDE, nSBE );
    iSBSrc1 = obj.idxO - lSrc( 1 ) - nSBE + 1;
    deficit = nSBE;
    while deficit >= 0 
        nSProvided = min( nSBSrc - iSBSrc1 + 1, nSBE - iSBE1 + 1 );
        iSBSrc2    = iSBSrc1 + nSProvided - 1;
        iSBE2      = iSBE1 + nSProvided - 1;
        x( :, iSBE1 : iSBE2 ) = lembed( xSrc, [ iSBSrc1 iSBSrc2 ], obj.idxE );
        iSBE1   = iSBE2 + 1;
        iSBSrc1 = iSBSrc2 + 1;        
        deficit = nSBE - iSBE1;
        if deficit >= 0 && iSBSrc1 > nSBSrc
            iBSrc   = iBSrc + 1;
            iKeep1  = nSBSrc - obj.idxE( end ) + 2;
            iKeep2  = nSBSrc; 
            xKeep   = xSrc( :, iKeep1 : iKeep2 );
            xSrc    = [ xKeep getData( src, iBSrc, iR ) ];
            nSKeep  = size( xKeep, 2 );
            iSBSrc1 = 1 + nSKeep; 
            nSBSrc  = getBatchSize( src, iBSrc, iR ) + nSKeep;
        end
    end
    setData_before( obj, x, '-v7.3' )
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAIN-INTERVAL SAMPLES
% Loop over the embedded data batches
iSBSrc1 = obj.idxO - lSrc( 1 ) + 1;      
for iBE = 1 : getNBatch( obj )
    iSBE1 = 1; % iSBE is the batch-local index in the embedded data
    nSBE = getBatchSize( obj, iBE );
    x     = zeros( nDE, nSBE );
    deficit = nSBE;
    while deficit >= 0 
        nSProvided = min( nSBSrc - iSBSrc1 + 1, nSBE - iSBE1 + 1 );
        iSBSrc2    = iSBSrc1 + nSProvided - 1;
        iSBE2      = iSBE1 + nSProvided - 1;
        x( :, iSBE1 : iSBE2 ) = lembed( xSrc, [ iSBSrc1 iSBSrc2 ], obj.idxE );
        iSBE1   = iSBE2 + 1;
        iSBSrc1 = iSBSrc2 + 1;        
        deficit = nSBE - iSBE1;
        if deficit >= 0 && iSBSrc1 > nSBSrc
            iBSrc   = iBSrc + 1;
            iKeep1  = nSBSrc - obj.idxE( end ) + 2;
            iKeep2  = nSBSrc; 
            xKeep   = xSrc( :, iKeep1 : iKeep2 );
            xSrc    = [ xKeep getData( src, iBSrc, iR ) ];
            nSKeep  = size( xKeep, 2 );
            iSBSrc1 = 1 + nSKeep; 
            nSBSrc  = getBatchSize( src, iBSrc, iR ) + nSKeep;
        end
    end
    setData( obj, x, iBE, '-v7.3' )
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAMPLES AFTER MAIN INTERVAL
if obj.nXA > 0
    iSBE1 = 1; % iSBE is the batch-local index in the embedded data
    nSBE  = obj.nXA;
    x     = zeros( nDE, nSBE );
    deficit = nSBE;
    while deficit >= 0 
        nSProvided = min( nSBSrc - iSBSrc1 + 1, nSBE - iSBE1 + 1 );
        iSBSrc2    = iSBSrc1 + nSProvided - 1;
        iSBE2      = iSBE1 + nSProvided - 1;
        x( :, iSBE1 : iSBE2 ) = lembed( xSrc, [ iSBSrc1 iSBSrc2 ], obj.idxE );
        iSBE1   = iSBE2 + 1;
        iSBSrc1 = iSBSrc2 + 1;        
        deficit = nSBE - iSBE1;
        if deficit >= 0 && iSBSrc1 > nSBSrc
            iBSrc   = iBSrc + 1;
            iKeep1  = nSBSrc - obj.idxE( end ) + 2;
            iKeep2  = nSBSrc; 
            xKeep   = xSrc( :, iKeep1 : iKeep2 );
            xSrc    = [ xKeep getData( src, iBSrc, iR ) ];
            nSKeep  = size( xKeep, 2 );
            iSBSrc1 = 1 + nSKeep; 
            nSBSrc  = getBatchSize( src, iBSrc, iR ) + nSKeep;
        end
    end
    setData_after( obj, x, '-v7.3' )
end  
