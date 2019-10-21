function d = cdmat_h( zeta, tol, x1, v1, xi1, x2, v2, xi2 )
%CDMAT_H Cone distance matrix with harmonic mean
%
%   Modified 05/12/2014

if zeta == 0 % don't compute angular terms
    if nargin == 5
        d = wdmat_h( x1, xi1 );
    elseif nargin == 8
        d = wdmat_h( x1, xi1, x2, xi2 );
    end
    return
end

if nargin == 5
    ww  = dmat( x1 );
    xi1 = 1 ./ xi1 .^ 2;  % only the inverse of xi is needed
    x2  = x1;
elseif nargin == 8
    ww = dmat( x1, x2 );
    xi1 = 1 ./ xi1 .^ 2;  % only the inverse of xi is needed
    xi2 = 1 ./ xi2 .^ 2;  % only the inverse of xi is needed
end

vx = v1' * x2;

if nargin == 5
    vx0 = diag( vx );
elseif nargin == 8
    vx0 = sum( v1 .* x1, 1 )';
end
 
b1    = bsxfun( @minus, vx, vx0 ) .^ 2;
b1    = bsxfun( @times, b1, xi1' ) ./ ww; % cos^2(angle)
ifFix = b1 > 1;
b1( ifFix ) = 1;
b1 = 1 - zeta .* b1; 

if nargin == 8
    vx          = x1' * v2;
    vx0         = sum( v2 .* x2 );
    b2          = bsxfun( @minus, vx, vx0 ) .^ 2;
    b2          = bsxfun( @times, b2, xi2 ) ./ ww;
    ifFix       = b2 > 1;
    b2( ifFix ) = 1;
    b2          = 1 - zeta .* b2; 
end  

if nargin == 5
    d = ww ...
      .* bsxfun( @plus, xi1', xi1 ) ...
      .* ( b1 + b1' );
elseif nargin == 8
    d =  ww ...
      .* bsxfun( @plus, xi1', xi2 ) ...
      .* ( b1 + b2 );
end
d = d / 4;

if nargin == 5
    if tol > 0
        if0      = ww .* bsxfun( @plus, xi1', xi1 ) <= tol;
        if0      = if0 | if0';
        d( if0 ) = 0;
    else
        n = size( d, 1 );
        d( 1 : n + 1 : end ) = 0;
    end
elseif nargin == 8 && tol > 0
    if0      = ww .* bsxfun( @plus, xi1', xi2 ) <= tol;
    d( if0 ) = 0;
end
