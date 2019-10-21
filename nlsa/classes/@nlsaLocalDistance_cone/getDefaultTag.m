function tag = getDefaultTag( obj )
% GETDEFAULTTAG  Get default tag of nlsaLocalDistance_cone object
%
% Modified 2015/05/14

tag = [ 'cone_zeta' num2str( getZeta( obj ) ) ...
        '_tol' num2str( getTolerance( obj ), '%1.2E' ) ...
        '_alpha', num2str( getAlpha( obj ), '%1.2E' ), ...
        '_' getNormalization( obj ) ];
