//
//  MTPoint.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTPoint.h"

#import "GlobalMacro.h" // Global macro definitions.

@interface MTPoint() // Class extension

/** Property indicating whether this vector is a homogeneous vector. (readonly in header file)*/
@property (readwrite, nonatomic, getter = isHomogeneous) BOOL homogeneous; // Redefine as readwrite inside implementation file.

@end

@implementation MTPoint

// Initialize with a certain name.
-(id)initWithName:(NSString *)theName
{
	self = [super init];
    if (self) {
		self.pointsConnectingTo = [[NSMutableSet alloc] init]; // Initialize pointsConnectingTo as a empty set.
		self.name = theName; // Initialize the name.
		self.visited = NO; // Not visited yet.
	}
	return self;
}

// Designated initializer.
- (id)init
{
    return [self initWithName:@"N/A"]; // Return a Point with default name @"N/A"
}

// Connect to single point.
-(void)connectToPoint:(MTPoint *)point
{
	if ([self.pointsConnectingTo containsObject:point] == NO) { // If it doens't contain this point.
		[self.pointsConnectingTo addObject:point]; // Add it to the set.
		if ([point.pointsConnectingTo containsObject:self] == NO) { // If the point want to connect to isn't connecting to this point, make the connection.
			[point.pointsConnectingTo addObject:self]; // Add it to the set.
		}
	}
}

// Connect to multiple points.
-(void)connectToPoints:(id)points // WARNING! points should be a collection, so we can enumerate through it.
{
	NSEnumerator *enumerator = [points objectEnumerator]; // Create a enumerator for points.
	MTPoint *p;
	while (p = [enumerator nextObject]) { // While there are objects in enumerator, iterate through it.
		[self connectToPoint:p]; // Call method connectToPoint:
	}
}

// Return points connecting to as an array.
-(NSArray *)pointsConnectingToAsArray
{
	return [self.pointsConnectingTo allObjects]; // All objects in the NSSet.
}

// Overriding getter method of pointsConnectingTo, using lazy instantiation
-(NSMutableSet *)pointsConnectingTo
{
	if (!_pointsConnectingTo) _pointsConnectingTo = [NSMutableSet set]; // Lazy instantiation.
	return _pointsConnectingTo; // Return _pointsConnectingTo.
}

// Overriding getter method of name, using laze instantiation, return @"N/A" if the name is not initialized.
-(NSString *)name
{
	if (!_name) _name = @"N/A"; // Lazy instantiation, initialize with default name @"N/A"
	return _name; // Return _name.
}

// Overriding description.
-(NSString *)description
{
	NSMutableString *res = [NSMutableString stringWithFormat:@"point %@: ", self.name]; // The result string to return later.

	//************************** Appending Vector Information *****************************//
	if (self.entryCount > 0){ // If there are entries in this point, add the point position.
		[res appendString:@"("]; // Add opening parenthesis.
		for (int i = 0; i < [self entryCount]; ++i) {
			if (i < [self entryCount] - 1){ // If this is NOT the last entry
				[res appendFormat:@"%.1f, ", [self entryAtIndexAsFloat:i]]; // Append the float value and comma.
			} else { // If this is the last entry
				[res appendFormat:@"%.1f", [self entryAtIndexAsFloat:i]]; // Append the float value.
			}
		}
		[res appendString:@")"]; // Add closing parenthesis.
	}
	//************************** Appending Vector Information *****************************//

	//************************ Points Connecting To Information ***************************//
	if ([self.pointsConnectingTo count] > 0){ // If there are points it is connecting to.
		[res appendString:@" "]; // Append a space.
		[res appendString:@"Connects To: "]; // Uncomment this line to show string @"Connects To: " before displaying points name.
		NSEnumerator *enumerator = [self.pointsConnectingTo objectEnumerator]; // Create a enumertor to enumerate the points.
		MTPoint *p;
		while (p = [enumerator nextObject]) { // While there is a point in the enumerator
			[res appendFormat:@"%@, ", p.name]; // Append the name of the point.
		}
		NSRange lastTwoChars = NSMakeRange([res length] - 2, 2); // Range of the last two chars: @", )"
		[res deleteCharactersInRange:lastTwoChars]; // Delete the last two chars, because this is the end of points list.
	}
	//************************ Points Connecting To Information ***************************//

	return res;
}

//************************ Coding Protocol Methods ***************************//

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self.entries = [aDecoder decodeObjectForKey:@"MTPointEntries"]; // Decode entries.
	self.homogeneous = [aDecoder decodeBoolForKey:@"MTPointHomogeneous"]; // Decode bool value homogeneous.
	self.name = [aDecoder decodeObjectForKey:@"MTPointName"]; // Decode name.
	self.pointsConnectingTo = [aDecoder decodeObjectForKey:@"MTPointPointsConnectingTo"]; // Decode pointsConnectingTo.
	self.visited = [aDecoder decodeBoolForKey:@"MTPointVisited"]; //Decode visited.

	return self; // Return the result.
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject: self.entries forKey:@"MTPointEntries"]; // Encode entries.
	[aCoder encodeBool:self.homogeneous forKey:@"MTPointHomogeneous"]; // Encode homogeneous.
	[aCoder encodeObject:self.name forKey:@"MTPointName"]; // Encode name.
	[aCoder encodeObject:self.pointsConnectingTo forKey:@"MTPointPointsConnectingTo"]; // Encode pointsConnectingTo
	[aCoder encodeBool:self.visited forKey:@"MTPointVisited"]; // Encode visited.
}

//************************ Coding Protocol Methods ***************************//

@end

