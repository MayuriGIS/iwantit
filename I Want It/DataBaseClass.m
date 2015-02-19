   //
//  DataBaseClass.m
//  CMSP APP
//
//  Created by mac4 on 05/04/14.
//  Copyright (c) 2014 Great Innovus Solutions. All rights reserved.
//

#import "DataBaseClass.h"
#import "AppDelegate.h"
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@implementation DataBaseClass
{
    AppDelegate *delegate;
    
}
#pragma mark - DataBaseCreation

- (void) createDatabase;
{
    dataBaseName=@"IWANTITTESTDB.sqlite";
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    NSFileManager * fileManager=[NSFileManager defaultManager];
    dataBasePath=[cachePath stringByAppendingPathComponent:dataBaseName];
    NSLog(@"dataBasePath : %@",dataBasePath);
 
    BOOL success=[fileManager fileExistsAtPath:dataBasePath];
    if(success)
    {
        NSLog(@"SUCCESS");
        return;
    }else
    {
        NSLog(@"FAIL");
    }
    NSString * databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];
    NSLog(@"databasePathFromApp:%@",databasePathFromApp);
    [fileManager copyItemAtPath:databasePathFromApp toPath:dataBasePath error:nil];
}

#pragma mark - insertDataBaseActions

-(void)insertWishlistData:(NSMutableDictionary *)wishContentArray{
    
    NSString *productId,*description,*itemidx,*quantity,*isDeleted,*lastModified,*amount,*image;
    
    NSMutableArray *temArray=[[NSMutableArray alloc]initWithCapacity:0];
    [temArray addObjectsFromArray:[[wishContentArray objectForKey:@"data"]objectForKey:@"data"]];

    
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK) {
        
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);

        for (int i=0; i<temArray.count; i++) {
            
            productId = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"productId"]];
            description = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"description"]];
            itemidx = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"itemIdx"]];
            quantity = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"quantity"]];
            isDeleted=[NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"isDeleted"]];
            lastModified=[NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"lastModified"]];
            amount = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"amount"]];
            image = [NSString stringWithFormat:@"%@",[[temArray objectAtIndex:i] valueForKey:@"mainImageId"]];
            
            NSString *queryString=[NSString stringWithFormat:@"INSERT INTO wishlist_tbl  values('%@','%@','%@','%@','%@','%@','%@','%@')",productId,description,itemidx,quantity,isDeleted,lastModified,amount,image];
            NSLog(@"queryString : %@",queryString);
            const char *sqlstatement =[queryString UTF8String];
            
            
            sqlite3_stmt *compiledStatement=nil;
            
            if(sqlite3_prepare_v2(dataBaseObject, sqlstatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
                NSLog(@"Error:%s", sqlite3_errmsg(dataBaseObject));
            }
            else{
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    NSLog(@"wishlist_tbl inserted successfully");
                }
            }
            sqlite3_finalize(compiledStatement);

        }
        if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));

        sqlite3_close(dataBaseObject);
    }
    
}


- (void) insertAppointmentData:(NSMutableArray *)completeContentArray{
    
    //CREATE TABLE appointment_tbl(id,locationId,retailerId,email,loyaltyId,loyaltyFName,loyaltyLName,apptDate,startTime,endTime,reason,status,description,lastNotifiedMember,isActive,created,lastModified,isDeleted,cancelReason, PRIMARY KEY (id))
    
    NSString *appt_id,*location_id,*retailer_id,*email,*localty_id,*first_name,*last_name,*appt_date,*start_time,*end_time,*appt_reason,*appt_status,*appt_desc,*appt_lastMem,*appt_active,*appt_created,*appt_lastModified,*appt_deleted,*appt_cancelReason;

    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK) {
        
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);
        
        for (int i=0; i<completeContentArray.count; i++) {
            
        appt_id = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i] valueForKey:@"id"]];
        
        location_id = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i] valueForKey:@"locationId"]];
        
        retailer_id = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i] valueForKey:@"retailerId"]];
        
        email = [NSString stringWithFormat:@"%@",[[completeContentArray  objectAtIndex:i]valueForKey:@"email"]];
        
        localty_id = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"loyaltyId"]];
        
        first_name = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"loyaltyFName"]];
        
        last_name = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"loyaltyLName"]];
        
        appt_date = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"apptDate"]];
        
        start_time = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"startTime"]];
        
        end_time = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"endTime"]];
        
        appt_reason=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"reason"]];
        
        appt_status=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"status"]];
        
        appt_desc=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"description"]];
        
        if ([completeContentArray valueForKey:@"lastNotifiedMember"] != (id)[NSNull null]) {
            appt_lastMem = [NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i] valueForKey:@"lastNotifiedMember"]];
        }else{
            appt_lastMem = @"";
        }
        
        appt_active=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"isActive"]];
        
        appt_created=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"created"]];
        
        appt_lastModified=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"lastModified"]];
        
        appt_deleted=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"isDeleted"]];
        
        if ([completeContentArray valueForKey:@"cancelReason"] != (id)[NSNull null]) {
            appt_cancelReason=[NSString stringWithFormat:@"%@",[[completeContentArray objectAtIndex:i]valueForKey:@"cancelReason"]];
        }else{
            appt_cancelReason=@"";
        }
        
        NSString *queryString=[NSString stringWithFormat:@"INSERT INTO appointment_tbl  values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",appt_id,location_id,retailer_id,email,localty_id,first_name,last_name,appt_date,start_time,end_time,appt_reason,appt_status,appt_desc,appt_lastMem,appt_active,appt_created,appt_lastModified,appt_deleted,appt_cancelReason];
      
