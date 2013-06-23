//
//  GlobalMacro.c
//  MTransformer
//
//  Created by Shuyang Sun on 6/23/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#include <stdio.h>
#include "GlobalMacro.h"

MTCStyleMatrix MTMakeCStyleMatrix(int row, int col, float *fVals) {
	MTCStyleMatrix res; // Create a MTCStyleMatrix.
	res.row = row; // Assign row value.
	res.col = col; // Assign column value.
	res.fVals = fVals; // Assign float array.
	return res; // Return result.
}