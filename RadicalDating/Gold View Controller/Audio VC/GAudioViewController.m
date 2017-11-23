//
//  GAudioViewController.m
//  RadicalDating
//
//  Created by Aseem 2 on 21/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "GAudioViewController.h"
@import MediaPlayer;

@interface GAudioViewController (){

    NSURL *urlAudio;
    
    NSTimer* timer;
    UIView* meter;
    UILabel *statusLabel;
    
    STKAudioPlayer* audioPlayer;
}

@end

@implementation GAudioViewController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self setUI];

//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    
//    NSError *setCategoryError = nil;
//    if (![session setCategory:AVAudioSessionCategoryPlayback
//                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
//                        error:&setCategoryError]) {
//        // handle error
//    }
    
    NSError *setCategoryError;
    NSError *setActiveError;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    [[AVAudioSession sharedInstance] setActive:YES error:&setActiveError];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(nextAudio)];
    
    commandCenter.togglePlayPauseCommand.enabled = YES;
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(nextAudio)];
    
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(manageAudio)];
    
    commandCenter.playCommand.enabled = YES;
    [commandCenter.playCommand addTarget:self action:@selector(manageAudio)];
    
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextAudio)];
    
    audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    audioPlayer.meteringEnabled = YES;
    audioPlayer.volume = 1;
    
    UIImage *artworkImage = [UIImage imageNamed:@"audio"];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: artworkImage];
      
    NSDictionary *info = @{ MPMediaItemPropertyArtist: @"Radical Dating",
                            MPMediaItemPropertyAlbumTitle: @"Hypnosis Session",
                            MPMediaItemPropertyTitle: @"Unshakable Confidence with Woman",
                            MPMediaItemPropertyArtwork:albumArt};
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    
}

-(void)nextAudio{
    
   //NSLog(@"Next/Back");
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [timer invalidate];
    [audioPlayer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Basic setup
-(void)setUI{
   
    [_sliderAudio setValue:0.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioTapped)];
    [_imgAudio addGestureRecognizer:tap];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnPrevious.layer setBorderWidth:0.5f];
    [self.btnPrevious.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnPrevious.layer setCornerRadius:5.0f];
    
    meter = [[UIView alloc] initWithFrame:CGRectMake(0, 420, 0, 20)];
    meter.backgroundColor = [UIColor colorWithRed:186.0f/255 green:14.0f/255 blue:28.0f/255 alpha:0.9f];
    
//    [self.view addSubview:meter];
    
    [self setupTimer];
    [self updateControls];
}

-(void)audioTapped{
    
    [self manageAudio];
}


#pragma mark - Actions
- (IBAction)actionBtnPrevious:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionBtnPlay:(id)sender {
    
    [self manageAudio];
}

//- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
//    
//    if (event.type == UIEventTypeRemoteControl) {
//        
//        [self manageAudio];
//        
//        if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
//            
//            
//           //NSLog(@"dfhdhfdfdg");
//        }
//    }
//}

-(void)manageAudio{
    
    if (!audioPlayer)
    {
        return;
    }
    
    if (audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [audioPlayer resume];
        
        [_btnSong setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateNormal];
        
    }
    else if(audioPlayer.state == STKAudioPlayerStatePlaying || audioPlayer.state ==STKAudioPlayerStateBuffering)
    {
        [audioPlayer pause];
        
        [_btnSong setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
        
    }
    
    else{
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:urlAudio];
        [audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:urlAudio andCount:0]];
        
        [_btnSong setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
    
}


#pragma mark - drag audio slider
- (IBAction)dragAudioSlider:(id)sender {
    
    [self sliderChanged];
}

- (IBAction)actionSlider:(id)sender {
}

#pragma mark - Send Audio

-(void)sendAudio:(NSString *)url{
    
    urlAudio = [NSURL URLWithString:url];
}


#pragma mark - New

-(void) sliderChanged
{
    if (!audioPlayer)
    {
        return;
    }
    
    [audioPlayer seekToTime:_sliderAudio.value];
}

-(void) setupTimer
{
    timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void) tick
{
    
   
    if (!audioPlayer)
    {
        _sliderAudio.value = 0;
        _lblTimer.text = @"";
        statusLabel.text = @"";
        
        return;
    }
    
    if (audioPlayer.stopReason == STKAudioPlayerStopReasonEof) {
        
        [_btnSong setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    }

    if (audioPlayer.state == STKAudioPlayerStateBuffering) {
        
        [_lblTimer setText:@"Buffering..."];
        return;
    }
    
    
    if (audioPlayer.currentlyPlayingQueueItemId == nil)
    {
        _sliderAudio.value = 0;
        _sliderAudio.minimumValue = 0;
        _sliderAudio.maximumValue = 0;
        
        _lblTimer.text = @"";
        
        return;
    }
    
    if (audioPlayer.duration != 0)
    {
        _sliderAudio.minimumValue = 0;
        _sliderAudio.maximumValue = audioPlayer.duration;
        _sliderAudio.value = audioPlayer.progress;
        
        _lblTimer.text = [NSString stringWithFormat:@"%@/%@", [self formatTimeFromSeconds:audioPlayer.progress], [self formatTimeFromSeconds:audioPlayer.duration]];
    }
    else
    {
        _sliderAudio.value = 0;
        _sliderAudio.minimumValue = 0;
        _sliderAudio.maximumValue = 0;
        
        _lblTimer.text =  @"Streaming";
    }
    
    
    statusLabel.text = audioPlayer.state == STKAudioPlayerStateBuffering ? @"buffering" : @"";
    
    CGFloat newWidth = 320 * (([audioPlayer averagePowerInDecibelsForChannel:1] + 60) / 60);
    
    meter.frame = CGRectMake(0, 460, newWidth, 20);
}


-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
//    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}

-(void) updateControls
{
    if (audioPlayer == nil)
    {
        [_btnSong setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    }
    else if (audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [_btnSong setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    }
    else if (audioPlayer.state & STKAudioPlayerStatePlaying)
    {
        [_btnSong setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnSong setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    }
    
    [self tick];
}

-(void) setAudioPlayer:(STKAudioPlayer*)value
{
    if (audioPlayer)
    {
        audioPlayer.delegate = self;
    }
    
    audioPlayer = value;
    audioPlayer.delegate = self;
    
    [self updateControls];
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    
   //NSLog(@"Started: %@", [queueId.url description]);
    
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    [self updateControls];
    
    // This queues on the currently playing track to be buffered and played immediately after (gapless)
    
    if (false)
    {
        SampleQueueId* queueId = (SampleQueueId*)queueItemId;
        
       //NSLog(@"Requeuing: %@", [queueId.url description]);
        
        [self->audioPlayer queueDataSource:[STKAudioPlayer dataSourceFromURL:queueId.url] withQueueItemId:[[SampleQueueId alloc] initWithUrl:queueId.url andCount:queueId.count + 1]];
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self updateControls];
    
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    
   //NSLog(@"Finished: %@", [queueId.url description]);
}

-(void) audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
   //NSLog(@"%@", line);
}


@end
