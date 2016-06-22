//
//  EmailManager.m
//  HearingTest
//
//  Created by Martin Ceperley on 7/15/14.
//  Copyright (c) 2014 Knotable. All rights reserved.
//

#import "EmailManager.h"
#import "AppDelegate.h"
#import "TestResult.h"
#import <OMPromises/OMPromises.h>
#import <sys/utsname.h>
#import <mailgun/Mailgun.h>

#define MAILGUN_ENDPOINT_URL @"https://api.mailgun.net/v2/sandbox0d54a805e9a840d984c1af6a17276651.mailgun.org/messages"
#define MAILGUN_API_KEY @"key-6zybwrvv2y14e37wx5fscsvhz8nic8q8"

#define DOMAIN1 @"sandbox0d54a805e9a840d984c1af6a17276651.mailgun.org"
//#define FROM @"Audicus Hearing Test <hearingtest@sandbox0d54a805e9a840d984c1af6a17276651.mailgun.org>"
#define FROM @"Audicus Hearing Test <mobiletest@audicus.com>"

#define SUBJECT @"Hearing Test Results"
#define SUBJECT2 @"Let's Interpret Your Hearing Results"

#define LEE @"lee@audicus.com"    //leevonk@gmail.com
//#define LEE @"tdemar@gmail.com"

#define TO @"mobiletest@audicus.com"
//#define TO @"tdemar@gmail.com"


#define TEXT_X @"<html><body><br>\
Thank you for trying the Audicus Mobile Hearing Test!!!<br>\
Inline Image here: <img src=\"Home.png\"> <br>\
</body></html>"


//Inline Image here: <img src=\"cid:Results\"> <br>\




#define TEXT2 @"\
Many thanks for taking the Audicus Hearing Test!\n\
\n\
We are still putting the finishing touches on the detailed test results, so stay tuned.\n\
\n\
In the meantime, pay us a visit at <a href=\"www.audicus.com\">Audicus</a> \n\
\n\
Regards and happy hearing!\n\
\n\
- The Audicus Team\n\
"

#define TEXT3 @"<html><body><br>\
Many thanks for taking the Audicus Hearing Test!<br>\
<br>\
In the meantime, pay us a visit at <a href=\"www.audicus.com\">Audicus.com</a><br>\
<br>\
Regards and happy hearing!<br>\
<br>\
- The Audicus Team\
</body></html>"


#define TEXT4 @"<html><body><br>\
Hello, <br>\
<br>\
Thank you for trying the Audicus Mobile Hearing Test.<br>\
<br>\
Below you'll find your results and insight into your hearing health.<br>\
<br>\
The warmest regards,<br>\
<br>\
- Team Audicus\
</body></html>"


//In the attachment you'll find your results and insight into your hearing health.<br>\


//<img src="cid:cartman.jpg"></html><br>\
//<img src=\"results/image.png\"><br>\

NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}



@implementation EmailManager




+ (OMPromise *)sendEmailTo2:(NSString *)email{
//    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"PDF_TEST.pdf"];
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"Results.jpg"];
//    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    UIImage *img = [UIImage imageWithData:imageData];
    
    
    if (!email) {
        NSLog(@"error no test result to email");
        return [OMPromise promiseWithError:nil];
    }
    
    if ([email isEqualToString:@"a@a.com"]) {
        email = LEE;
    }
    
    NSMutableString *email_text = [NSMutableString stringWithFormat:TEXT2];
    NSLog(@"text:\n%@", email_text);
    
    OMDeferred *deferred = [OMDeferred deferred];
    
    Mailgun *mailgun = [Mailgun clientWithDomain:DOMAIN1 apiKey:MAILGUN_API_KEY];
    MGMessage *message = [MGMessage messageFrom:FROM
                                             to:email
                                        subject:SUBJECT2
                                           body:email_text];
    //    MGMessage *message = [[MGMessage alloc] init];
    
    
//    [message addImage:resultsImg withName:@"results" type:PNGFileType];
    //[message addImage:resultsImg withName:@"results" type:PNGFileType inline:YES];
    //[message addImage:img withName:@"results" type:JPEGFileType inline:YES];
    
    //NSMutableString *body = [NSMutableString stringWithFormat:TEXT3, resultsImg];
    [message setHtml:TEXT3];
    
    
    
    
    
    
    
    
    //NSLog(@"attachments: %@", message.attachments);
    //NSLog(@"inline attachments: %@", message.inlineAttachments);
    
    
    [mailgun sendMessage:message success:^(NSString *messageId) {
        [deferred fulfil:nil];
    } failure:^(NSError *error) {
        [deferred fail:error];
        //NSLog(@"Error on Send: %@", error.description);
    }];
    
    return deferred.promise;
}


+ (OMPromise *)sendEmailTo:(NSString *)email{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFile = [documentDirectory stringByAppendingPathComponent:@"PDF_TEST.pdf"];
    NSData *pdfData = [NSData dataWithContentsOfFile:pdfFile];
    
    
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"Results.jpg"];
//    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    UIImage *img = [UIImage imageWithData:imageData];
    
    
    
    
    //UIImage *img = [UIImage imageNamed:@"Logo2"];
    
    
    
    OMDeferred *deferred = [OMDeferred deferred];
    
    Mailgun *mailgun = [Mailgun clientWithDomain:DOMAIN1 apiKey:MAILGUN_API_KEY];
    MGMessage *message = [MGMessage messageFrom:FROM
                                             to:email
                                        subject:SUBJECT2
                                           body:@""];
    [message addBcc:TO];
    
    
    //NSString *base = [UIImagePNGRepresentation(img) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //NSString *imgS = [NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@/>", base];
    NSError* error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Email_Template" ofType: @"html"];
    NSString *html = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
    

    //[message setHtml:TEXT4];
    //[message setHtml:TEXT_X];
    [message setHtml:html];

    
    
    [message addAttachment:pdfData withName:@"Hearing Test Results.pdf" type:@"application/pdf"];
    
    
    //    [message addImage:resultsImg withName:@"results" type:PNGFileType];
    //[message addImage:resultsImg withName:@"results" type:PNGFileType inline:YES];
    //[message addImage:img withName:@"Results" type:JPEGFileType inline:YES];
    //NSLog(@"Inline: %@", message.inlineAttachments);
    
    
    //[message addImage:img withName:@"Logo2.png" type:PNGFileType inline:YES];
    
    
    //NSLog(@"attachments: %@", message.attachments);
    //NSLog(@"inline attachments: %@", message.inlineAttachments);
    
    
    [mailgun sendMessage:message success:^(NSString *messageId) {
        [deferred fulfil:nil];
    } failure:^(NSError *error) {
        [deferred fail:error];
        //NSLog(@"Error on Send: %@", error.description);
    }];
    
    return deferred.promise;
}




+ (BOOL)isValidEmail:(NSString *)email
{
        NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        NSRange dotRange;
        
        if([emailTest evaluateWithObject:email])
        {
            dotRange = [email rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [email length])];
            int indexOfDot = dotRange.location;
            
            if(dotRange.location != NSNotFound)
            {
                NSString *topLevelDomain = [email substringFromIndex:indexOfDot];
                topLevelDomain = [topLevelDomain lowercaseString];
                NSSet *TLD;
                TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
                if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain]))
                {
                    return YES;
                }
            }
        }
    return NO;
}





@end
