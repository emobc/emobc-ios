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

#import "NwWebController.h"
#import "NwUtil.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"
#import "eMobcViewController.h"


@implementation NwWebController

//Datos parseados del fichero web.xml
@synthesize data;
@synthesize varStyles;
@synthesize varFormats;
@synthesize webView;
@synthesize webViewLandscape;
@synthesize background;

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];	
	
	if (data != nil) {
		loadContent = FALSE;
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"WEB_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		if (data.local) { 
			//if is local tag, load data html file
			[self embedHTML:data.webUrl frame:self.view.frame];
			
		}else{
			//if isn't local, load web site
			[self embedWeb:data.webUrl frame:self.view.frame];	
		}				
	}
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

/**
 * Load URL into webview
 * 
 * @param url Web site URL
 * @param frame
 */
- (void)embedWeb:(NSString*)url frame:(CGRect)frame {
    //Limpia la url de acentos y la codifica al UTF-8.
	url = [url stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
  	NSURL *urlAddress = [NSURL URLWithString:url];	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAddress];	
	    
    webView.scalesPageToFit = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[webView loadRequest:requestObj];
	webView.delegate = self;
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		webViewLandscape.scalesPageToFit = YES;
		webViewLandscape.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[webViewLandscape loadRequest:requestObj];
		webViewLandscape.delegate = self;
	}
}

/**
 * Load local HTLM into webView
 * 
 * @param html file name
 * @param frame
 */
- (void)embedHTML:(NSString*)url frame:(CGRect)frame {
    //Limpia la url de acentos y la codifica al UTF-8.
	
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] 
																			  pathForResource:@"test" ofType:@"html"]isDirectory:NO]]];
    webView.delegate = self;
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		[webViewLandscape loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] 
																				  pathForResource:@"test" ofType:@"html"]isDirectory:NO]]];
		webViewLandscape.delegate = self;
	}
	
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
	
		if (data.local) { 
			//if is local tag, load data html file
			[self embedHTML:data.webUrl frame:self.view.frame];
			
		}else{
			//if isn't local, load web site
			[self embedWeb:data.webUrl frame:self.view.frame];	
		}
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
 * Sent if a web view failed to load content.
 *
 * @param webView The web view that failed to load content
 * @param error The error that occurred during loading
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"didFail: %@ stillLoading:%@ error code:%i", [[webView request]URL], (webView.loading?@"NO":@"YES"), [error code]);
    if ([error code] != -999) {
        // Handle your other errors here
    }
}

/**
 * Sent after a web view starts loading content.
 * 
 * @param webView The web view that has begun loading content
 *
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self startSpinner];
}

/**
 * Sent after a web view finishes loading content.
 *
 * @param webVew The web view has finished loading
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self removeSpinner];
}

@end