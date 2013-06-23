//
//  MTransformer-Info.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#ifndef MTransformer_MTransformer_Info_h
#define MTransformer_MTransformer_Info_h

#define ZERO 0 // Global macro ZERO, replaceing number "0" in vectors.
#define ONE 1 // Global macro ONE, replaceing number "1" in vectors.

#define arrlen(arr) (sizeof(arr)/sizeof(arr[0])) // Global macro definition, calculate length of a C style array.
#define VECTORIZATION_SIZE 4 // Global macro definition, using LLVM 5 to optimize loops through vectorization.
#define SIZE_OF_TRANSFORMATION_MATRIX 4 // Length of a 3D transformation matrix on each side. (should be 4 x 4)

/**
 Typedefed enum, representing the axis of rotation. Bit fields operation involved.
 */
typedef enum {
	X = 0x01, // 0b0000_0001
	Y = 0x02, // 0b0000_0010
	Z = 0x04  // 0b0000_0100
} MT_ROTATION_AXIS;

/**
 Typedefed matrix, containing row number, column number and float array.
 */
typedef struct MTCStyleMatrix {
	int row; // Number of row.
	int col; // Number of column.
	float *fVals; // Array containning all the float values.
} MTCStyleMatrix;

/**
 A C function create a MTCStyleMatrix with given row, column number and float array.
 */
MTCStyleMatrix MTMakeCStyleMatrix(int row, int col, float *fVals);

#endif
