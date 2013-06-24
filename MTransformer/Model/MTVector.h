//
//  MTVector.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A class representing a vector.
 A vector has a property called entries which holds the values of all the entries.
 Variables in entries should be NSNumbers (with float value).
 Designated initialization method will generate a 0 vector with 1 entry.
 Other init methods will generate a vector with #n 0 entires.
 */

@interface MTVector : NSObject <NSCopying, NSMutableCopying, NSCoding> // Meet requirement of copying protocols, and coding protocol to do deep copy.

//************************ Properties ***************************//

/** Property containning all the entries in this vector. */
@property (strong, nonatomic) NSMutableArray *entries;
/** Property representing number of entry in the vector, including 0 entries and homogeneous entry. (Simply returning [self count] inside method)*/
@property (readonly, nonatomic) NSUInteger entryCount;
/** Property representing dimension of entry, homogeneous entry doesn't count. (Returning number of none-ZERO entries) */
@property (readonly, nonatomic) NSUInteger dimension;
/** Property indicating whether this vector is a homogeneous vector. */
@property (readonly, nonatomic, getter = isHomogeneous) BOOL homogeneous;

//************************ Properties ***************************//

//************************ Methods ***************************//

/**
 Initialize vector with certain number of entries, all entries are initialized with 0.
 @param numberOfEntries The number of entries need to be initialized in the vector, including 0 entries.
 */
-(id)initWithNumberOfEntries: (NSUInteger) numberOfEntries;

/**
 Initialize vector with an array contains all the values.
 @param entriesOfVector  Array containing entries of vector.
 */
-(id)initWithEntriesArray: (NSArray *) entriesOfVector;

/** 
 Initialize vector with given C style float array.
 @param fArr C style float array containg values of entries.
 */
-(id)initWithFloatArray: (float *) fArr;

/**
 Get entry at index as a NSNumber object.
 @param index The index of entry want to get.
 */
-(id)entryAtIndex:(NSUInteger)index;

/** 
 Get the float value of entry at certain index as a float value.
 @param index Index of entry.
 @return The float value of entry.
 */
-(float)entryAtIndexAsFloat:(NSUInteger)index;

/**
 Get a pointer to a float variable represents the first element of the array, the array is the entries' values. Store, the length in the pointer to len.
 @param arr Address of array, which will store the float values.
 @param len Pointer to NSUInteger variable, which will store the length of arr (number of entries).
 */
-(void)entriesAsFloatArray: (float *) arr length: (NSUInteger *) len; // C involved.

/**
 A method replaces certain entry at index with a float value.
 @param index The index of entry to replace.
 @param fValue The float number to replace with.
 @return Whether the operation succeed or not. (If the index value is not valid, it will return false.)
 */
-(BOOL)replaceEntryAtIndex: (NSUInteger) index withFloatValue: (float) fValue;

/**
 Clear the entries to zero. (Change this vector to a zero vector).
 */
-(void)clearToZeroVector;

/**
 Replace current entry value at certain index with number 0.
 @param index The index of entry to replace.
 */
-(void)clearEntryAtIndexToZero: (NSUInteger) index;

/**
 Remove the first entry in the vector.
 */
-(void)removeFirstEntry;

/**
 Remove the last entry in the vector.
 */
-(void)removeLastEntry;

/**
 Add an entry with float value to the last rwo of vector.
 @param fValue Float value of entry adding to vector.
 */
-(void)addEntryWithFloatValue: (float) fValue;

/**
 Change current vector to its homogeneous vector.
 */
-(void)toHomogeneousVector;

/**
 Get homogeneous vector of current vector. (make a copy, then add entry with value 1 to the vector)
 @return The homogeneous vector of current vector.
 */
-(MTVector *)getHomogeneousVector;

/**
 If the current vector is homogeneous vector, chagne it to the normal form.
 */
-(void)toRegularVector;

/**
 If the current vector is homogeneous vector, get the normal form. (make a copy, then remove the last entry)
 @return The homogeneous vector of current vector.
 */
-(MTVector *)getRegularVector;

/** 
 Remove a certain entry at given index from vector.
 @param index Index of entry to remove.
 */
-(void)removeEntryAtIndex: (NSUInteger) index;

/**
 Remove entries in certain range from vector.
 @param range Range of entries to remove.
 */
-(void)removeEntriesInRange: (NSRange) range;

/**
 Get entries in certain range.
 @param range Range of entries want to get.
 @return Array containing entries in range.
 */
-(NSArray *)entriesInRange: (NSRange) range;

/**
 Remove entires not int the range.
 @param range Range of entries to keep.
 */
-(void)removeOtherEntiresInVector: (NSRange) range;

/**
 Add values in array to vector.
 @param entriesToAdd Enties' value to add to vector.
 */
-(void)addEntries: (NSArray *) entriesToAdd;

/**
 Remove entries under the first two row.
 */
-(void)removeEntriesUnderTheFirstTwoRows;

/**
 The same as entryAtIndex.
 @param index The index of entry want to get.
 */
-(id)objectAtIndex: (NSUInteger) index;

/**
 The same as entryAtIndex.
 @param index The index of entry want to get.
 */
-(id)objectAtIndexedSubscript: (NSUInteger) index;


//************************ Methods ***************************//

//************************ Linear Algebra Calculation ***************************//

/** 
 Multiply this vector by a scalar.
 @param scalar The number to multiply.
 */
-(void)multiplyByNumber: (float) scalar;

/**
 Add this vector to another vector.
 @param anotherVector The vector to add.
 */
-(void)addVector: (MTVector *) anotherVector;

/** 
 Substract this vector by another vector.
 @param anotherVector The vector to substract.
 */
-(void)substractVector: (MTVector *) anotherVector;

//************************ Linear Algebra Calculation ***************************//

@end