//        NSLog(@"queryString : %@",queryString);
        const char *sqlstatement =[queryString UTF8String];
        
        sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(dataBaseObject, sqlstatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSLog(@"Error:%s", sqlite3_errmsg(dataBaseObject));
        }
        else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                NSLog(@"wishlist_tbl inserted successfully");
            }
        }
        sqlite3_finalize(compiledStatement);
        
        }
       
        if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));
        sqlite3_close(dataBaseObject);
        
    }
}

-(void)insertShopperlistData:(NSMutableDictionary *)shopperContentArray{

    NSString *productId,*description,*itemidx,*quantity,*isDeleted,*lastModified,*amount,*image;
    
    NSMutableArray *apptArray=[[NSMutableArray alloc]initWithCapacity:0];
    [apptArray addObjectsFromArray:[[shopperContentArray objectForKey:@"data"]objectForKey:@"data"]];
    
    
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)==SQLITE_OK) {
        
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);

        for (int i=0; i<apptArray.count; i++) {
            
            productId=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"productId"]];
            
            description=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"description"]];
            
            itemidx=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"itemIdx"]];
            
            quantity=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"quantity"]];
            
            isDeleted=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"isDeleted"]];
            
            lastModified=[NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"lastModified"]];
            
            amount = [NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"amount"]];
            
            image = [NSString stringWithFormat:@"%@",[[apptArray objectAtIndex:i]objectForKey:@"mainImageId"]];


            NSString *queryString=[NSString stringWithFormat:@"INSERT INTO shopper_tbl  values('%@','%@','%@','%@','%@','%@','%@','%@')",productId,description,itemidx,quantity,isDeleted,lastModified,amount,image];
            NSLog(@"queryString : %@",queryString);
            const char *sqlstatement =[queryString UTF8String];
            
            sqlite3_stmt *compiledStatement=nil;
            
            if(sqlite3_prepare_v2(dataBaseObject, sqlstatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
                NSLog(@"Error:%s", sqlite3_errmsg(dataBaseObject));
            }
            else{
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    NSLog(@"shopper_tbl inserted successfully");
                }
            }
            sqlite3_finalize(compiledStatement);
        }
        if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));
        sqlite3_close(dataBaseObject);
    }
    
}

#pragma mark ReadDatebase-Actions

-(NSMutableArray *)readWishlist{
    
    //productId,description,itemidx,quantity,isDeleted,lastModified
    
    NSString * queryString=@"";
    NSMutableArray *apptArray = [[NSMutableArray alloc]init];
    queryString=[NSString stringWithFormat:@"SELECT DISTINCT * FROM wishlist_tbl"];
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject) == SQLITE_OK){
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);
        const char * sqlStatement=[queryString UTF8String];
        sqlite3_stmt * compiledStatement;
        
        if(sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                
                NSMutableDictionary *properList =[[NSMutableDictionary alloc]init];
                
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"productId"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]forKey:@"description"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]forKey:@"itemidx"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]forKey:@"quantity"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]forKey:@"isDeleted"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]forKey:@"lastModified"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]forKey:@"amount"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]forKey:@"image"];

                [apptArray addObject:properList];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    
    if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));
    sqlite3_close(dataBaseObject);
    
    
    return apptArray;
}

