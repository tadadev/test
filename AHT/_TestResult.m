// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TestResult.m instead.

#import "_TestResult.h"

const struct TestResultAttributes TestResultAttributes = {
	.completed = @"completed",
	.completedCount = @"completedCount",
	.contactEmail = @"contactEmail",
	.contactPhone = @"contactPhone",
	.correctCount = @"correctCount",
	.correctRatio = @"correctRatio",
	.earDifference = @"earDifference",
	.finishedDate = @"finishedDate",
	.frequencies = @"frequencies",
	.incorrectCount = @"incorrectCount",
	.itemCount = @"itemCount",
	.leftResults = @"leftResults",
	.noiseLevel = @"noiseLevel",
	.results = @"results",
	.rightResults = @"rightResults",
	.shownAlert = @"shownAlert",
	.startedDate = @"startedDate",
	.testNumber = @"testNumber",
	.usingAppleEarbuds = @"usingAppleEarbuds",
    .resultsText = @"resultsText",
};

const struct TestResultRelationships TestResultRelationships = {
};

const struct TestResultFetchedProperties TestResultFetchedProperties = {
};

@implementation TestResultID
@end

@implementation _TestResult

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TestResult" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TestResult";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TestResult" inManagedObjectContext:moc_];
}

- (TestResultID*)objectID {
	return (TestResultID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"completedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"completed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"completedCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"completedCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"correctCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"correctCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"correctRatioValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"correctRatio"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"earDifferenceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"earDifference"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"incorrectCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"incorrectCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"itemCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"noiseLevelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"noiseLevel"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shownAlertValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shownAlert"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"testNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"testNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"usingAppleEarbudsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"usingAppleEarbuds"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
    if ([key isEqualToString:@"resultsText"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"resultsText"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic completed;



- (BOOL)completedValue {
	NSNumber *result = [self completed];
	return [result boolValue];
}

- (void)setCompletedValue:(BOOL)value_ {
	[self setCompleted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCompletedValue {
	NSNumber *result = [self primitiveCompleted];
	return [result boolValue];
}

- (void)setPrimitiveCompletedValue:(BOOL)value_ {
	[self setPrimitiveCompleted:[NSNumber numberWithBool:value_]];
}





@dynamic completedCount;



- (int32_t)completedCountValue {
	NSNumber *result = [self completedCount];
	return [result intValue];
}

- (void)setCompletedCountValue:(int32_t)value_ {
	[self setCompletedCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCompletedCountValue {
	NSNumber *result = [self primitiveCompletedCount];
	return [result intValue];
}

- (void)setPrimitiveCompletedCountValue:(int32_t)value_ {
	[self setPrimitiveCompletedCount:[NSNumber numberWithInt:value_]];
}





@dynamic contactEmail;






@dynamic contactPhone;






@dynamic correctCount;



- (int32_t)correctCountValue {
	NSNumber *result = [self correctCount];
	return [result intValue];
}

- (void)setCorrectCountValue:(int32_t)value_ {
	[self setCorrectCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCorrectCountValue {
	NSNumber *result = [self primitiveCorrectCount];
	return [result intValue];
}

- (void)setPrimitiveCorrectCountValue:(int32_t)value_ {
	[self setPrimitiveCorrectCount:[NSNumber numberWithInt:value_]];
}





@dynamic correctRatio;



- (float)correctRatioValue {
	NSNumber *result = [self correctRatio];
	return [result floatValue];
}

- (void)setCorrectRatioValue:(float)value_ {
	[self setCorrectRatio:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveCorrectRatioValue {
	NSNumber *result = [self primitiveCorrectRatio];
	return [result floatValue];
}

- (void)setPrimitiveCorrectRatioValue:(float)value_ {
	[self setPrimitiveCorrectRatio:[NSNumber numberWithFloat:value_]];
}





@dynamic earDifference;



- (int32_t)earDifferenceValue {
	NSNumber *result = [self earDifference];
	return [result intValue];
}

- (void)setEarDifferenceValue:(int32_t)value_ {
	[self setEarDifference:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveEarDifferenceValue {
	NSNumber *result = [self primitiveEarDifference];
	return [result intValue];
}

- (void)setPrimitiveEarDifferenceValue:(int32_t)value_ {
	[self setPrimitiveEarDifference:[NSNumber numberWithInt:value_]];
}





@dynamic finishedDate;






@dynamic frequencies;






@dynamic incorrectCount;



- (int32_t)incorrectCountValue {
	NSNumber *result = [self incorrectCount];
	return [result intValue];
}

- (void)setIncorrectCountValue:(int32_t)value_ {
	[self setIncorrectCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIncorrectCountValue {
	NSNumber *result = [self primitiveIncorrectCount];
	return [result intValue];
}

- (void)setPrimitiveIncorrectCountValue:(int32_t)value_ {
	[self setPrimitiveIncorrectCount:[NSNumber numberWithInt:value_]];
}





@dynamic itemCount;



- (int32_t)itemCountValue {
	NSNumber *result = [self itemCount];
	return [result intValue];
}

- (void)setItemCountValue:(int32_t)value_ {
	[self setItemCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveItemCountValue {
	NSNumber *result = [self primitiveItemCount];
	return [result intValue];
}

- (void)setPrimitiveItemCountValue:(int32_t)value_ {
	[self setPrimitiveItemCount:[NSNumber numberWithInt:value_]];
}





@dynamic leftResults;






@dynamic noiseLevel;



- (float)noiseLevelValue {
	NSNumber *result = [self noiseLevel];
	return [result floatValue];
}

- (void)setNoiseLevelValue:(float)value_ {
	[self setNoiseLevel:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveNoiseLevelValue {
	NSNumber *result = [self primitiveNoiseLevel];
	return [result floatValue];
}

- (void)setPrimitiveNoiseLevelValue:(float)value_ {
	[self setPrimitiveNoiseLevel:[NSNumber numberWithFloat:value_]];
}





@dynamic results;






@dynamic rightResults;






@dynamic shownAlert;



- (BOOL)shownAlertValue {
	NSNumber *result = [self shownAlert];
	return [result boolValue];
}

- (void)setShownAlertValue:(BOOL)value_ {
	[self setShownAlert:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveShownAlertValue {
	NSNumber *result = [self primitiveShownAlert];
	return [result boolValue];
}

- (void)setPrimitiveShownAlertValue:(BOOL)value_ {
	[self setPrimitiveShownAlert:[NSNumber numberWithBool:value_]];
}





@dynamic startedDate;






@dynamic testNumber;



- (int32_t)testNumberValue {
	NSNumber *result = [self testNumber];
	return [result intValue];
}

- (void)setTestNumberValue:(int32_t)value_ {
	[self setTestNumber:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTestNumberValue {
	NSNumber *result = [self primitiveTestNumber];
	return [result intValue];
}

- (void)setPrimitiveTestNumberValue:(int32_t)value_ {
	[self setPrimitiveTestNumber:[NSNumber numberWithInt:value_]];
}





@dynamic usingAppleEarbuds;



- (BOOL)usingAppleEarbudsValue {
	NSNumber *result = [self usingAppleEarbuds];
	return [result boolValue];
}

- (void)setUsingAppleEarbudsValue:(BOOL)value_ {
	[self setUsingAppleEarbuds:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUsingAppleEarbudsValue {
	NSNumber *result = [self primitiveUsingAppleEarbuds];
	return [result boolValue];
}

- (void)setPrimitiveUsingAppleEarbudsValue:(BOOL)value_ {
	[self setPrimitiveUsingAppleEarbuds:[NSNumber numberWithBool:value_]];
}





@dynamic resultsText;









@dynamic leftResponses, rightResponses;





@end
