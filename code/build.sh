#!/bin/sh

# Build associated C/C++ code to be used with Matlab


# 1) Download MaxEnt software from at http://www.tijldebie.net/software/maxent
#
# Please note the license given there:
#
#   "This is research software and comes as is without any guarantees.
#   Only use for academic purposes is allowed without prior permission."
#
# Reference: 
#
#   Tijl De Bie. Maximum entropy models and subjective interestingness: 
#   an application to tiles in binary databases. Data Mining and Knowledge 
#   Discovery, Volume 23, Number 3, 2011, pp. 407-446.

wget http://www.tijldebie.net/system/files/DatabaseGenerator.cpp


# 2) Compile C/C++ code into Matlab executables

mex maxent.cpp
max swap.c

# 3) Done

echo "Build successful. To test, give these Matlab commands:"
echo ""
echo "To test, give these Matlab commands:"
echo ""
echo "  M = [1 0 1; 0 1 0]"
echo "  p = maxent(sum(M, 2), sum(M, 1));"
echo "  Mrasch = p <= rand(2, 3)"
echo "  Mswap = swap(M)"


