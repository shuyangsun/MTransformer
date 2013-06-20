//
//  MTVector.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTVector.h"\

#define ZERO 0 // Global macro ZERO, replaceing number "0" in vectors.
#define ONE 1 // Global macro ONE, replaceing number "1" in vectors.

@interface MTVector()

@end

@implementation MTVector

-(id)initWithNumberOfEntries:(int)numberOfEntries
{
	self = [super init];
	if (self) {
		if (numberOfEntries > 0) { // Check if number of entries is more than 0.
			for (int i = 0; i < numberOfEntries; ++i) { // Initialize entries with 0's.
				[self addObject:@(ZERO)]; // Initialize with 0's.
			}
		}
	}
	return self;
}

-(id)initWithArray:(NSArray *)entriesOfVector
{
	self = [super init];
	if (self) {
		if ([entriesOfVector count] > 0) { // If there is element in the array.
			for (int i = 0; i < [entriesOfVector count]; ++i) {
				if ([[entriesOfVector objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // If it is a NSNumber, get the float value
					[self addObject:[entriesOfVector objectAtIndex:i]];
				} else { // If it is not a NSNumber, add 0 to it. (to guarantee the number of entry)
					[self addObject:@(ZERO)];
					NSLog(@"Object initializing vector is not a NSNumber.\nclass name: %@", [[self objectAtIndex:i] class]);
				}
			}
		} else { // If there is not any elements, generate log message, init it to a zero vector.
			self = [self initWithNumberOfEntries:1];
			NSLog(@"No element in initialize array.");
		}
	}
	return self;
}

// Designated initializer.
-(id)init
{
	return [self initWithNumberOfEntries:1];
}


-(float)entryAsFloatAtIndex:(int)index
{
	float res = ZERO;
	if (index > 0 && index < [self count]) {
		res = [[self objectAtIndex:index] floatValue];
	} else { // If index is invalid, generate log message.
		NSLog(@"Invalid index.\nentires length: %d\nrequested index: %d", [self count], index);
	}
	return res;
}

-(float *)entriesAsFloatArray
{
	float *res = NULL;
	for (int i = 0; i < [self count]; ++i) {
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // Check if it's a NSNumber.
			*(res + i) = [[self objectAtIndex:i] floatValue];
		} else { // If it's not an NSNumber, replace value with 0, generate log message.
			*(res + i) = ZERO;
			NSLog(@"Invalid object in entires.");
		}
	}
	return res;
}

-(BOOL)replaceEntryAtIndex:(int)index withFloatValue:(float)fValue
{
	BOOL res = NO;
	if (index > 0 && index < [self count]) { // If it's a valid index.
		[self replaceObjectAtIndex:index withObject:@(fValue)];
		res = YES;
	} else { // If it's not a valid index, generate log message and return false.
		NSLog(@"Invalid index.\nentires length: %d\nrequested index: %d", [self count], index);
	}
	return res;
}

-(void)clearToZeroVector
{
	for (int i = 0; i < [self count]; ++i) {
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
}

-(MTVector *)getHomogeneousVector
{
	MTVector *res = [self mutableCopy];
	[res toHomogeneousVector];
	return res;
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
-(unsigned long)entryCount
{
	return [self count];
}

// Overriding dimension getter method.
-(unsigned long)dimension
{
	unsigned long res = 0;
	for (int i = 0; i < [self count]; ++i) {
		if ([[self objectAtIndex:i] isKindOfClass:[NSNumber class]] && [[self objectAtIndex:i] floatValue] != ZERO) {
			++res;
		}
	}
	return res;
}

@end

