function f_h=f_h(X,Y)
% Cd formula when Re>3000

S = exp(Y)./3.7;
T= 2.51./exp(X);
fun = @(x) x + 2*log10( S + T.*x );
dfun = @(x) 1 + 2*( T ./ ( log(10) * (S + T.*x) ) );
x0=(exp(X).^0.5)./8;
d = 1e9; tol = 1e-9; nx0 = norm(x0);
count = 1;
    while d > tol
    
        x1 = x0 - fun(x0) ./ dfun(x0);
    d = norm(x1 - x0);
    fprintf('\tIter %d: step size = %6.4e\n', count, d);
    
        x0= x1;
        count = count + 1;
    
    end
f_h=1./(x0.^2);
end