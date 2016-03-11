//
//  CommonWebServices.h
//  SAP
//
//  Created by mac6 on 29/12/15.
//  Copyright © 2015 Great Innovus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityIndicatorController.h"
#import "Reachability.h"

typedef void (^JSONWebserviceCompletionBlock) (NSDictionary *resultDictionary);
typedef void (^JSONWebserviceFailureBlock) (NSError *error);

@interface CommonWebServices : NSObject<NSURLConnectionDelegate>{
    NSURLConnection *urlConnection;
    NSMutableData *responseData;
}

@property (nonatomic, copy) JSONWebserviceCompletionBlock completionBlock;
@property (nonatomic, copy) JSONWebserviceFailureBlock failureBlock;
@property (nonatomic, strong) UIViewController *delegate;
@property (nonatomic, strong) ActivityIndicatorController *activityIndicator;


+(NSString *)serverName;
+(NSDictionary *)userDetail;

+ (BOOL) isWebResponseNotEmpty:(id) respose;



- (void)loginApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void)getWishListApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void)getProductDetailApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;


- (void) getAllAppointmentsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void) getAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void) cancellAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void) updateAppointmentDetailsWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;


    
- (void) createAppointmentWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void) createNotificationCustomerArrivalWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;

- (void)removeWishListApiWithCompletionBlock:(void (^) (NSDictionary *)) completion failureBlock:(void (^) (NSError *))failure dataDict:(NSDictionary *)dataDict;


+ (void)getMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))errors;

+ (void)putMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))errors;

+ (void)postMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))errors;

+ (void)deleteMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))errors;


@end
