//
//  CentralScanViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.

//  Modified by: Leonid Yerukhimov
//  Software Design Engineer
//

#import "PeripheralsViewController.h"
#import "myTableViewCell.h"
#import "BTServer.h"
#import "PeriperalInfo.h"
#import "ProgressHUD.h"
#import "ServicesViewController.h"

//======= reconsider this later: http://www.markbetz.net/2010/09/30/ios-diary-showing-an-activity-spinner-over-a-uitableview/
//--------------------------

@interface PeripheralsViewController ()<UITableViewDataSource,
                                          UITableViewDelegate,
                                             BTServerDelegate>

@property (strong,nonatomic)BTServer *defaultBTServer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtInfo;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PeripheralsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


//=========================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultBTServer = [BTServer defaultBTServer];
    //self.defaultBTServer.delegate = (id)self;
    // [self.defaultBTServer startScan];
    // [ProgressHUD dismiss];
    
    // self.txtInfo.text = @"scanning ...";
    
    NSLog(@"PVC didLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"PVC willAppear");
    
    self.txtInfo.text = @"Scanning ...";
    self.defaultBTServer.delegate = (id)self;
    [self.defaultBTServer startScan];
    [self.myTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"PVC viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"PVC viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"PVC viewDidlDisappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PVC didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

-(void) willRotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
                                duration: (NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"Landscape left");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Landscape right");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"Portrait");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Upside down");
    }
}


// ---------------------------------------------------------------------

#pragma mark -- btserver delegate
-(void)didStopScan
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.txtInfo.text = @" Scan was autostopped";
    });
}

-(void) pvcTableViewReloadTimer:(NSTimer *)timer
{
    NSLog(@"pvcTableViewData updated!");
    [self.myTableView reloadData];
}

-(void)didFoundPeripheral
{
    dispatch_async
    (
     dispatch_get_main_queue(), ^
     {
         [self performSelector:  @selector(pvcTableViewReloadTimer:)
                    withObject: nil
                    afterDelay: 0.01
          ];
     }
     );
}

-(void)didDisconnect
{
    // [ProgressHUD show:@"disconnect from peripheral"];
}




#pragma mark -- table delegate

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
//    unsigned long n = [self.defaultBTServer.discoveredPeripherals count];
//    return n;
    
    unsigned long retVal = 0;
    
    if ([self.defaultBTServer getDiscoveryState] == KSUCCESS)
    {
        unsigned long n = [self.defaultBTServer.discoveredPeripherals count];
        NSLog(@"PVC Nomber of Discovered Peripherals: %ld", n);
        // done = true;
        retVal = n;
    }
    else
    {
        NSLog(@"PVC Number of Goust Peripherals");
        retVal = 0;
    }
    
    return retVal;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"PeripheralCell";
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[myTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    PeriperalInfo *pi = self.defaultBTServer.discoveredPeripherals[indexPath.row];
    // ========================================================================================
    // https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CBCentralManagerDelegate_Protocol/#//apple_ref/doc/constant_group/Advertisement_Data_Retrieval_Keys
    // http://stackoverflow.com/questions/6948178/how-to-combine-two-strings-in-objective-c-for-an-iphone-app
    NSString *combined = [NSString stringWithFormat:@"%@: %@", pi.name, pi.manufactureData];
    // LY on 11/11/15
    // ----------------------------------------------------------------------------------------
    
    cell.topName.text = combined;  // pi.name
    cell.uuid.text = pi.uuid;
    cell.name.text = pi.localName;
    cell.service.text = pi.serviceUUIDS;
    cell.RSSI.text = [pi.RSSI stringValue];
    cell.RSSI.textColor = [UIColor blackColor];
    int rssi = [pi.RSSI intValue];
    
    // NSLog(@"ManufactureData: %@", pi.manufactureData);
    
    if(rssi>-60)
    {
        cell.RSSI.textColor = [UIColor redColor];
    }
    else if(rssi > -70)
    {
        cell.RSSI.textColor = [UIColor orangeColor];
    }
    else if(rssi > -80)
    {
        cell.RSSI.textColor = [UIColor blueColor];
    }
    else if(rssi > -90)
    {
        cell.RSSI.textColor = [UIColor blackColor];
    }
    
    NSLog( @"PVC tableView Cell was populated");
    
    return cell;
}

// if the peripheral power was lost
-(void) connectionTimeout_Timer:(NSTimer *)timer
{
    NSLog(@"PVC Connection failed after 10 sec !");
    // [ProgressHUD showError:@"Failed Connection"];
    
    [self.activityIndicatorView stopAnimating];
    
    self.txtInfo.text = @"Failed Connection.";
}

-       (void)tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self.defaultBTServer stopScan: YES];
    
    self.txtInfo.text = @"Connecting ...";
    
    NSTimer* myTimer =
    [
       NSTimer scheduledTimerWithTimeInterval: 10.0
                                       target: self
                                     selector: @selector(connectionTimeout_Timer:)
                                     userInfo: nil
                                      repeats: NO
    ];
    
    NSLog(@"PVC: Customer chose to Connect with %@ ...", self.defaultBTServer.discoveredPeripherals[indexPath.row]);
    
    [self.activityIndicatorView startAnimating];
    
    [
    self.defaultBTServer connect: self.defaultBTServer.discoveredPeripherals[indexPath.row]
                    withFinishCB: ^(CBPeripheral *peripheral,
                                            BOOL status,
                                         NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (status)
            {
                // [ProgressHUD dismiss];
                [myTimer invalidate]; // stop 10 sec connection timer

                // [ProgressHUD showSuccess:@"Connected !"];
                [self.activityIndicatorView stopAnimating];
                [self performSegueWithIdentifier:@"getService" sender:self];
////                dispatch_async(dispatch_get_main_queue(), ^
////                {
//                    [self performSelector:  @selector(hudTimeout_Timer:)
//                               withObject: nil
//                               afterDelay: 0.5
//                    ];
////                });
            }
            else // if it was smth wrong while connecting
            {
               //  [ProgressHUD showError:@"connected failed!"];
            }
        });
    }
    ];
    
    NSLog( @"PVC tableView Cell was selected");
}

- (IBAction)reFresh:(id)sender
{
    [[UIApplication sharedApplication] sendAction: @selector(resignFirstResponder)
                                               to: nil
                                             from: nil
                                         forEvent: nil];

    [self.defaultBTServer stopScan: TRUE];
    
    self.txtInfo.text = @"Scanning ...";
    self.defaultBTServer.delegate = (id)self;
    [self.defaultBTServer startScan];
    [self.myTableView reloadData];

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self.defaultBTServer stopScan: TRUE];
    
//    self.txtInfo.text = @"scanning ...";
//    self.defaultBTServer.delegate = (id)self;
//    [self.defaultBTServer startScan];
//    [self.myTableView reloadData];
    
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to: nil
                                                                                  from:nil
                                                                                  forEvent:nil];
    NSLog( @"PVC tableView will begin dragging");
}

@end
