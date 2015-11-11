//
//  ViewController.h
//  FileNavigator
//
//  Created by Bipin Gohel on 15/10/15.
//  Copyright (c) 2015 Bipin Gohel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileBrowsingCell.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
unsigned long long  maxFileSize;
    
}
@property (nonatomic, assign) BOOL topView;
@property(nonatomic,strong)    NSArray *options;
@property (nonatomic, strong) NSString *maxFilename;
//@property (nonatomic, assign) BOOL removeLastFileComponent;

@end

