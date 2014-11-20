// Matlab main function for Rasch model in DatabaseGenerator.cpp
//
// Copyright (c) 2014 Aleksi Kallio

#include <iostream>
#include <fstream>
#include <sstream>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <set>
#include <vector>
#include <time.h>
#include <ctime>
#include <algorithm>
#include <iterator>
#include <cstdlib>
#include <sys/time.h>
#include <sys/resource.h>
#include "mex.h" 
using namespace std;


#include "DatabaseGenerator.cpp"



/////////////////////////////////////////////

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  //  mexPrintf("Hello, world!\n"); 

  if (nrhs != 2) {
    mexErrMsgTxt("Needs two inputs: row sum vector and column sum vector.");
  }

  if (nlhs != 1) {
    mexErrMsgTxt("Creates one and only one output: probability matrix.");
  }

  if (mxGetM(prhs[0]) > 1 || mxGetM(prhs[1]) > 1) {
    mexErrMsgTxt("Row and column sums must be row vectors.");
  }

  //  int rs[] = {1, 1, 1};
  //  int cs[] = {2, 1};
  //  vector<int>* rowSums = new vector<int>(rs, rs + sizeof(rs) / sizeof(int));
  //  vector<int>* colSums = new vector<int>(cs, cs + sizeof(cs) / sizeof(int));

  int m = mxGetN(prhs[0]);
  int n = mxGetN(prhs[1]);
  double* rs = mxGetPr(prhs[0]);
  double* cs = mxGetPr(prhs[1]);

  vector<int>* rowSums = new vector<int>;
  vector<int>* colSums = new vector<int>;

  for (int i = 0; i < m; i++) { 
    rowSums->push_back((int)rs[i]);
  }

  for (int i = 0; i < n; i++) {
    colSums->push_back((int)cs[i]);
  }


  // Make the probabilistic model
  //cout << "Creating the null model" << "\n";
  NullModel* nm = new NullModel(rowSums,colSums);

  // Create output
  plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
  double* output = mxGetPr(plhs[0]);

  // Start generating matrixes
  srand(time(0));

  // iterate over unique rows/cols
  for (int i=0; i<nm->nq; i++) {
    for (int j=0; j<nm->mq; j++) {
      double numerator = exp(nm->muq[i]+nm->lambdaq[j]);
      double prob = numerator/(1+numerator);

      // iterate over all real rows/cols that correspond to this unique row/col
      int nqi = nm->rowIndices->at(i)->size();
      int mqj = nm->colIndices->at(j)->size();

      for (int ii=0; ii<nqi; ii++) {
        for (int jj=0; jj<mqj; jj++) {

	  int x =  nm->rowIndices->at(i)->at(ii);
	  int y =  nm->colIndices->at(j)->at(jj);
	  output[y * m + x] = prob;
	}
      }
    }
  }		

  delete nm;
  delete rowSums;
  delete colSums;
}




