function y = lsum2( yL, idxE )
%LSUM2 Lagged embedding sum along diagonal blocks
%
% Modified 2018/05/04

nSL1 = size( yL, 1 );
nSL2 = size( yL, 2 );
nE = max( idxE ) - 1;
nS1 = nSL1 - nE;
nS2 = nSL2 - nE;

[ I, J ] = ndgrid( 1 : nS1, 1 : nS2 );
k = sub2ind( [ nSL1 nSL2 ], I( : ), J( : ) )';
kShift = ( idxE - 1 ) * ( nSL1 + 1 );
if ~iscolumn( kShift )
    kShift = kShift';
end
k = bsxfun( @plus, k, kShift );
y = sum( yL( k ), 1 );
y = reshape( y, [ nS1 nS2 ] );
