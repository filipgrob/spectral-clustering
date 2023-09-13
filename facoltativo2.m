% Facoltativo 2

% We repeat the process done in facoltativo1.m for the normalyzed laplacian

% ACCESSING THE FILE
% choose one between Atom, EngyTime, GolfBall, Hepta, Target, Tetra
% TwoDiamonds, replace the following string

chosen_dataset = 'Hepta'; 

A = load("3D\"+chosen_dataset+".lrn"); 
classes = load("3D\"+chosen_dataset+".cls"); 

% dropping unuseful index
[r, c] = size(A); 

if c == 4
    A = A(:, 2:end); 
end
classes = classes(:, 2); 

% clustering via spectral cluster

[n, m] = size(A);

% computing the KNN similarity matrix
K = 10; 
similarity  = @(x,y) exp(-0.5*norm(x-y, 2)^2);
W = KNN_similarity_graph(A, similarity, K); 

% constructing degree and Laplacian matrices

% degree matrix, summing over columns, 
% it would have been the same to sum over rows by symmetry.
% This still gives a diag matrix
D = diag(sum(W, 2));

% Laplacian Matrix
L = D - W; 

% Normalizing
L = D^-0.5 * L * D^-0.5; 

% Finding number of connected components: number of zero eigs of L: 
[eigenvectors, eigenvalues] = eigs(L, n); 
% setting arbitrary tol: 
tol = 1e-15;
Number_eigenvalues = sum(eigenvalues <= tol); 
% 1 connected component

% controls the number of clusters
K = 7;
% selecting first K eigenvalues to cluster
eigenv_cluster = diag(eigenvalues(n:-1:n-K+1, n:-1:n-K+1));
eigenvect_cluster = eigenvectors(:, n:-1:n-K+1); 

% using k-means to cluster
idx = kmeans(eigenvect_cluster, K); 

% clustered points
s_clustered_points = [A(:,1:2), idx]; 

% PLOTS

% plotting the clustering results of dataset
figure()
subplot(1,2,1)
scatter3(A(:,1),A(:,2), A(:,3),[], idx)
title(sprintf('Spectral Clustering of %s, with K=%d',chosen_dataset,K))
% plotting the dataset
subplot(1,2,2)
scatter3(A(:,1),A(:,2), A(:,3),[], classes(:,1))
title(['Actual Clusters of ',chosen_dataset])