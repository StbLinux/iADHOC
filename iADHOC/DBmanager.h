//
//  DBmanager.h
//  iADHOC
//
//  Created by Mirko Totera on 11/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBmanager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

@property (nonatomic, strong) NSMutableArray *arrResults;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;






@end