- (NSMutableArray *) readAppointment
{
    
    NSString * queryString=@"";
    NSMutableArray *apptArray = [[NSMutableArray alloc]init];
    queryString=[NSString stringWithFormat:@"SELECT * FROM appointment_tbl"];
    NSLog(@"queryString:%@",queryString);
    
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject) == SQLITE_OK){
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);
        const char * sqlStatement=[queryString UTF8String];
        sqlite3_stmt * compiledStatement;
        
        if(sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                
                NSMutableDictionary *properList =[[NSMutableDictionary alloc]init];
                
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"id"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]forKey:@"locationId"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]forKey:@"retailerId"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]forKey:@"email"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]forKey:@"loyaltyId"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]forKey:@"loyaltyFName"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]forKey:@"loyaltyLName"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]forKey:@"apptDate"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)]forKey:@"startTime"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)]forKey:@"endTime"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)]forKey:@"reason"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)]forKey:@"status"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)]forKey:@"description"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)]forKey:@"created"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)]forKey:@"lastModified"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)]forKey:@"isDeleted"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)]forKey:@"cancelReason"];
                
                [apptArray addObject:properList];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    
    if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));
    sqlite3_close(dataBaseObject);
  
    
    return apptArray;
    
    
}


-(NSMutableArray *)readShopper{
    

    NSString * queryString=@"";
    NSMutableArray *apptArray = [[NSMutableArray alloc]init];
    queryString=[NSString stringWithFormat:@"SELECT DISTINCT * FROM shopper_tbl"];
    NSLog(@"queryString:%@",queryString);
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject) == SQLITE_OK){
        sqlite3_exec(dataBaseObject, "BEGIN TRANSACTION", 0, 0, 0);
        const char * sqlStatement=[queryString UTF8String];
        sqlite3_stmt * compiledStatement;
        
        if(sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                
                NSMutableDictionary *properList =[[NSMutableDictionary alloc]init];
                
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"productId"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]forKey:@"description"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]forKey:@"itemidx"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)]forKey:@"quantity"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]forKey:@"isDeleted"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)]forKey:@"lastModified"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)]forKey:@"amount"];
                [properList setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)]forKey:@"image"];

                [apptArray addObject:properList];
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    
    if (sqlite3_exec(dataBaseObject, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) NSLog(@"SQL Error: %s",sqlite3_errmsg(dataBaseObject));
    sqlite3_close(dataBaseObject);

    return apptArray;
}


#pragma mark - UpdateDataBaseActions

- (void) updateFittingrunnData:(NSString *)productId
{
    NSString *lite =[NSString stringWithFormat:@"UPDATE fittingroom_tbl set product_request = 'Request' WHERE product_id='%@'",productId];
    
    NSLog(@"queryString:%@",lite);
    
    const char * sqlStatement = [lite UTF8String];
    if(sqlite3_open([dataBasePath UTF8String], &dataBaseObject) == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"fittingroom_table is updated successfully...");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(dataBaseObject);
    
}

#pragma mark deleteDatabase-Action

-(void)deleteWishListTable;
{
    
    NSString *lite =[NSString stringWithFormat:@"DELETE FROM wishlist_tbl"];
    const char * sqlStatement = [lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"wishlist_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(dataBaseObject);
}

-(void)deleteAppointmentTable;
{
    
    NSString *lite =[NSString stringWithFormat:@"DELETE FROM appointment_tbl"];
    const char * sqlStatement = [lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"appointment_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(dataBaseObject);
}

-(void)deleteShopperTable;
{
    
    NSString *lite =[NSString stringWithFormat:@"DELETE FROM shopper_tbl"];
    const char * sqlStatement = [lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"shopper_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(dataBaseObject);
}


-(void) removeProductFromWishlist:(NSString *)productId tableName:(NSString *)tName{

    NSString *lite =[NSString stringWithFormat:@"DELETE FROM %@ WHERE productId='%@'",tName,productId];
    const char * sqlStatement = [lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"product deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(dataBaseObject);
    
    
    
}

-(void)deleteAllTables;
{
    
    NSString *lite =[NSString stringWithFormat:@"DELETE FROM appointment_tbl"];
    const char * sqlStatement = [lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"appointment_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(dataBaseObject);
    
   lite =[NSString stringWithFormat:@"DELETE FROM wishlist_tbl"];
    sqlStatement =[lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"wishlist_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(dataBaseObject);
    
    lite =[NSString stringWithFormat:@"DELETE FROM shopper_tbl"];
    sqlStatement =[lite UTF8String];
    if (sqlite3_open([dataBasePath UTF8String], &dataBaseObject)== SQLITE_OK) {
        sqlite3_stmt *compiledStatement=nil;
        if (sqlite3_prepare_v2(dataBaseObject, sqlStatement, -1, & compiledStatement, NULL)!= SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(dataBaseObject));
            
        }else{
            if (sqlite3_step(compiledStatement) == SQLITE_DONE)
                
                NSLog(@"shopper_tbl deleted successfully");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(dataBaseObject);

    
}

@end
