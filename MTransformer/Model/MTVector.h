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

@interface MTVector : NSObject

/** Entries holding entry values. */
@property (copy, nonatomic) NSMutableArray *entries;

/** 
 @method Create a vector with certain number of entries, all entries are initialized with 0.
 */
-(id)initWithNumberOfEntries: (int) numberOfEntries;

/**
 @method Initialize entries with an array contains all the values.
 @param entriesOfVector  Array containing entries of vector.
 */
-(id)initWithArray: (NSArray *) entriesOfVector;

/** 
 @method Get the float value of entry at certain index as a float value.
 @param index Index of entry.
 @return The float value of entry.
 */
-(float)entryAsFloatAtIndex: (int) index;

/**
 @method Get a pointer to a float variable represents the first element of the array, the array is the entries' values.
 @return A pointer to float array.
 */
-(float *)entriesAsFloatArray;

/**
 @method A method replaces certain entry at index with a float value.
 @param index The index of entry to replace.
 @param fValue The float number to replace with.
 @return If the operation succeed or not. (If the index value is not valid, it will return false.)
 */
-(BOOL)replaceEntryAtIndex: (int) index withFloatValue: (float) fValue;

@end
