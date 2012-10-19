/**
 *  Copyright 2012 Neurowork Consulting S.L.
 *
 *  This file is part of eMobc.
 *
 *  eMobcViewController.m
 *  eMobc IOS Framework
 *
 *  eMobc is free software: you can redistribute it and/or modify
 *  it under the terms of the Affero GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  eMobc is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Affero GNU General Public License
 *  along with eMobc.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "NwAudioController.h"
#import "NwUtil.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"
#import "eMobcViewController.h"


@implementation NwAudioController

//Datos parseados del fichero audio.xml
@synthesize data;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

@synthesize imgView;

@synthesize segundero;
@synthesize volumen;
@synthesize sTiempoAudio;

@synthesize playButton;
@synthesize pauseButton;
@synthesize stopButton;


-(NSString *) formatTime: (int) num {
	int secs = num % 60;
	int min = num / 60;
	
	if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
	
	return	[NSString stringWithFormat:@"%d:%02d", min, secs];
}


-(void) play{
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	
	tiempoAudio = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	// Set the maximum value of the UISlider
	sTiempoAudio.maximumValue = myMusic.duration;
	// Set the valueChanged target
	[sTiempoAudio addTarget:self action:@selector(sliderAudioChanged:) forControlEvents:UIControlEventValueChanged];
	
	// Play the audio
	[myMusic prepareToPlay];
	[myMusic play];
	playing = TRUE;
	pause = FALSE;
	stop = FALSE;
}

-(void) stop{
	
	if (stop == FALSE) {
		[myMusic stop];
		[timer invalidate];
		myMusic.currentTime = 0.0;
		segundero.text = [NSString stringWithFormat:@"%@ of %@", [self formatTime:myMusic.currentTime], [self formatTime:myMusic.duration]];
		stop = TRUE;
		pause = TRUE;
	}else if (stop == TRUE && pause == TRUE) {
		myMusic.currentTime = 0.0;
		segundero.text = [NSString stringWithFormat:@"%@ of %@", [self formatTime:myMusic.currentTime], [self formatTime:myMusic.duration]];
	} 
}

-(void) pause{
	
	if(pause == FALSE){
		[myMusic pause];
		[timer invalidate];
		playing = TRUE;
		pause = TRUE;
		stop = TRUE;
	}
}

-(void) cambiarVolumen{
	[myMusic setVolume:volumen.value];
}

-(void) loop{
	if (loop == FALSE) {
		[myMusic setNumberOfLoops:999999];
		loop = TRUE;
	}else {
		[myMusic setNumberOfLoops:0];
	}
	
	
}


//tiempo archivo audio.
-(void) updateMeters{
	[myMusic updateMeters];
	segundero.text = [NSString stringWithFormat:@"%@ of %@", [self formatTime:myMusic.currentTime], [self formatTime:myMusic.duration]];
}

-(void)updateSlider {
	// Update the slider about the music time
	sTiempoAudio.value = myMusic.currentTime;
	segundero.text = [NSString stringWithFormat:@"%@ of %@", [self formatTime:myMusic.currentTime], [self formatTime:myMusic.duration]];
}

-(void)sliderAudioChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
	[myMusic pause];
	[myMusic setCurrentTime:sTiempoAudio.value];
	[myMusic prepareToPlay];
	[myMusic play];
}

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];	
	
	if (data != nil) {
		loadContent = FALSE;
		
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"AUDIO_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		[self loadAudio];
	}
}


-(void) loadAudio{
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(362, 600, 300, 120)];
		}else{
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(234, 850 , 300, 120)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 180, 320, 90)];
		}else{
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 310, 300, 120)];
		}				
	}
	
	NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"images/multimedia/coverMultimedia.png"];
	
	imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
	
	imgView.image = [UIImage imageWithContentsOfFile:imagePath];
	
	[self.view addSubview:imgView];
	[imgView release];
	
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			segundero = [[UILabel alloc] initWithFrame:CGRectMake(437, 605, 150, 50)];
		}else{
			segundero = [[UILabel alloc] initWithFrame:CGRectMake(309, 855, 150, 50)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			segundero = [[UILabel alloc] initWithFrame:CGRectMake(90, 315, 140, 50)];
		}else{
			segundero = [[UILabel alloc] initWithFrame:CGRectMake(90, 315, 140, 50)];
		}				
	}
	
	segundero.backgroundColor = [UIColor clearColor];
	segundero.textColor = [UIColor whiteColor];
	segundero.textAlignment = UITextAlignmentCenter;
	
	[self.view addSubview:segundero];
	[segundero release];
	
	CGRect frame;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(910, 635.0, 190, 10.0);
		}else{
			frame = CGRectMake(620, 860.0, 190, 10.0);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(340, 180.0, 180, 10.0);
		}else{
			frame = CGRectMake(210, 190.0, 190, 10.0);
		}				
	}
	
	volumen = [[UISlider alloc] initWithFrame:frame];
	[volumen addTarget:self action:@selector(cambiarVolumen) forControlEvents:UIControlEventValueChanged];
	[volumen setBackgroundColor:[UIColor clearColor]];
	volumen.minimumValue = 0.0;
	volumen.maximumValue = 1.0;
	volumen.continuous = YES;
	volumen.value = 0.5;
	//Slider vertical
	CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    volumen.transform = trans;
	
	[self.view addSubview:volumen];
	[volumen release];
	
	CGRect frame1;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame1 = CGRectMake(367.0, 655.0, 290.0, 10.0);
		}else{
			frame1 = CGRectMake(239.0, 895.0, 290.0, 10.0);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame1 = CGRectMake(95.0, 200.0, 290.0, 10.0);
		}else{
			frame1 = CGRectMake(15.0, 360.0, 290.0, 10.0);
		}				
	}
		
	sTiempoAudio = [[UISlider alloc] initWithFrame:frame1];
	[sTiempoAudio addTarget:self action:@selector(updateSlider) forControlEvents:UIControlEventValueChanged];
	[sTiempoAudio setBackgroundColor:[UIColor clearColor]];
	
	[self.view addSubview:sTiempoAudio];
	[sTiempoAudio release];
	
	
	if(data.local){
		NSError *error;
		NSString *pathToMusicFile = [[NSBundle mainBundle] pathForResource:data.audioUrl ofType:@"mp3"];
		
		myMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToMusicFile] error:&error];
		if(!myMusic){
			NSLog(@"Error: %@", [error localizedDescription]);
		}
	}else{
		NSURL *urlAddress = [NSURL URLWithString:data.audioUrl];	
		
		NSData *data2 = [NSData dataWithContentsOfURL:urlAddress];
		myMusic = [[AVAudioPlayer alloc] initWithData:data2 error:nil];
	}
	
	
	myMusic.delegate = self;
	myMusic.numberOfLoops = -1;
	myMusic.volume = 1.0;
	[myMusic setNumberOfLoops:0];
	
	[self buttonMultimedia];
	
}

-(void) buttonMultimedia{
		
	//create the button
	playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			playButton.frame = CGRectMake(497, 675, 40, 40);	
		}else{
			playButton.frame = CGRectMake(368, 920, 40, 40);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			playButton.frame = CGRectMake(220, 230, 40, 40);	
		}else{
			playButton.frame = CGRectMake(143, 385, 40, 40);
		}				
	}
	
	//set the button's title
	//[playButton setTitle:@"play" forState:UIControlStateNormal];
	[playButton setImage:[UIImage imageNamed:@"images/multimedia/buttonPlay.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:playButton];

	
	/*
	 *Pause audio button
	 *
	 */
	//create the button
	pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			pauseButton.frame = CGRectMake(542, 675, 40, 40);	
		}else{
			pauseButton.frame = CGRectMake(423, 920, 40, 40);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			pauseButton.frame = CGRectMake(270, 230, 40, 40);	
		}else{
			pauseButton.frame = CGRectMake(180, 385, 40, 40);
		}				
	}
	
	//set the button's title
	//[pauseButton setTitle:@"pause" forState:UIControlStateNormal];
	[pauseButton setImage:[UIImage imageNamed:@"images/multimedia/buttonPause.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:pauseButton];
	
	
	/*
	 *Stop audio button
	 *
	 */
	//create the button
	stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			stopButton.frame = CGRectMake(447, 675, 40, 40);	
		}else{
			stopButton.frame = CGRectMake(313, 920, 40, 40);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			stopButton.frame = CGRectMake(170, 230, 40, 40);	
		}else{
			stopButton.frame = CGRectMake(100, 385, 40, 40);
		}				
	}
	
	//set the button's title
	//[stopButton setTitle:@"stop" forState:UIControlStateNormal];
	[stopButton setImage:[UIImage imageNamed:@"images/multimedia/buttonStop.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:stopButton];
}


/**
 * Load themes from xml into components
 */
-(void)loadThemesComponents {
	
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 320, 20)];
				}				
			}
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			myLabel.textColor = [UIColor whiteColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}
	}
}


