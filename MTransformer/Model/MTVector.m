//
//  MTVector.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTVector.h"

#include "GlobalMacro.h" // Global macro definitions.

@interface MTVector()

/**
 @method A method generate invalid index warning message.
 @param maxIndex Maximun index value available.
 @param requiredIndex Required index value.
 */
-(void)generateInvalidIndexMessage: (NSUInteger) maxIndex withRequiredIndex: (int) requiredIndex;

/** Property indicating whether this vector is a homogeneous vector. (readonly in header file)*/
@property (readwrite, nonatomic, getter = isHomogeneous) BOOL homogeneous; // Redefine as readwrite inside implementation file.

@end

@implementation MTVector

// Initialize with a certain amount of entires, values are ZERO.
-(id)initWithNumberOfEntries:(int)numberOfEntries
{
	self = [super init];
	if (self) {
		if (numberOfEntries > 0) { // Check if number of entries is more than 0.
			for (int i = 0; i < numberOfEntries; ++i) { // Initialize entries with ZEROs.
				[self addObject:@(ZERO)]; // Initialize with ZEROs.
			}
		}
		self.homogeneous = NO; // Initialize proerty homogeneous to NO.
	}
	return self;
}

// Init vector with a array containing all the etnries' values.
-(id)initWithEntriesArray:(NSArray *)entriesOfVector
{
	self = [super init];
	if (self) {
		if ([entriesOfVector count] > 0) { // If there is element in the array.
			for (int i = 0; i < [entriesOfVector count]; ++i) {
				if ([[entriesOfVector objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // If it is a NSNumber.
					[self addObject:[entriesOfVector objectAtIndex:i]]; // Add the object to the entries property.
				} else { // If it is not a NSNumber.
					[self addObject:@(ZERO)]; // Add ZERO to it. (to guarantee the number of entry)
					NSLog(@"Object initializing vector is not a NSNumber.\nclass name: %@", [[self objectAtIndex:i] class]); // Generate log message.
				}
			}
		} else { // If there is not any elements, generate log message, init it to a ZERO vector.
			self = [self initWithNumberOfEntries:1]; // Init as a ZERO vector.
			NSLog(@"No element in initialize array."); // Generate log message
		}
		self.homogeneous = NO; // Initialize proerty homogeneous to NO.
	}
	return self;
}

// Designated initializer.
-(id)init
{
	return [self initWithNumberOfEntries:1]; // Initialize with a ZERO vector.
}

// return entry value as float number.
-(float)entryAtIndexAsFloat:(int)index
{
	float res = ZERO; // Initialize result to value ZERO.
	if (index >= 0 && index < [self entryCount]) { // If it is a valid index:
		res = [[self objectAtIndex:index] floatValue]; // Get the float value of entry at that index.
	} else { // If index is invalid, generate log message.
		[self generateInvalidIndexMessage:[self entryCount] withRequiredIndex:index]; // Generate warning message for invalid index.
	}
	return res; // Return the result.
}

// Return an C float pointer to a float array.
-(void)entriesAsFloatArray: (float *) arr length: (NSUInteger *) len
{
	float *res = NULL; // Initialize res to NULL.
	for (int i = 0; i < [self entryCount]; ++i) { // Iterate through the entries:
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // Check if it's a NSNumber.
			*(res + i) = [[self objectAtIndex:i] floatValue]; // Set the value in float array to float value of entry.
		} else { // If it's not an NSNumber, replace value with 0, generate log message.
			*(res + i) = ZERO; // Assign the value ZERO.
			NSLog(@"Invalid object in entires."); // Generate log message.
		}
	}
	if (arr != NULL) // If arr is not NULL:
		arr = res; // Assign res to arr.
	if (len != NULL) // If pointer to len is not NULL:
		*len = (NSUInteger)[self entryCount]; // Get the number of entry.
}

// Change the value of entry at certain index, return operation succeed or not.
-(BOOL)replaceEntryAtIndex:(int)index withFloatValue:(float)fValue
{
	BOOL res = NO; // Initialize the result to be NO, if succeed, change it to YES.
	if (index >= 0 && index < [self entryCount]) { // If it's a valid index.
		[self replaceObjectAtIndex:index withObject:@(fValue)]; // Replace entry with new value.
		res = YES; // Change the value of result to YES.
	} else { // If it's not a valid index, generate log message and return false.
		[self generateInvalidIndexMessage:[self entryCount] withRequiredIndex:index]; // Generate warning message for invalid index.
	}
	return res; // Return the result.
}

// Change the value of entry at certain index to ZERO.
-(void)clearEntryAtIndexToZero:(int)index
{
	[self replaceEntryAtIndex:index withFloatValue:ZERO]; // Replace entry at index with value ZREO.
}

// Change all entries's value to 0.
-(void)clearToZeroVector
{
	for (int i = 0; i < [self entryCount]; ++i) { // Iterate through entries:
		[self replaceEntryAtIndex:i withFloatValue:ZERO]; // Change the value of entry to ZERO.
	}
}

// Remove the first entry in the vector. (if there are more than one entries)
-(void)removeFirstEntry
{
	if ([self entryCount] > 1) // If there are two or more entries.
		[self removeObjectAtIndex:0]; // Remove the first entry.
}

// Remove the last entry in the vector. (if there are more than one entries)
-(void)removeLastEntry
{
	if ([self entryCount] > 1) // If there are two or more entries.
		[self removeLastObject]; // Remove the last entry.
}

// Add one entry with given float value to the end of vector.
-(void)addEntryWithFloatValue:(float)fValue
{
	[self addObject:@(fValue)]; // Add a entry with float value to the end of vector.
}

// Convert this entry to it's homogeneous vector if it is not.
-(void)toHomogeneousVector
{
	if (self.homogeneous == NO) { // Check to see if it's a homogeneous vector.
		[self addEntryWithFloatValue:ONE]; // If it is not a homogeneous vector, add ONE to the end of vector.
		self.homogeneous = YES; // Set homogeneous to YES.
	}
}

// Return homogeneouse vector of this vector.
-(MTVector *)getHomogeneousVector
{
	MTVector *res = [self mutableCopy]; // Make a copy of current vector.
	[res toHomogeneousVector]; // Make the copy homogeneous.
	return res; // Return the result.
}

-(void)removeEntryAtIndex:(int)index
{
	if (index >= 0 && index < [self entryCount]) { // It it is a valid index number:
		if ([self entryCount] - 1 > 0){ // If it has more than 1 entries:
			[self removeObjectAtIndex:index]; // Remove this entry. (length should be one less.)
		} else { // If it has less than 1 entry:
			NSLog(@"Cannot remove entry, vector length is not enough."); // Generate warning message indicate vector length is not enought to remove a entry.
		}
	} else { // If it's a invalid index
		[self generateInvalidIndexMessage:[self entryCount] withRequiredIndex:index]; // Generate warning message for invalid index.
	}
}

// Remove entries in certain range.
-(void)removeEntriesInRange:(NSRange)range
{
	[self removeObjectsInRange:range]; // Remove objects in this range.
}

// Return an array containing entries in certain range.
-(NSArray *)entriesInRange: (NSRange) range
{
	NSIndexSet *rangeToGet = [NSIndexSet indexSetWithIndexesInRange:range]; // Create a index set of entries in the range.
	return [self objectsAtIndexes:rangeToGet]; // Return entries in the index set.
}

// Remove entries beside the given range.
-(void)removeOtherEntiresInVector:(NSRange)range
{
	NSRange firstPartToRemove = NSMakeRange(0, range.location); // Find the range of the first part to remove.
	NSRange secondPartToRemove = NSMakeRange(range.location + range.length, [self entryCount] - (range.location + range.length)); // Find the range of the second part to remove.
	[self removeEntriesInRange:firstPartToRemove]; // Remove the first part.
	[self removeEntriesInRange:secondPartToRemove]; // Remove the second part.
}

// Add entries to the end of the array.
-(void)addEntries:(NSArray *)entriesToAdd
{
	if (self.homogeneous == NO){ // If it is NOT the homogeneous form, just add entries to the end of the vector.
		[self addObjectsFromArray:entriesToAdd]; // Add entries to the end of the vector.
	} else { // If it is the homogeneous form, insert entries above the last entry.
		NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:[self count] -1]; // Create a index set, contain only the last index of this vector.
		[self insertObjects:entriesToAdd atIndexes:indexes]; // Add entries to the end of vector, above the last one.
	}
}

