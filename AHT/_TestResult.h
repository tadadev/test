// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TestResult.h instead.

#import <CoreData/CoreData.h>


extern const struct TestResultAttributes {
	__unsafe_unretained NSString *completed;
	__unsafe_unretained NSString *completedCount;
	__unsafe_unretained NSString *contactEmail;
	__unsafe_unretained NSString *contactPhone;
	__unsafe_unretained NSString *correctCount;
	__unsafe_unretained NSString *correctRatio;
	__unsafe_unretained NSString *earDifference;
	__unsafe_unretained NSString *finishedDate;
	__unsafe_unretained NSString *frequencies;
	__unsafe_unretained NSString *incorrectCount;
	__unsafe_unretained NSString *itemCount;
	__unsafe_unretained NSString *leftResults;
	__unsafe_unretained NSString *noiseLevel;
	__unsafe_unretained NSString *results;
	__unsafe_unretained NSString *rightResults;
	__unsafe_unretained NSString *shownAlert;
	__unsafe_unretained NSString *startedDate;
	__unsafe_unretained NSString *testNumber;
	__unsafe_unretained NSString *usingAppleEarbuds;
    __unsafe_unretained NSString *resultsText;

} TestResultAttributes;

extern const struct TestResultRelationships {
} TestResultRelationships;

extern const struct TestResultFetchedProperties {
} TestResultFetchedProperties;






















@interface TestResultID : NSManagedObjectID {}
@end

@interface _TestResult : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TestResultID*)objectID;





@property (nonatomic, strong) NSNumber* completed;



@property BOOL completedValue;
- (BOOL)completedValue;
- (void)setCompletedValue:(BOOL)value_;

//- (BOOL)validateCompleted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* completedCount;



@property int32_t completedCountValue;
- (int32_t)completedCountValue;
- (void)setCompletedCountValue:(int32_t)value_;

//- (BOOL)validateCompletedCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contactEmail;



//- (BOOL)validateContactEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contactPhone;



//- (BOOL)validateContactPhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* correctCount;



@property int32_t correctCountValue;
- (int32_t)correctCountValue;
- (void)setCorrectCountValue:(int32_t)value_;

//- (BOOL)validateCorrectCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* correctRatio;



@property float correctRatioValue;
- (float)correctRatioValue;
- (void)setCorrectRatioValue:(float)value_;

//- (BOOL)validateCorrectRatio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* earDifference;



@property int32_t earDifferenceValue;
- (int32_t)earDifferenceValue;
- (void)setEarDifferenceValue:(int32_t)value_;

//- (BOOL)validateEarDifference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* finishedDate;



//- (BOOL)validateFinishedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* frequencies;



//- (BOOL)validateFrequencies:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* incorrectCount;



@property int32_t incorrectCountValue;
- (int32_t)incorrectCountValue;
- (void)setIncorrectCountValue:(int32_t)value_;

//- (BOOL)validateIncorrectCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* itemCount;



@property int32_t itemCountValue;
- (int32_t)itemCountValue;
- (void)setItemCountValue:(int32_t)value_;

//- (BOOL)validateItemCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* leftResults;



//- (BOOL)validateLeftResults:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* noiseLevel;



@property float noiseLevelValue;
- (float)noiseLevelValue;
- (void)setNoiseLevelValue:(float)value_;

//- (BOOL)validateNoiseLevel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* results;



//- (BOOL)validateResults:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* rightResults;



//- (BOOL)validateRightResults:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shownAlert;



@property BOOL shownAlertValue;
- (BOOL)shownAlertValue;
- (void)setShownAlertValue:(BOOL)value_;

//- (BOOL)validateShownAlert:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startedDate;



//- (BOOL)validateStartedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* testNumber;



@property int32_t testNumberValue;
- (int32_t)testNumberValue;
- (void)setTestNumberValue:(int32_t)value_;

//- (BOOL)validateTestNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* usingAppleEarbuds;



@property BOOL usingAppleEarbudsValue;
- (BOOL)usingAppleEarbudsValue;
- (void)setUsingAppleEarbudsValue:(BOOL)value_;

