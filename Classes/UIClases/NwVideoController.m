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

#import "NwVideoController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppFormatsStyles.h"
#import "AppStyles.h"
#import "eMobcViewController.h"


@implementation NwVideoController

@synthesize data;
@synthesize webView;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;


/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	loadContent = FALSE;
	
	if (data != nil) {
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		CGRect webFrame;
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				//webFrame = CGRectMake(0,0, 1024, 622);	
				webFrame = CGRectMake(0,0, 1024, 768);
			}else{
				//webFrame = CGRectMake(0,0, 768, 878);
				webFrame = CGRectMake(0,0, 768, 1024);
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				//webFrame = CGRectMake(0,0, 480, 174);
				webFrame = CGRectMake(0,0, 480, 320);
			}else{
				//webFrame = CGRectMake(0,0, 320, 334);
				webFrame = CGRectMake(0,0, 320, 480);
			}				
		}
		
		webView = [[UIWebView alloc] initWithFrame:webFrame];
				
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"VIDEO_ACTIVITY"];
		
		// We have differents ways to show a video if it is local or not
		if (data.local) {
			//Local
			//To play local video we use this library <MediaPlayer/MediaPlayer.h>
			NSURL* videoURL = [NSURL URLWithString:data.videoUrl];
			MPMoviePlayerController *player = [[MPMoviePlayerController alloc] 
											   initWithContentURL:videoURL];
			
			[[NSNotificationCenter defaultCenter] 
			 addObserver:self
			 selector:@selector(movieFinishedCallback:)                                                 
			 name:MPMoviePlayerPlaybackDidFinishNotification
			 object:player];
			
			//---play movie---
			[player play];			
		}else{
			//Remote
			[self embedVideo:data.videoUrl frame:self.view.frame];	
		}			
	}
}

/**
 * Show a notification if play video is over
 *
 * @param aNotification
 */
- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];    
    [player autorelease];    
}


/**
 * Load video with HTML format into webView
 *
 * @param url video direccion
 * @param frame
 */
- (void)embedVideo:(NSString*)url frame:(CGRect)frame {
	NSString* embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
	NSLog(@"HTML: %@", html);
    [[webView.subviews objectAtIndex:0] setScrollEnabled:NO];
    webView.delegate = self;
	[webView loadHTMLString:html baseURL:nil];
	//[webView loadHTMLString:@"<html><body>Hello World!</body></html>" baseURL:nil];
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
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 1024, 30)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 768, 50)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 480, 30)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 30)];
				}				
			}
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			myLabel.textColor = [UIColor blackColor];
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



#pragma mark -
#pragma mark WebView delegate

/**
 * Sent after a web view finishes loading content.
 *
 * @param _webView The web view has finished loading
 *
 * @see goBack
 */
-(void)webViewDidFinishLoad:(UIWebView *)_webView {
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
   
	if(![eMobcViewController isIPad]){	
		[mainController goBack];	
	}
}

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    return button;
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
	
		if (data.local) {
			//Local
			//To play local video we use this library <MediaPlayer/MediaPlayer.h>
			NSURL* videoURL = [NSURL URLWithString:data.videoUrl];
			MPMoviePlayerController *player = [[MPMoviePlayerController alloc] 
											   initWithContentURL:videoURL];
		
			[[NSNotificationCenter defaultCenter] 
			 addObserver:self
			 selector:@selector(movieFinishedCallback:)                                                 
			 name:MPMoviePlayerPlaybackDidFinishNotification
			 object:player];
			
			//---play movie---
			[player play];			
		}else{
			//Remote
			[self embedVideo:data.videoUrl frame:self.view.frame];	
		}			
	}
}


- (void)dealloc {
	[webView release];

    [super dealloc];
}

@end