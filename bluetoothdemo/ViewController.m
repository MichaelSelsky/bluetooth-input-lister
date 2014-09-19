//
//  ViewController.m
//  bluetoothdemo
//
//  Created by Michael Selsky on 9/19/14.
//  Copyright (c) 2014 Michael Selsky. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;
@import MediaPlayer;

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareAudioSession];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frameForMPVV = CGRectMake(50.0, 50.0, 100.0, 100.0);
    
    NSArray *availInputs = [[AVAudioSession sharedInstance] availableInputs];
    int count = [availInputs count];
    NSMutableArray *arr = [NSMutableArray new];
    for (int k = 0; k < count; k++) {
        AVAudioSessionPortDescription *portDesc = [availInputs objectAtIndex:k];
        NSLog(@"input%i port type %@", k+1, portDesc.portType);
        NSLog(@"input%i port name %@", k+1, portDesc.portName);
        [arr addObject:portDesc.portName];
    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:frameForMPVV];
    textView.text = [NSString stringWithFormat:@"%@", arr];
    [self.view addSubview:textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myInterruptionSelector:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myRouteChangeSelector:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (void)myRouteChangeSelector:(NSNotification*)notification {
    AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
    NSArray *inputsForRoute = currentRoute.inputs;
    NSArray *outputsForRoute = currentRoute.outputs;
    AVAudioSessionPortDescription *outPortDesc = [outputsForRoute objectAtIndex:0];
    NSLog(@"current outport type %@", outPortDesc.portType);
    AVAudioSessionPortDescription *inPortDesc = [inputsForRoute objectAtIndex:0];
    NSLog(@"current inPort type %@", inPortDesc.portType);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prepareAudioSession {
    BOOL success = [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    if (!success) {
        NSLog(@"deactivationError");
    }
    
    // set audio session category AVAudioSessionCategoryPlayAndRecord options AVAudioSessionCategoryOptionAllowBluetooth
    success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    if (!success) {
        NSLog(@"setCategoryError");
    }
    
    // activate audio session
    success = [[AVAudioSession sharedInstance] setActive:YES error: nil];
    if (!success) {
        NSLog(@"activationError");
    }
    
    return success;
}





@end
