//
//  MTVector.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTVector.h"

@interface MTVector()

@end

@implementation MTVector

@synthesize entries = _entries; // Override both setter and getter method, need to be synthesized.


-(id)initWithNumberOfEntries:(int)numberOfEntries
{
	self = [super init];
	if (self) {
		if (numberOfEntries > 0) { // Check if number of entries is more than 0.
			self.entries = [NSMutableArray arrayWithCapacity:numberOfEntries];
			for (int i = 0; i < numberOfEntries; ++i) { // Initialize entries with 0's.
				[self.entries addObject:[NSNumber numberWithFloat:0.0]];
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
					[self.entries addObject:[entriesOfVector objectAtIndex:i]];
				} else { // If it is not a NSNumber, add 0 to it. (to guarantee the number of entry)
					[self.entries addObject:[NSNumber numberWithFloat:0.0]];
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
	float res = 0.0;
	if (index > 0 && index < [self.entries count]) {
		res = [self.entries count];
	} else { // If index is invalid, generate log message.
		NSLog(@"Invalid index.\nentires length: %d\nrequested index: %d", [self.entries count], index);
	}
	return res;
}

-(float *)entriesAsFloatArray
{
	float *res = NULL;
	for (int i = 0; i < [self.entries count]; ++i) {
		if ([[self.entries objectAtIndex:i] isKindOfClass:[NSNumber class]]) { // Check if it's a NSNumber.
			*(res + i) = [[self.entries objectAtIndex:i] floatValue];
		} else { // If it's not an NSNumber, replace value with 0, generate log message.
			*(res + i) = 0.0;
			NSLog(@"Invalid object in entires.");
		}
	}
	return res;
}

-(BOOL)replaceEntryAtIndex:(int)index withFloatValue:(float)fValue
{
	BOOL res = NO;
	if (index > 0 && index < [self.entries count]) { // If it's a valid index.
		[self.entries replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:fValue]];
		res = YES;
	} else { // If it's not a valid index, generate log message and return false.
		NSLog(@"Invalid index.\nentires length: %d\nrequested index: %d", [self.entries count], index);
	}
	return res;
}

// Override the getter method of entries, using lazy instantiation
-(NSMutableArray *)entries
{
	if (!_entries) _entries = [[NSMutableArray alloc] init];
	return _entries;
}

// Override the setter method of entries, the argument is a NSArray.
-(void)setEntries:(NSArray *)entries
{
	_entries = [entries mutableCopy];
}

@end