/**
 * Load themes
 */
-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}				
		}
		
		NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:varStyles.backgroundFileName];
		
		imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}else{
		self.view.backgroundColor = [UIColor whiteColor];
	}
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
			//[varStyles.mapFormatComponents setObject:component forKey:format];
			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
}

-(void) backButtonPress:(id)sender {
	if (playing == TRUE) {
		playing = FALSE;
		pause == FALSE;
		
		if (myMusic != nil && stop == TRUE) {
			[myMusic release];
		}else if (myMusic != nil) {
			[myMusic stop];
			[timer invalidate];
			[tiempoAudio invalidate];
			[myMusic release];
		}
    }

	[super backButtonPress:sender];
}

-(void) homeButtonPress:(id)sender {
	if (playing == TRUE) {
		playing = FALSE;
		pause == FALSE;
		
		if (myMusic != nil && stop == TRUE) {
			[myMusic release];
		}else if (myMusic != nil) {
			[myMusic stop];
			[timer invalidate];
			[tiempoAudio invalidate];
			[myMusic release];
		}
    }

	[super homeButtonPress:sender];
}


/**
 * Show differents views depending on orientation
 *
 * @param object
 */
-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}


-(void) orientationChangedMethod{
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
		
		
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
	
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
	
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
		
		[self loadAudio];
	}
}


/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark - UIWebViewDelegate delegate methods

/**
 * Sent after a web view starts loading content.
 * 
 * @param webView The web view that has begun loading content
 *
 */
-(void)webViewDidStartLoad:(UIWebView *)webView {
	//[self startSpinner];
}

/**
 * Sent after a web view finishes loading content.
 *
 * @param webVew The web view has finished loading
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView {
	//[self removeSpinner];
}

@end