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

#import "NwPdfController.h"
#import "NwUtil.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"
#import "eMobcViewController.h"


@implementation NwPdfController

//Datos parseados del fichero pdf.xml
@synthesize data;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

@synthesize webView;
@synthesize webViewLandscape;



/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];
	
	if (data != nil) {
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"PDF_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		loadContent = FALSE;
		
	
		if (data.local) {
		
		}else{
			[self embedPdf:data.pdfUrl frame:self.view.frame];	
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
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
						
			myLabel.textColor =  [UIColor colorWithRed:100 green:20 blue:10 alpha:1];
			
			//myLabel.textColor = [UIColor whiteColor];
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
	[background release];
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
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
* Visualiza el pdf en el contenedor web.
* 
* @param url La url del pdf
* @param frame
*/
- (void)embedPdf:(NSString*)url frame:(CGRect)frame {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
	
		if (data.local) {
		
		}else{
			[self embedPdf:data.pdfUrl frame:self.view.frame];	
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