function computeSclOutProjection( obj, iProc, nProc, varargin )
% COMPUTESCLOUTPROJECTION Compute projection of the target data onto the 
% scaled diffusion eigenfunctions of the OS data 
% of an nlsaModel_scl object
%
% Modified 2014/07/28

if nargin == 1
    iProc = 1;
    nProc = 1;
end

%Opt.ifWriteXi = true;
%Opt = parseargs( Opt, varargin{ : } );

trgEmbComponent = getOutTrgEmbComponent( obj );
prjComponent    = getSclOutPrjComponent( obj );
diffOp          = getSclOutDiffusionOperator( obj);
nCT = size( trgEmbComponent, 1 );


pPartition = nlsaPartition( 'nSample', nCT, ...
                            'nBatch',  nProc );
iCLim   = getBatchLimit( pPartition, iProc );
logFile = sprintf( 'dataA_%i-%i.log', iProc, nProc );

computeProjection( prjComponent, trgEmbComponent, diffOp, ...
                   'component', iCLim( 1 ) : iCLim( 2 ), ...
                   'logPath', getProjectionPath( prjComponent( 1 ) ), ...
                   'logFile', logFile );
