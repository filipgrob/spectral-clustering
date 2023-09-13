% ACCESSING THE FILE
% you can choose between Circle and Spiral:
file = 'Circle';
A = load("2D/"+file+".csv");

[n, m] = size(A);


% isolating the classes
if m == 3
    classes = A(:, 3); 
    % obtaining the raw coordinates
    A = A(:, 1:2); 
else
    % ad hoc for circle because it lacks the colors of the clusters
    classes = [zeros(n/3, 1); ones(n/3, 1); 2*ones(n/3, 1)]; 
end

% visualizing the structure of the data
figure()
scatter(A(:,1), A(:,2), [], classes, 'filled'); 
title([file, 'data'])
grid on

% computing the KNN similarity matrix
K = 10; 
similarity  = @(x,y) exp(-0.5*norm(x-y, 2)^2);
W = KNN_similarity_graph(A, similarity, K); 

% visualizing the sparsity structure
figure()
title('Sparsity structure of matrix W') 
imshow(full(W), Colormap=summer, Interpolation="nearest"); 

% constructing degree and Laplacian matrices

% degree matrix, summing over columns, 
% it would have been the same to sum over rows by symmetry.
% This still gives a diag matrix
D = diag(sum(W, 2));

% Laplacian Matrix
L = D - W; 


% Finding number of connected components: number of zero eigs of L: 
[eigenvectors, eigenvalues] = eigs(L, n); 
% setting arbitrary tol: 
tol = 1e-15;
Number_eigenvalues = sum(eigenvalues <= tol); 
% 1 connected component

K = 3;
% selecting first K eigenvalues to cluster
eigenv_cluster = diag(eigenvalues(n:-1:n-K+1, n:-1:n-K+1));
eigenvect_cluster = eigenvectors(:, n:-1:n-K+1); 

% using k-means to cluster
idx = kmeans(eigenvect_cluster, K); 

% clustered points
s_clustered_points = [A(:,1:2), idx]; 


%PLOTS OF THE STRUCTURE OF DATA
figure()
subplot(1,4,1)
s = scatter(s_clustered_points(:,1), s_clustered_points(:,2), [], ...
    s_clustered_points(:,3), 'filled'); 
title("Spectral  K="+ K +" clusters")
%xlim([0, 35])
%ylim([0, 35])
grid on

%now plotting a comparison of different clustering algorithms
K_means = kmeans(A(:,1:2), K); 
subplot(1,4,2)
scatter(A(:,1), A(:,2), [], ...
    K_means, 'filled'); 
title("K-means  K="+ K +" clusters")
%xlim([0, 35])
%ylim([0, 35])
grid on

eps = 0.1;
DBSCAN = dbscan(A(:,1:2), eps, K); 
subplot(1,4,3)
scatter(A(:,1), A(:,2), [], ...
    DBSCAN, 'filled'); 
title("DBSCAN, eps="+eps+" N="+K)
%xlim([0, 35])
%ylim([0, 35])
grid on

hierarchy = clusterdata(A(:,1:2), K); 
subplot(1,4,4)
scatter(A(:,1), A(:,2), [], ...
    hierarchy, 'filled'); 
title("Hierarchical, N="+K)
%xlim([0, 35])
%ylim([0, 35])
grid on
