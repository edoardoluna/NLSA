function tag = getDefaultTag( obj )
% GETDEFAULTTAG  Get default tag of nlsaKoopmanOperator objects
%
% Modified 2020/04/15

idxStr = idx2str( getBasisFunctionIndices( obj ), 'idxPhi' );

tag = sprintf( '%s_fdOrd%i_dt%1.3g_asym%i_%s', ...
                getFDType( obj ), ...
                getFDOrder( obj ), ...
                getSamplingInterval( obj ), ...
                idxStr );
