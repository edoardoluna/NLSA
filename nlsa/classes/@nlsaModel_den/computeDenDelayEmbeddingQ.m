function computeDenDelayEmbeddingQ( obj, iProcC, nProcC )
% COMPUTEDENDELAYEMBEDDINGQ Lag-embed the density data in an nlsaModel_den 
% object using the query partition
%
% Modified 2019/11/24

% Quick return if denEmbComponentQ is empty
if isempty( obj.denEmbComponentQ )
    return
end

if nargin == 1
    iProcC = 1;
    nProcC = 1;
end

cmp = obj.denEmbComponent;
emb = obj.denEmbComponentQ;
nC  = size( emb, 1 );

% Validate input arguments
if ~ispsi( nProcC ) || nProcC > nC
    error( 'Number of processes must be a positive scalar integer less than or equal to the number of source components.' )
end
if ~ispsi( iProcC ) || iProcC > nProcC
    error( 'Process index must be a positive scalar integer less than or equal to the number of processes.' )
end

pPartitionC = nlsaPartition( 'nSample', nC, 'nBatch', nProcC );
iCLim = getBatchLimit( pPartitionC, iProcC );
for iC = iCLim( 1 ) : iCLim( 2 )
    mergeData( emb( iC ), cmp( iC, : ) )
end
