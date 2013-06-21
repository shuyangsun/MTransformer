//
//  MTVector.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTVector.h"

#include "GlobalMacro.h" // Global macro definition.

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
		self.homogeneous = NO;
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
		self.homogeneous = NO;
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
	float res = ZERO;
	if (index >= 0 && index < [self entryCount]) {
		res = [[self objectAtIndex:index] floatValue];
	} else { // If index is invalid, generate log message.
		[self generateInvalidIndexMessage:[self entryCount] withRequiredIndex:index]; // Generate warning message for invalid index.
	}
	return res;
}

// Return an C float pointer to a float array.
-(void)entriesAsFloatArray: (float *) arr length: (NSUInteger *) len
{
	float *res = NULL; // Initialize res to NULL.
	for (int i = 0; i < [self entryCount]; ++i) {
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // Check if it's a NSNumber.
			*(res + i) = [[self objectAtIndex:i] floatValue];
		} else { // If it's not an NSNumber, replace value with 0, generate log message.
			*(res + i) = ZERO; // Assign the value ZERO.
			NSLog(@"Invalid object in entires.");
		}
	}
	if (arr != NULL) // If arr is not NULL:
		arr = res; // Assign res to arr.
	if (len != NULL) // If pointer to len is not NULL:
		*len = (NSUInteger)[self entryCount]; // Get the number of entry.
}


-(BOOL)replaceEntryAtIndex:(int)index withFloatValue:(float)fValue
{
	BOOL res = NO;
	if (index >= 0 && index < [self entryCount]) { // If it's a valid index.
		[self replaceObjectAtIndex:index withObject:@(fValue)];
		res = YES;
	} else { // If it's not a valid index, generate log message and return false.
		[self generateInvalidIndexMessage:[self entryCount] withRequiredIndex:index]; // Generate warning message for invalid index.
	}
	return res;
}

-(void)clearToZeroVector
{
	for (int i = 0; i < [self entryCount]; ++i) {
		[self replaceEntryAtIndex:i withFloatValue:ZERO];
	}
}

-(void)clearEntryAtIndexToZero:(int)index
{
	[self replaceEntryAtIndex:index withFloatValue:ZERO];
}

-(void)removeFirstEntry
{
	if ([self entryCount] > 1) // If there are two or more entries.
		[self removeObjectAtIndex:0];
}

-(void)removeLastEntry
{
	if ([self entryCount] > 1) // If there are two or more entries.
		[self removeLastObject];
}

-(void)addEntryWithFloatValue:(float)fValue
{
	[self addObject:@(fValue)];
}

-(void)toHomogeneousVector
{
	[self addEntryWithFloatValue:ONE];
	self.homogeneous = YES;
}

-(MTVector *)getHomogeneousVector
{
	MTVector *res = [self mutableCopy];
	[res toHomogeneousVector];
	return res;
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

-(void)removeEntriesInRange:(NSRange)range
{
	[self removeObjectsInRange:range];
}

-(NSMutableArray *)entriesInRange: (NSRange) range
{
	
	NSIndexSet *rangeToGet = [NSIndexSet indexSetWithIndexesInRange:range];
	NSMutableArray *res = (NSMutableArray*)[self objectsAtIndexes:rangeToGet];
	return res;
}

-(void)removeOtherEntiresInVector:(NSRange)range
{
	NSRange firstPartToRemove = NSMakeRange(0, range.location);
	NSRange secondPartToRemove = NSMakeRange(range.location + range.length, [self entryCount] - (range.location + range.length));
	[self removeEntriesInRange:firstPartToRemove];
	[self removeEntriesInRange:secondPartToRemove];
}

-(void)addEntries:(NSArray *)entriesToAdd
{
	[self addObjectsFromArray:entriesToAdd];
}

-(void)removeEntriesUnderTheFirstTwoRow
{
	if ([self entryCount] > 2)
		[self removeObjectsInRange:NSMakeRange(2, [self entryCount] - 2)];
}

// Overriding entryCount getter method.
-(NSUInteger)entryCount
{
	return [self count]; // The only place where should use [self count] other places should be [self entryCount].
}

// Overriding dimension getter method.
-(NSUInteger)dimension
{
	unsigned long res = 0;
	for (int i = 0; i < [self entryCount]; ++i) {
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]] && [[self objectAtIndex:i] floatValue] != ZERO) {
			++res;
		}
	}
	return res;
}

// Overriding description
-(NSString *)description
{
	NSMutableString *res = [NSMutableString stringWithFormat:@"%uD vector: (", [self entryCount]];
	for (int i = 0; i < [self entryCount]; ++i) {
		NSMutableString *appending = [NSMutableString stringWithFormat:@"%.1f", [[self objectAtIndex:i] floatValue]];
		if (i < [self entryCount] - 1) { // If this is not the last element, add coma and space.
			[appending appendString:@", "];
		}
		[res appendString:appending];
	}
	return res;
}

// Generate warning indicates invalid index.
-(void)generateInvalidIndexMessage:(NSUInteger)maxIndex withRequiredIndex:(int)requiredIndex
{
	NSLog(@"Invalid index.\nentires length: %u\nrequested index: %d", maxIndex, requiredIndex); // Generate log message.
}

@end

