//
//  CommonWebServices.m
//  SAP
//
//  Created by mac6 on 29/12/15.
//  Copyright © 2015 Great Innovus Solutions. All rights reserved.
//

#import "CommonWebServices.h"


@implementation CommonWebServices

@synthesize delegate, activityIndicator;

-(id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

#pragma mark - Common methods for get and post

- (void)sendGetWebserviceRequestWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *)) failure urlString:(NSString *) urlString
{
    // Here we are setting the values to the completionBlock and FailureBlock…
    self.completionBlock = completion;
    self.failureBlock = failure;
    
    Reachability *reachableVia = [Reachability reachabilityForInternetConnection];
    //[reachableVia startNotifier];
    
    NetworkStatus remoteHostStatus = [reachableVia currentReachabilityStatus];
    
    if(remoteHostStatus != NotReachable)
    {
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        
        urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if( urlConnection )
        {
            responseData = [[NSMutableData alloc] init];
        }
    }
    else
    {
        if (activityIndicator != nil)
            [activityIndicator hideActivityIndicator];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)sendPostWebserviceRequestWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *)) failure urlString:(NSString *) urlString postData:(NSDictionary *) data
{
    // Here we are setting the values to the completionBlock and FailureBlock…
    self.completionBlock = completion;
    self.failureBlock = failure;
    
    Reachability *reachableVia = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus remoteHostStatus = [reachableVia currentReachabilityStatus];
    
    if(remoteHostStatus != NotReachable)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if( urlConnection )
        {
            responseData = [[NSMutableData alloc] init];
        }
    }
    else
    {
        if (activityIndicator != nil)
            [activityIndicator hideActivityIndicator];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (activityIndicator != nil)
        [activityIndicator hideActivityIndicator];
    
    // If we get any connection error we can manage it here…
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network error occured, Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alertView show];
    
    // Here we are checking the failureBlock is nil or initialized.
    if (self.failureBlock != nil)
    {
        self.failureBlock(error);
    }
    
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *responseStringWithEncoded = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response Json : %@", responseStringWithEncoded);
    
    //NSData *jsonData = [responseStringWithEncoded dataUsingEncoding:NSUTF8StringEncoding];
    
    Class NSJSONSerializationclass = NSClassFromString(@"NSJSONSerialization");
    NSDictionary *resultDic;
    NSError *error;
    
    if (NSJSONSerializationclass)
    {
        resultDic = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: &error];
    }
    
    // If the webservice response having values we have to call the completionBlock…
    if (resultDic)
    {
        if (self.completionBlock != nil)
        {
            self.completionBlock(resultDic);
        }
    }
}

#pragma mark Empty Web Response
+ (BOOL) isWebResponseNotEmpty:(id) respose
{
    if (respose != nil && respose != (id)[NSNull null])
        return YES;
    else
        return NO;
}

#pragma mark - API calling
- (void)loginApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/QueryLoyaltyMembers", [CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void)getWishListApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/GetWishlistItems",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void)getProductDetailApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/ProductSearch",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}


- (void)createAppointmentWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/CreateAppointment",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void) getAllAppointmentsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/GetCustomerAppointments",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}


- (void) getAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/GetAppointmentDetails",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void) cancellAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/CancelAppointment",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void) updateAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/UpdateAppointment",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void)createNotificationCustomerArrivalWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/NotifyCustomerArrival",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

- (void)removeWishListApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict{
    NSString *urlString = [NSString stringWithFormat:@"%@json/process/execute/RemoveFromWishlist",[CommonWebServices serverName]];
    [self sendPostWebserviceRequestWithCompletionBlock:completion failureBlock:failure urlString:urlString postData:dataDict];
}

+(NSString *)serverName{
    NSString *url;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:SERVERNAME]) {
        url = [[NSUserDefaults standardUserDefaults]objectForKey:SERVERNAME];
    }
    return url;
}

+(NSDictionary *)userDetail{
    
    
    return nil;
}
@end