//************************ For 3D transformation ***************************//

// Get the 2D projection vectors. Also remove the last entry if it is a homogeneous vector.
-(void)removeEntriesUnderTheFirstTwoRows
{
	if ([self entryCount] > 2) // If there are more than two entries:
		[self removeObjectsInRange:NSMakeRange(2, [self entryCount] - 2)]; // Remove all entries under the first two rows.
}
//************************ For 3D transformation ***************************//

// Overriding entryCount getter method.
-(NSUInteger)entryCount
{
	return [self count]; // The only place where should use [self count] other places should be [self entryCount].
}

// Overriding dimension getter method.
-(NSUInteger)dimension
{
	NSUInteger res = 0; // Create a result to return later, initialize it to 0.
	for (int i = 0; i < [self entryCount]; ++i) { // Iterate through the loop, find none ZERO vectors.
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]] && [[self objectAtIndex:i] floatValue] != ZERO) { // If current entry is a NSNumber and is a none ZERO vector.
			++res; // Add one to res.
		}
	}
	return res; // Return the result.
}

// Overriding description
-(NSString *)description
{
	NSMutableString *res = [NSMutableString stringWithFormat:@"%uD vector: (", [self entryCount]]; // Description should contain the dimension of vector, and entries.
	for (int i = 0; i < [self entryCount]; ++i) { // Loop through all the entries:
		NSMutableString *appending = [NSMutableString stringWithFormat:@"%.1f", [[self objectAtIndex:i] floatValue]]; // Append the value of entry.
		if (i < [self entryCount] - 1) { // If this is not the last element, add coma and space.
			[appending appendString:@", "]; // Append comma and space.
		}
		[res appendString:appending]; // Append the entries information string.
		appending = nil; // Set appending to nil.
	}
	[res appendString:@")"]; // Add close parenthesize.
	return res; // Return the result.
}

// Generate warning indicates invalid index.
-(void)generateInvalidIndexMessage:(NSUInteger)maxIndex withRequiredIndex:(int)requiredIndex
{
	NSLog(@"Invalid index.\nentires length: %u\nrequested index: %d", maxIndex, requiredIndex); // Generate log message, containing max index and required index.
}

@end

