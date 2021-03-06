function tag = getDefaultTag( obj )
% GETDEFAULTTAG  Get default tag of nlsaKoopmanOperator_diff objects
%
% Modified 2020/04/15

tag = getDefaultTag@nlsaKoopmanOperator( obj );

tag = [ tag sprintf( '_%s_eps%1.3g', getRegularizationType( obj ), ...
                                     getRegularizationParameter( obj ) ) ];
