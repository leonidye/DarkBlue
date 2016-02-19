//
//  WriteValueViewController.m
//  DarkBlue
//
//  Created by Leonid on 12/15/15
//  Copyright (c) 2015. All rights reserved.
//

#import "WriteValueViewController.h"
#import "BTServer.h"
#import "ProgressHUD.h"
#import "bleServices.h"
#import "BLEUtility.h"

@interface WriteValueViewController ()<BTServerDelegate>

@property (strong,nonatomic) BTServer *defaultBTServer;

@property (weak, nonatomic) IBOutlet UITextField *txtWrite;

@property (weak, nonatomic) IBOutlet UIButton *btn_0;
@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property (weak, nonatomic) IBOutlet UIButton *btn_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_6;
@property (weak, nonatomic) IBOutlet UIButton *btn_7;
@property (weak, nonatomic) IBOutlet UIButton *btn_8;
@property (weak, nonatomic) IBOutlet UIButton *btn_9;
@property (weak, nonatomic) IBOutlet UIButton *btn_A;
@property (weak, nonatomic) IBOutlet UIButton *btn_B;
@property (weak, nonatomic) IBOutlet UIButton *btn_C;
@property (weak, nonatomic) IBOutlet UIButton *btn_D;
@property (weak, nonatomic) IBOutlet UIButton *btn_E;
@property (weak, nonatomic) IBOutlet UIButton *btn_F;

@property (weak, nonatomic) IBOutlet UIButton *btn_Erase;
@property (weak, nonatomic) IBOutlet UIButton *btn_Done;

@end

@implementation WriteValueViewController
{
    BOOL readState;
    BOOL writeState;
    bool notifState;
}

// NSInteger numOfEntries;

- (IBAction)btn_0_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_0.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_1_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_1.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_2_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_2.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_3_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_3.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_4_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_4.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_5_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_5.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_6_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_6.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_7_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_7.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_8_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_8.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_9_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_9.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_A_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_A.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_B_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_B.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_C_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_C.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_D_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_D.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_E_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_E.titleLabel.text];
//    numOfEntries++;
}
- (IBAction)btn_F_Click: (id)sender
{
    self.txtWrite.text = [self.txtWrite.text stringByAppendingString: self.btn_F.titleLabel.text];
//    numOfEntries++;
}

- (IBAction)btn_Erase: (id)sender
{
    if ([self.txtWrite.text length] > 0)
    {
        self.txtWrite.text = [self.txtWrite.text substringWithRange:NSMakeRange(0,[self.txtWrite.text length] - 1)];
//        numOfEntries--;
    }
    else
    {
        NSLog(@"WVVC String is empty");
    }
}

- (NSData *) dataWithHexString:(NSString *)hexstring
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    
    for (idx = 0; idx + 2 <= hexstring.length; idx += 2)
    {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange: range];
        NSScanner* scanner = [NSScanner scannerWithString: hexStr];
        
        unsigned int intValue;
        [scanner scanHexInt: &intValue];
        [data   appendBytes: &intValue
                     length: 1];
    }
    return data;
}

- (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = (int)string.length;
    
    while (i < length-1)
    {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
        {
            continue;
        }
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        
        [data appendBytes: &whole_byte
                   length: 1];
    }
    return data;
}

- (IBAction)btn_Done: (id)sender
{
    NSData *oldData = self.defaultBTServer.selectCharacteristic.value;
    
    unsigned long oldDataLength = oldData.length;
    
    NSData * dataToWrite = [self dataWithHexString: self.txtWrite.text];
    //NSData * dataToWrite = [self dataFromHexString: self.txtWrite.text];
    unsigned long dataLengthToWrite = (unsigned long)dataToWrite.length;
    
    NSLog( @"WVC Characters to write: %@ of length %lu", dataToWrite, dataLengthToWrite);
    
    if ([self.txtWrite.text isEqual: @""]) // no bytes were entered
    {
        NSLog(@"going back to RVVC because of nothing was entered ...");
        
        [ProgressHUD showError: @"Please Enter a hex value"];
    }
    else
    {
        NSString *sUUID = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
        NSString *cUUID = [self.defaultBTServer.selectCharacteristic.UUID UUIDString];
        
        if ( oldDataLength == 0)  // practically, the characteristic is not readable
        {
            if (dataLengthToWrite == 0)
            {
                NSLog(@"Too few characters!");
                [ProgressHUD showError: @"Too few Characters !"];
            }
            else
            {
                [BLEUtility writeCharacteristic: self.defaultBTServer.selectPeripheral
                                          sUUID: sUUID
                                          cUUID: cUUID
                                           data: dataToWrite
                ];
            }
            
            NSLog(@"WVVC is writing New String value: %@ to Char UUID: %@", dataToWrite, cUUID);
        }
        else
        {
            if ( dataLengthToWrite == oldDataLength )
            {
                [BLEUtility writeCharacteristic: self.defaultBTServer.selectPeripheral
                                          sUUID: sUUID
                                          cUUID: cUUID
                                           data: dataToWrite
                ];
        
                NSLog(@"WVVC is writing New String value: %@ to Char UUID: %@", dataToWrite, cUUID);
            }
            else if ( dataLengthToWrite > oldDataLength )
            {
                NSLog(@"Too many characters!");
                [ProgressHUD showError: @"Too many Characters !"];
            }
            else if ( dataLengthToWrite < oldDataLength )
            {
                NSLog(@"Too few characters!");
                [ProgressHUD showError: @"Too few Characters !"];
            }
        }
    }
}

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

// callbacks from viewController's class
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    
    NSLog(@"WVVC didLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"WVVC willAppear");
//    numOfEntries = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"WVVC viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"WVVC viewWillDisappear");

}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"WVVC viewDidlDisappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"WVVC didReceiveMemoryWarning");
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
//-------------------------------------------------------------------------

-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// a callback from BTServer signalling the 'write' operation was complete succesfully
-(void)didWritevalue
{
    NSLog(@"WVVC didWrite value. Going back to RVVC ...");
    
    [ProgressHUD dismiss];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)errorWritingValue
{
    NSLog(@"WVVC didNotWriteValue");
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [ProgressHUD showError: @"Could Not Write Value !"];
    });
}

@end
