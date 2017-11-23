//
//  GAudioViewController.h
//  RadicalDating
//
//  Created by Aseem 2 on 21/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "constants.h"
#import "SampleQueueId.h"
#import "STKAudioPlayer.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import <AVFoundation/AVFoundation.h>

@interface GAudioViewController : UIViewController<STKAudioPlayerDelegate>

#pragma mark - Public Method

-(void)sendAudio:(NSString*)url;


#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;


@property (weak, nonatomic) IBOutlet UIButton *btnSong;
@property (weak, nonatomic) IBOutlet UIImageView *imgAudio;

@property (weak, nonatomic) IBOutlet UISlider *sliderAudio;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

#pragma mark - Action

- (IBAction)actionBtnPrevious:(id)sender;
- (IBAction)actionBtnHome:(id)sender;
- (IBAction)actionBtnPlay:(id)sender;
- (IBAction)actionBtnFb:(id)sender;

- (IBAction)dragAudioSlider:(id)sender;
- (IBAction)actionSlider:(id)sender;

@end
