function q = computeDensity( obj, dist, den, varargin )
% COMPUTEDENSITY Compute kernel density estimate from distance data dist 
% 
% den is the in-sample kernel density
% 
% Modified 2019/08/23

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validate input arguments
if ~isa( dist, 'nlsaPairwiseDistance' )
    error( 'Distance data must be specified as an nlsaPairwiseDistance object' )
end
partition = getPartition( obj );
partitionIn = getPartition( den );
if any( ~isequal( partition, getPartition( dist ) ) )
    error( 'Incompatible partitions' )
end
[ partitionG, idxG ] = mergePartitions( partition ); % global partition  
nR      = numel( partition );
nS      = getNTotalSample( partition ); 
nSIn    = getNTotalSample( partitionIn );
nBG     = getNBatch( partitionG );
epsilon = getBandwidth( obj ) * getBandwidth( den );
nD      = getDimension( obj );
kNN     = getKNN( obj );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse optional input arguments 
Opt.batch              = 1 : getNBatch( partitionG );
Opt.logFile            = '';
Opt.logPath            = getDensityPath( obj );
Opt.logFilePermissions = 'w';
Opt = parseargs( Opt, varargin{ : } );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup logfile and write calculation summary
if isempty( Opt.logFile )
    logId = 1;
else
    logId = fopen( fullfile( Opt.logPath, Opt.logFile ), ...
                   Opt.logFilePermissions );
end

clk = clock;
[ ~, hostname ] = unix( 'hostname' );
fprintf( logId, 'computeDensity starting on %i/%i/%i %i:%i:%2.1f \n', ...
    clk( 1 ), clk( 2 ), clk( 3 ), clk( 4 ), clk( 5 ), clk( 6 ) );
fprintf( logId, 'Hostname %s \n', hostname );
fprintf( logId, 'Number of samples              = %i, \n', nS );
fprintf( logId, 'Bandwidth                      = %2.4f, \n', epsilon );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over the global batches -- density 
q   = zeros( nS, 1 );
rho = getDistanceNormalization( obj );
rhoIn = getDistanceNormalization( den )'; % in-sample distance noremalization

for iBG = 1 : nBG

    iR  = idxG( 1, iBG );
    iB  = idxG( 2, iBG );
    nBR = getNBatch( partition( iR ) );
    iS  = getBatchLimit( partitionG, iBG );

    tic 
    [ y, iNN ] = getDistances( dist, iB, iR );
    tWall = toc;
    fprintf( logId, 'READK %i/%i %i/%i %2.4f \n', iR, nR, iB, nBR, tWall ); 

    tic
    y = y ./ rhoIn( iNN );
    y = bsxfun( @ldivide, rho( iS( 1 ) : iS( 2 ) ), y );
    tWall = toc;
    fprintf( logId, 'VB %i/%i %i/%i %2.4f \n', iR, nR, iB, nBR, tWall ); 
       
    tic
    q( iS( 1 ) : iS( 2 ) ) = sum( exp( -y / epsilon ^ 2 ), 2 );
    tWall = toc;
    fprintf( logId, 'EXP %i/%i %i/%i %2.4f \n', iR, nR, iB, nBR, tWall ); 

    q( iS( 1 ) : iS( 2 ) ) = q( iS( 1 ) : iS( 2 ) ) ...
                           ./ rho( iS( 1 ) : iS( 2 ) ) .^ nD ...
                           / nSIn / pi ^ ( nD / 2 ) / epsilon ^ nD;
    tWall = toc;
    fprintf( logId, 'NORMALIZE %i/%i %i/%i %2.4f \n', iR, nR, iB, nBR, tWall ); 

    tic
    setDensity( obj, q, '-v7.3' )
    tWall = toc;
    fprintf( logId, 'WRITEQ %i/%i %i/%i %2.4f \n', iR, nR, iB, nBR, tWall ); 
end 

clk = clock; % Exit gracefully
fprintf( logId, 'computeDensity finished on %i/%i/%i %i:%i:%2.1f \n', ...
    clk( 1 ), clk( 2 ), clk( 3 ), clk( 4 ), clk( 5 ), clk( 6 ) );
if ~isempty( Opt.logFile )
    fclose( logId );
end
