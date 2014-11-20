% Count switch boxes by using the matrix product method
%
% Copyright (c) 2014 Aleksi Kallio

function c = sbcount_prod(M)

if size(M, 1) > size(M, 2)
    M = M';
end

c = trace(M*(1-M')*M*(1-M'))/2;

end

