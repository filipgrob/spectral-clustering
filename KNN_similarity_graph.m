function W = KNN_similarity_graph(data, similarity_function, K)
        
         % Computes the KNN similarity graph of the data matrix. 
         % 
         % INPUT: data: n by m matrix, similarity function: function handle
         %        K: Neighoburhood size.
         %
         % OUTPUT: W: n by n matrix of similairty between the data
         %
            
         [n,~] = size(data);

         W = spalloc(n,n,K*n); 
         tol = 1e-8; 
         
         for i=1:n
             S = zeros(1,n); 
             for j=i+1:n
                 Sij = similarity_function(data(i, :), data(j, :));
                if Sij >= tol %gaussian kernel,minimum simil = 0
                   S(j) = Sij; 
                end
             end 

             % now to remove all the elements far less than K
             [vals, pos] = maxk(S, K); 
             %here we find the first k elements
             h = sparse(pos, 1,vals, n, 1); 
             W(:, i) = h;
         end

         % Takes bottom half of W to make W symmetric
         W = triu(W.',1) + tril(W);  
end
