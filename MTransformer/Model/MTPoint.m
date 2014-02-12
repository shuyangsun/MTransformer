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

// Get a point with specific name.
+(id)pointWithName:(NSString *)theName
{
	return [[MTPoint alloc] initWithName:theName]; // Call the other initializer method.
}

// Designated initializer.
- (id)init
{
    return [self initWithName:@"N/A"]; // Return a Point with default name @"N/A"
}

// Overriding getter method for x.
-(float)z
{
	if ([self entryCount] >= 3) { // If there are or more than 3 entries:
		return [self entryAtIndexAsFloat:2]; // Return the third entry.
	}
	return NAN; // Return NAN if there are no z.
}

// Connect to single point.
-(void)connectToPoint:(MTPoint *)point
{
	[self.pointsConnectingTo addObject:point]; // Add it to the set.
	[point.pointsConnectingTo addObject:self]; // Add itself to pointsConnectingTo of point.
}

// Disconnect from a point
-(void)disconnectFromPoint:(MTPoint *)point
{
	[self.pointsConnectingTo removeObject:point]; // Remove it from the set.
	[point.pointsConnectingTo removeObject:self]; // Remove itself from pointsConnectingTo of point.
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

// Disconnect from multiple points.
-(void)disconnectFromPoints:(id)points
{
	NSEnumerator *enumerator = [points objectEnumerator]; // Create a enumerator for points.
	MTPoint *p;
	while (p = [enumerator nextObject]) { // While there are objects in enumerator, iterate through it.
		[self disconnectFromPoint:p]; // Call method disconnectToPoint:
	}
}

// Disconnect from all points, dummy method.
-(void)disconnectFromAllPoints
{
	[self disconnectFromPoints:[self pointsConnectingTo]]; // Call another method.
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
	NSMutableString *res = [NSMutableString stringWithFormat:@"%@: ", self.name]; // The result string to return later.

	//************************** Appending Vector Information *****************************//
	if (self.entryCount > 0){ // If there are entries in this point, add the point position.
		[res appendString:@"("]; // Add opening parenthesis.
		size_t entryNumber = [self entryCount]; // Get the number to loop through
		if (self.homogeneous == YES) --entryNumber; // If it's a homogeneous number, we don't want to append that information.
		for (int i = 0; i < entryNumber; ++i) {
			if (i < entryNumber - 1){ // If this is NOT the last entry
				[res appendFormat:@"%5.1f, ", [self entryAtIndexAsFloat:i]]; // Append the float value and comma.
			} else { // If this is the last entry
				[res appendFormat:@"%.1f", [self entryAtIndexAsFloat:i]]; // Append the float value.
			}
		}
		[res appendString:@")"]; // Add closing parenthesis.
	}
	//************************** Appending Vector Information *****************************//

	//************************ Points Connecting To Information ***************************//
//	if ([self.pointsConnectingTo count] > 0){ // If there are points it is connecting to.
//		[res appendString:@" "]; // Append a space.
//		[res appendString:@"Connects To: "]; // Uncomment this line to show string @"Connects To: " before displaying points name.
//		NSEnumerator *enumerator = [self.pointsConnectingTo objectEnumerator]; // Create a enumertor to enumerate the points.
//		MTPoint *p;
//		while (p = [enumerator nextObject]) { // While there is a point in the enumerator
//			[res appendFormat:@"%@, ", p.name]; // Append the name of the point.
//		}
//		NSRange lastTwoChars = NSMakeRange([res length] - 2, 2); // Range of the last two chars: @", )"
//		[res deleteCharactersInRange:lastTwoChars]; // Delete the last two chars, because this is the end of points list.
//	}
	//************************ Points Connecting To Information ***************************//

	return res;
}

//************************ Coding Protocol Methods ***************************//

// Decoder:
-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		self.entries = [aDecoder decodeObjectForKey:@"MTPointEntries"]; // Decode entries.
		self.homogeneous = [aDecoder decodeBoolForKey:@"MTPointHomogeneous"]; // Decode bool value homogeneous.
		self.name = [aDecoder decodeObjectForKey:@"MTPointName"]; // Decode name.
		self.pointsConnectingTo = [aDecoder decodeObjectForKey:@"MTPointPointsConnectingTo"]; // Decode pointsConnectingTo.
		self.visited = [aDecoder decodeBoolForKey:@"MTPointVisited"]; //Decode visited.
	}
	return self; // Return the result.
}

// Encoder:
-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject: self.entries forKey:@"MTPointEntries"]; // Encode entries.
	[aCoder encodeBool:self.homogeneous forKey:@"MTPointHomogeneous"]; // Encode homogeneous.
	[aCoder encodeObject:self.name forKey:@"MTPointName"]; // Encode name.
	[aCoder encodeObject:self.pointsConnectingTo forKey:@"MTPointPointsConnectingTo"]; // Encode pointsConnectingTo
	[aCoder encodeBool:self.visited forKey:@"MTPointVisited"]; // Encode visited.
}

//  User NSCoding protocol to create a deepcopy of this object.
-(id)deepCopy
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:
			[NSKeyedArchiver archivedDataWithRootObject:self]]; // Use NSKeyedUnarchive and NSKeyedArchiver to create a deep copy.
}

//************************ Coding Protocol Methods ***************************//

@end

