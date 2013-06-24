//
//  GlobalMacro.c
//  MTransformer
//
//  Created by Shuyang Sun on 6/23/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#include <stdio.h>
#include "GlobalMacro.h"

// C function makes a MTCStyleMatrix.
MTCStyleMatrix MTCStyleMatrixMake(int row, int col, float *fVals) {
	MTCStyleMatrix res; // Create a MTCStyleMatrix.
	res.row = row; // Assign row value.
	res.col = col; // Assign column value.
	res.fVals = fVals; // Assign float array.
	return res; // Return result.
}

// A C function create a MT3DPoint.
MT3DPoint MT3DPointMake(float x, float y, float z)
{
	MT3DPoint res; // Create a 3D point.
	res.x = x; // Assign x value.
	res.y = y; // Assign y value.
	res.z = z; // Assign z value.
	return res; // Return the result.
}

// A C function create a MT2DPoint.
MT2DPoint MT2DPointMake(float a, float b)
{
	MT2DPoint res; // Create a 2D point.
	res.a = a; // Assign a value.
	res.b = b; // Assign b value.
	return res; // Return the result.
}