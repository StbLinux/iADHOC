//
//  AppDelegate.h
//  iADHOC
//
//  Created by Mirko Totera on 05/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSString *ServerId;
@property (strong,nonatomic) NSString *PortaId;
@property (strong,nonatomic) NSString *UtenteId;
@property (strong,nonatomic) NSString *PasswordId;
@property (strong,nonatomic) NSString *DBId;
@property (strong,nonatomic) NSString *AziendaId;
@property (strong,nonatomic) NSString *OnlineId;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