//- (BOOL)validateUsingAppleEarbuds:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* resultsText;



//- (BOOL)validateresultsText:(id*)value_ error:(NSError**)error_;




@property (strong, nonatomic) NSDictionary *leftResponses, *rightResponses;




@end

@interface _TestResult (CoreDataGeneratedAccessors)

@end

@interface _TestResult (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCompleted;
- (void)setPrimitiveCompleted:(NSNumber*)value;

- (BOOL)primitiveCompletedValue;
- (void)setPrimitiveCompletedValue:(BOOL)value_;




- (NSNumber*)primitiveCompletedCount;
- (void)setPrimitiveCompletedCount:(NSNumber*)value;

- (int32_t)primitiveCompletedCountValue;
- (void)setPrimitiveCompletedCountValue:(int32_t)value_;




- (NSString*)primitiveContactEmail;
- (void)setPrimitiveContactEmail:(NSString*)value;




- (NSString*)primitiveContactPhone;
- (void)setPrimitiveContactPhone:(NSString*)value;




- (NSNumber*)primitiveCorrectCount;
- (void)setPrimitiveCorrectCount:(NSNumber*)value;

- (int32_t)primitiveCorrectCountValue;
- (void)setPrimitiveCorrectCountValue:(int32_t)value_;




- (NSNumber*)primitiveCorrectRatio;
- (void)setPrimitiveCorrectRatio:(NSNumber*)value;

- (float)primitiveCorrectRatioValue;
- (void)setPrimitiveCorrectRatioValue:(float)value_;




- (NSNumber*)primitiveEarDifference;
- (void)setPrimitiveEarDifference:(NSNumber*)value;

- (int32_t)primitiveEarDifferenceValue;
- (void)setPrimitiveEarDifferenceValue:(int32_t)value_;




- (NSDate*)primitiveFinishedDate;
- (void)setPrimitiveFinishedDate:(NSDate*)value;




- (NSString*)primitiveFrequencies;
- (void)setPrimitiveFrequencies:(NSString*)value;




- (NSNumber*)primitiveIncorrectCount;
- (void)setPrimitiveIncorrectCount:(NSNumber*)value;

- (int32_t)primitiveIncorrectCountValue;
- (void)setPrimitiveIncorrectCountValue:(int32_t)value_;




- (NSNumber*)primitiveItemCount;
- (void)setPrimitiveItemCount:(NSNumber*)value;

- (int32_t)primitiveItemCountValue;
- (void)setPrimitiveItemCountValue:(int32_t)value_;




- (NSString*)primitiveLeftResults;
- (void)setPrimitiveLeftResults:(NSString*)value;




- (NSNumber*)primitiveNoiseLevel;
- (void)setPrimitiveNoiseLevel:(NSNumber*)value;

- (float)primitiveNoiseLevelValue;
- (void)setPrimitiveNoiseLevelValue:(float)value_;




- (NSString*)primitiveResults;
- (void)setPrimitiveResults:(NSString*)value;




- (NSString*)primitiveRightResults;
- (void)setPrimitiveRightResults:(NSString*)value;




- (NSNumber*)primitiveShownAlert;
- (void)setPrimitiveShownAlert:(NSNumber*)value;

- (BOOL)primitiveShownAlertValue;
- (void)setPrimitiveShownAlertValue:(BOOL)value_;




- (NSDate*)primitiveStartedDate;
- (void)setPrimitiveStartedDate:(NSDate*)value;




- (NSNumber*)primitiveTestNumber;
- (void)setPrimitiveTestNumber:(NSNumber*)value;

- (int32_t)primitiveTestNumberValue;
- (void)setPrimitiveTestNumberValue:(int32_t)value_;




- (NSNumber*)primitiveUsingAppleEarbuds;
- (void)setPrimitiveUsingAppleEarbuds:(NSNumber*)value;

- (BOOL)primitiveUsingAppleEarbudsValue;
- (void)setPrimitiveUsingAppleEarbudsValue:(BOOL)value_;




@end
