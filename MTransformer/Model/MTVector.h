//
//  MTVector.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @interface A class representing a vector.
 A vector has a property called entries which holds the values of all the entries.
 Variables in entries should be NSNumbers (with float value).
 Designated initialization method will generate a 0 vector with 1 entry.
 Other init methods will generate a vector with #n 0 entires.
 */

@interface MTVector : NSMutableArray

//************************ Property ***************************//

/** Property representing number of entry in the vector, including 0 entry. */
@property (readonly, nonatomic) unsigned long entryCount;
/** Property representing dimension of entry. */
@property (readonly, nonatomic) unsigned long dimension;

//************************ Property ***************************//

//************************ Methods ***************************//

/**
 @method Create a vector with certain number of entries, all entries are initialized with 0.
 @param numberOfEntries The number of entries need to be initialized in the vector, including 0 entries.
 */
-(id)initWithNumberOfEntries: (int) numberOfEntries;

/**
 @method Initialize entries with an array contains all the values.
 @param entriesOfVector  Array containing entries of vector.
 */
-(id)initWithEntriesArray: (NSArray *) entriesOfVector;

/** 
 @method Get the float value of entry at certain index as a float value.
 @param index Index of entry.
 @return The float value of entry.
 */
-(float)entryAsFloatAtIndex: (int) index;

/**
 @method Get a pointer to a float variable represents the first element of the array, the array is the entries' values. Store, the length in the pointer to len.
 */
-(void)entriesAsFloatArray: (float *) arr length: (NSUInteger *) len;

/**
 @method A method replaces certain entry at index with a float value.
 @param index The index of entry to replace.
 @param fValue The float number to replace with.
 @return If the operation succeed or not. (If the index value is not valid, it will return false.)
 */
-(BOOL)replaceEntryAtIndex: (int) index withFloatValue: (float) fValue;

/**
 @method Clear the entries to zero. (Change this vector to a zero vector).
 */
-(void)clearToZeroVector;

/**
 @method Replace current entry value at certain index with number 0.
 @param index The index of entry to replace.
 */
-(void)clearEntryAtIndexToZero: (int) index;

/**
 @method Remove the first entry in the vector.
 */
-(void)removeFirstEntry;

/**
 @method Remove the last entry in the vector.
 */
-(void)removeLastEntry;

/**
 @method Add an entry with float value to the last rwo of vector.
 */
-(void)addEntryWithFloatValue: (float) fValue;

/**
 @method Change current vector to its homogeneous vector.
 */
-(void)toHomogeneousVector;

/**
 @method Get homogeneous vector of current vector. (make a copy, then add entry with value 1 to the vector)
 @return The homogeneous vector of current vector.
 */
-(MTVector *)getHomogeneousVector;

/**
 @method Remove entries in certain range.
 @param range Range of entries to remove.
 */
-(void)removeEntriesInRange: (NSRange) range;

/**
 @method Get entries in certain range.
 @param range Range of entries want to get.
 @return Array containing entries in range.
 */
-(NSMutableArray *)entriesInRange: (NSRange) range;

/**
 @method Remove entires not int the range.
 @param range Range of entries to keep.
 */
-(void)removeOtherEntiresInVector: (NSRange) range;

/**
 @method Add values in array to vector.
 @param entriesToAdd Enties' value to add to vector.
 */
-(void)addEntries: (NSArray *) entriesToAdd;

/**
 @method Remove entries under the first two row.
 */
-(void)removeEntriesUnderTheFirstTwoRow;

//************************ Methods ***************************//

@end
