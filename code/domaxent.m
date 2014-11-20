% Matlab wrapper for Rasch (maxent) C++ code
%
% Copyright (c) 2014 Aleksi Kallio

function Mrand = domaxent(M)

[~, ~, R, C] = marginsums(M);
Pmaxent = maxent(R, C);
Mrand = rand(size(M)) <= Pmaxent;