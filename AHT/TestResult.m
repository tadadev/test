#import "TestResult.h"

static NSString *DATE_FORMAT = @"EEEE, MMMM d 'at' h:mm a";
static NSString *DATE_FORMAT2 = @"MM/dd/yyyy ':' h:mm a";


@interface TestResult ()
@end


@implementation TestResult

-(NSString *)formattedStartDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    //dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    return [dateFormatter stringFromDate:self.startedDate];
}


-(NSString *)formattedFinishedDateTime{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    //dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:DATE_FORMAT2];
    
    return [dateFormatter stringFromDate:self.finishedDate];
}


-(NSString *)formattedFinishedDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [NSLocale currentLocale];
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:self.finishedDate];
    
}

-(NSString *)formattedFinishedTime{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [NSLocale currentLocale];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];


    //[dateFormatter setDateFormat:@"h:mm a"];
    
    return [dateFormatter stringFromDate:self.finishedDate];
    
}


@end
