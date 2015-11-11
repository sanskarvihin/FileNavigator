//
//  ViewController.m
//  FileNavigator
//
//  Created by Bipin Gohel on 15/10/15.
//  Copyright (c) 2015 Bipin Gohel. All rights reserved.
//

#import "ViewController.h"
#define MAXFILE_SIZE -1;

@interface ViewController ()

@end


@implementation ViewController
@synthesize options,topView,maxFilename;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    maxFileSize = 0;
    maxFilename = @"";
        
    if ([[self.navigationController viewControllers] count] == 1) {
        
        options = [NSArray arrayWithObjects:@"Main Bundle",@"SandBox", nil];
        topView = true;
    }
    else
    {
        topView = false;
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(popToTopView:)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSString *cellText;
    
    static NSString *simpleTableIdentifier = @"FileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (topView) {
        cell.imageView.image = [UIImage imageNamed:@"dir.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellText = [options objectAtIndex:indexPath.row];
    }
    
    BOOL isDirectory;
    NSString *path = [appDel.currentPath stringByAppendingPathComponent:[options objectAtIndex:indexPath.row]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        
        if (isDirectory) {
            //dir
            cell.imageView.image = [UIImage imageNamed:@"dir.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cellText = [options objectAtIndex:indexPath.row];
        }
        else
        {
            //file
            cell.imageView.image = [UIImage imageNamed:@"file.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            unsigned long long  fileszie = [self getFileSizeAtPath:path ];
            
            if (fileszie > maxFileSize) {
                maxFileSize = fileszie;
                maxFilename = [options objectAtIndex:indexPath.row];
                
                //NSLog(@"filesize %llu",fileszie);
            }
            
            cellText = [[options objectAtIndex:indexPath.row] stringByAppendingFormat:@"   Size: %llu",fileszie];
        }
    }

    if (indexPath.row == [options count]-1 && ![maxFilename isEqualToString:@""]) {
        
        //last row, Max file found, alert
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Max File" message:[NSString stringWithFormat:@"%@ - %llu",maxFilename,maxFileSize] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    cell.textLabel.text = cellText;

    return cell;
    
    
  /*  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    static NSString *cellIdentifier = @"FileCell";
    
    // Similar to UITableViewCell, but
    FileBrowsingCell *cell = (FileBrowsingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FileBrowsingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BOOL isDirectory;
    NSString *path = [appDel.currentPath stringByAppendingPathComponent:[options objectAtIndex:indexPath.row]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        
        if (isDirectory) {
            //dir
            cell.img.image = [UIImage imageNamed:@"dir.png"];
        }
    }
    
    cell.name.text = [options objectAtIndex:indexPath.row];
    
    //cell.name.text =
    // Just want to test, so I hardcode the data
    //cell.name.text = @"Testing";
   
    return cell;*/
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        

        if(topView)
        {
            if (indexPath.row == 0) {
                //mainbundle
                appDel.currentPath = [[NSBundle mainBundle] resourcePath];

            }
            else{
                //local dir
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                appDel.currentPath = [paths objectAtIndex:0];

            }
        }
        else
        {
         //inside dir
            
            appDel.currentPath = [appDel.currentPath stringByAppendingPathComponent:[options objectAtIndex:indexPath.row]];
        
        }
       
        //NSLog(@"currentPath --- %@",appDel.currentPath);
        
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
        vc.options = [self getContentAtFilePath:appDel.currentPath];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(unsigned long long)getFileSizeAtPath:(NSString *)filepath
{

    NSError *error = nil;

    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:&error];

    return [dict fileSize];
}

-(NSArray *)getContentAtFilePath:(NSString *)filePath
{

    NSError *error = nil;

    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];

    //sort the file name
    
    NSArray *sortedContents = [contents sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

   
    
    if (error) {
        NSLog(@"Erro %@",[error debugDescription]);
    }
              
    return sortedContents;
}

- (IBAction)popToTopView:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonDidPressed:(id)sender {

}

-(void)viewDidAppear:(BOOL)animated
{

    //AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   // appDel.currentPath = [appDel.currentPath stringByDeletingLastPathComponent];
   // NSLog(@"currentPath --- %@",appDel.currentPath);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
