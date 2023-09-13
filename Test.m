%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USAGE EXAMPLE OF InversePWRIteration %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 5;

A = random('normal',1, n,n); 
A = A'*A; 

% Uncomment this code to try sparse random symmetric matrices
%density = 0.4; 
%A = sprandsym(n, density); 

% we select a random eigenvalue and an approximating eigenvector
mi = 0.2; 
b0 = zeros(n, 1); 

% we set a reasonable tolerance
tol = 1e-10; 
% in general not many iterations are needed
max_iter = 10;

% computing
b = InversePWRIteration(A, mi, b0, max_iter, tol); 

% comparison with actual vect: 
[v, ~] = eigs(A, n); 

[v(:, end), b]
