% facoltativo 4

% We want to compute the M smallest eigenvalues of a symmetric matrix. 
% To this aim, the following code will implement the Inverse power method. 

function b = InversePWRIteration(A, mi, b0, max_iter, tol)

% InversePWRIteration: gives an approximation of the eigenvector associated 
%                      to the smallest eigenvalue.
%                    
%                    INPUTS: A: symmetric square matrix, 
%                            mi: approx of the smallest eigenvalue
%                            b0: approx of the searched eigenvector
%                            max_iter: maximum number of iterations
%                            tol: tolerance both for the NaiveFOM method
%                                 and for the stopping criterion
%
%                    OUTPUTS: b: estimated eigenvector. 
        
        [n, ~] = size(A); 
        Y = (A - mi*speye(n));
        initial_guess = ones(n,1); 
        
        bk = NaiveFOM(Y, b0, initial_guess, tol);

        i = 1; 
        while i < max_iter && norm(bk-b0, 1) > tol

            b0 = bk; 
            bk = NaiveFOM(Y, b0/norm(bk), initial_guess, tol);
            i = i +1;
        end
        b = bk/norm(bk); 
end