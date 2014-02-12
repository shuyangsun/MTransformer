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
#define DISTANCE_ERROR 0.0001f // The error of distance for handling out of range problem.
#define TOOLBAR_HEIGHT 44 // The height of tool bar.
#define	SLEEP_TIME_FOR_ORIENTATION 5000 // Sleep time for changing orientation layout.

#define SETTINGS_DICTIONARY_NAME @"MTRANSFORMER_SETTINGS" // The dictionary name to get settings user defaults.
#define SETTINGS_AXIS_LABEL @"MTRANSFORMER_SETTINGS_AXIS_LABEL"
#define SETTINGS_SCALE_SINGLE_AXIS @"MTRANSFORMER_SETTINGS_SCALE_SINGLE_AXIS"
#define SETTINGS_SHAKE_TO_RESET @"MTRANSFORMER_SETTINGS_SHAKE_TO_RESET"
#define SETTINGS_POINTS_INFORMATION	@"MTRANSFORMER_SETTINGS_POINTS_INFORMATION"
#define SETTINGS_MODEL_INDEX @"MTRANSFORMER_SETTINGS_MODEL_INDEX"

/**
 Typedefed enum, representing the axis of rotation. Bit fields operation involved.
 */
typedef enum {
	X = 0,
	Y = 1,
	Z = 2
} MT_AXIS;

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
MTCStyleMatrix MTCStyleMatrixMake(int row, int col, float *fVals);

/**
 Typedefed point in 3D.
 */
typedef struct MT3DPoint{
	float x; // x-axis value.
	float y; // y-axis value.
	float z; // z-axis value.
} MT3DPoint;

/**
 A C function create a MT3DPoint.
 */
MT3DPoint MT3DPointMake(float x, float y, float z);



/**
 Typedefed point in 2D.
 */
typedef struct MT2DPoint{
	float a; // Value a.
	float b; // Value b.
} MT2DPoint;

/**
 A C function create a MT2DPoint.
 */
MT2DPoint MT2DPointMake(float a, float b);

/**
 C funtion get indexes of other two enties in this vector.
 */
char *indexesOfotherTwoEntries(char entry);

#endif
