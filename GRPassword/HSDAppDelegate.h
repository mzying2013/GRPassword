//
//  HSDAppDelegate.h
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDMainViewController.h"

#define PASSWORD_VIEW_WIDTH 270
#define CIRCLE_MARGIN 40
#define PATH_WIDTH 6.0

@interface HSDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) HSDMainViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
