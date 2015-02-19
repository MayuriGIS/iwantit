//
//  DataBaseClass.h
//  CMSP APP
//
//  Created by mac4 on 05/04/14.
//  Copyright (c) 2014 Great Innovus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseClass : NSObject{
    NSString * dataBaseName,* dataBasePath;
    sqlite3 * dataBaseObject;
}



#pragma mark-INSERTED
- (void) createDatabase;
- (void) insertWishlistData:(NSDictionary *)wishContentArray;
- (void) insertAppointmentData:(NSMutableArray *)completeContentArray;
- (void) insertShopperlistData:(NSMutableDictionary *)shopperContentArray;

#pragma mark-RETERIVED

- (NSMutableArray *) readWishlist;
- (NSMutableArray *) readAppointment;
- (NSMutableArray *) readShopper;

#pragma mark-DELETED
- (void) deleteWishListTable;
- (void) deleteAppointmentTable;
- (void) deleteShopperTable;
- (void) deleteAllTables;
- (void) removeProductFromWishlist:(NSString *)productId tableName:(NSString *)tName;


@end
