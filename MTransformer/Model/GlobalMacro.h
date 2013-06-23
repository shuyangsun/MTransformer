//
//  MTransformer-Info.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#ifndef MTransformer_MTransformer_Info_h
#define MTransformer_MTransformer_Info_h

#define ZERO ((float)0.0) // Global macro ZERO, replaceing number "0" in vectors.
#define ONE ((float)1.0) // Global macro ONE, replaceing number "1" in vectors.

#define arrlen(arr) (sizeof(arr)/sizeof(arr[0])) // Global macro definition, calculate length of a C style array.
#define VECTORIZATION_SIZE 4 // Global macro definition, using LLVM 5 to optimize loops through vectorization.

#endif
