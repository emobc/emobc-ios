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

#import "NwListMultiLineCell.h"
#import "eMobcViewController.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"
#import "NwUtil.h"

@implementation NwListMultiLineCell

@synthesize listImageView;
@synthesize listNextImageView;
@synthesize listLabel;
@synthesize descrLabel;
@synthesize contentListImageView;
@synthesize contentListNextImage;
@synthesize varStyles;
@synthesize varFormats;
@synthesize theStyle;
@synthesize theFormat;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		listImageView = [[UIImageView alloc] init];
		listNextImageView = [[UIImageView alloc] init];
		
		theStyle = [[NwUtil instance] readStyles];
		theFormat =[[NwUtil instance] readFormats];

		varStyles = [theStyle.stylesMap objectForKey:@"LIST_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *listNextImagePath = [[NSBundle mainBundle] pathForResource:@"images/" ofType:nil inDirectory:k];
		
		listNextImageView.image = [UIImage imageWithContentsOfFile:listNextImagePath];
	
				
		UIView* bgColorView = [[UIView alloc] init];
		[bgColorView setBackgroundColor:[UIColor grayColor]];
		self.selectedBackgroundView = bgColorView;
		
		[self.contentView addSubview:listImageView];
		[self.contentView addSubview:listLabel];
		[self.contentView addSubview:listNextImageView];
		[self.contentView addSubview:descrLabel];
		
		[listImageView release];
		[listLabel release];
		[listNextImageView release];
		[descrLabel release];
    }
    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) layoutSubviews {
	[super layoutSubviews];
	
	if([eMobcViewController isIPad]){
		CGRect contentRect = self.contentView.bounds;
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
		NSString *type = [varStyles.mapFormatComponents objectForKey:@"selection_list"];
		varFormats = [theFormat.formatsMap objectForKey:type];
		int varSize = [varFormats.textSize intValue];
		UIFont* font = [UIFont fontWithName:varFormats.typeFace size:varSize + 12];
		
		
		contentListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+10, 0, 140, 108)];
		
		if(listImageView.image.size.width > 140 || listImageView.image.size.height > 108){
			frame = CGRectMake(0, 0, 140, 108);
		}else{
			frame = CGRectMake((140 - listImageView.image.size.width)/2, (108 - listImageView.image.size.height)/2, listImageView.image.size.width, listImageView.image.size.height);
		}
		listImageView.frame = frame;
		
		listImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.contentView addSubview:contentListImageView];
		[contentListImageView addSubview:listImageView];
	

		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(boundsX+160, 10, 800, 30);
		}else{
			frame = CGRectMake(boundsX+160, 10, 440, 30);
		}

		listLabel.frame = frame;
		
				
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			contentListNextImage = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+994, 0, 40, 108)];
		}else{
			contentListNextImage = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+723, 0, 40, 108)];
		}
		
		if(listImageView.image.size.width > 40 || listImageView.image.size.height > 108){
			frame = CGRectMake(0, 0, 40, 108);
		}else{
			frame = CGRectMake((40 - listImageView.image.size.width)/2, (108 - listImageView.image.size.height)/2, listImageView.image.size.width, listImageView.image.size.height);
		}
		
       	listNextImageView.frame = frame;
		
		listNextImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.contentView addSubview:contentListNextImage];
		[contentListNextImage addSubview:listNextImageView];
		
		if (descrLabel.text != nil) {
			UIFont* fontDescr = [UIFont fontWithName:varFormats.typeFace size:20];
			CGSize constraintSize = CGSizeMake(150.0f, MAXFLOAT);
			CGSize labelSize = [descrLabel.text sizeWithFont:fontDescr 
										   constrainedToSize:constraintSize
											   lineBreakMode:UILineBreakModeWordWrap];
					
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				frame = CGRectMake(boundsX+160, 20, 800, 50);
			}else{
				frame = CGRectMake(boundsX+160, 20, 440, 50);
			}
			
			descrLabel.frame = frame;		
		}
	}else {
		CGRect contentRect = self.contentView.bounds;
        CGFloat boundsX = contentRect.origin.x;
        CGRect frame;
		
		contentListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+5, 0, 80, 58)];
        		
		if(listImageView.image.size.width > 80 || listImageView.image.size.height > 58){
			frame = CGRectMake(0, 0, 80, 58);
		}else{
			frame = CGRectMake((80 - listImageView.image.size.width)/2, (58 - listImageView.image.size.height)/2, listImageView.image.size.width, listImageView.image.size.height);
		}
		
       	listImageView.frame = frame;
				
		listImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.contentView addSubview:contentListImageView];
		[contentListImageView addSubview:listImageView];
		
	    
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(boundsX+90, 0, 360, 20);
		}else{
			frame = CGRectMake(boundsX+90, 0, 210, 20);
		}

        listLabel.frame = frame;
		
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			contentListNextImage = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+445, 0, 30, 58)];
		}else{
			contentListNextImage = [[UIImageView alloc] initWithFrame:CGRectMake(boundsX+290, 0, 25, 58)];
		}
		
		if(listImageView.image.size.width > 25 || listImageView.image.size.height > 58){
			frame = CGRectMake(0, 0, 25, 58);
		}else{
			frame = CGRectMake((25 - listImageView.image.size.width)/2, (58 - listImageView.image.size.height)/2, listImageView.image.size.width, listImageView.image.size.height);
		}
		
       	listNextImageView.frame = frame;
		
		listNextImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.contentView addSubview:contentListNextImage];
		[contentListNextImage addSubview:listNextImageView];
		
				
        if (descrLabel.text != nil) {
            UIFont* fontDescr = [UIFont fontWithName:@"Ubuntu-Medium" size:10];
            CGSize constraintSize = CGSizeMake(150.0f, MAXFLOAT);
            CGSize labelSize = [descrLabel.text sizeWithFont:fontDescr 
                                           constrainedToSize:constraintSize
                                               lineBreakMode:UILineBreakModeWordWrap];
            
			
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				frame = CGRectMake(boundsX+90, 10, 360, labelSize.height + 15);
			}else{
				frame = CGRectMake(boundsX+90, 10, 210, labelSize.height + 15);
			}
            
            descrLabel.frame = frame;	
        }
    }
}





-(void)loadThemesComponents {
	NSString *type = [varStyles.mapFormatComponents objectForKey:@"selection_list"];
	
	varFormats = [theFormat.formatsMap objectForKey:type];
	
	listLabel = [[UILabel alloc] init];
	listLabel.textAlignment = UITextAlignmentLeft;
	
	int varSize = [varFormats.textSize intValue];
	UIFont * font = [UIFont  fontWithName:varFormats.typeFace size:varSize];
	listLabel.font = font;		
	
	//Hay que convertirlo a hexadecimal.
	//	varFormats.textColor
	listLabel.textColor = [UIColor blackColor];
	[listLabel setBackgroundColor:[UIColor clearColor]];
	
	
	NSString *typeDesc = [varStyles.mapFormatComponents objectForKey:@"description"];
	varFormats = [theFormat.formatsMap objectForKey:typeDesc];
	
	int varSizeDesc = [varFormats.textSize intValue];
	UIFont* fontDescr = [UIFont fontWithName:varFormats.typeFace size:varSizeDesc];
	descrLabel = [[UILabel alloc] init];
	descrLabel.textAlignment = UITextAlignmentLeft;
	descrLabel.lineBreakMode = UILineBreakModeWordWrap;
	descrLabel.numberOfLines = 0;
	descrLabel.font = fontDescr;		
	//Hay que convertirlo a hexadecimal.
	//	varFormats.textColor
	descrLabel.textColor =  [UIColor blackColor];
	[descrLabel setBackgroundColor:[UIColor clearColor]];
}


/**
 Carga los temas
 */
-(void) loadThemes {
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
	}
	[self loadThemesComponents];
}


-(void)dealloc {
	[listImageView release];
	[listLabel release];
	[descrLabel release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark iPhone-iPad Support

+(BOOL)isIPad {
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            return YES;
        }
    }
    return NO;
}

+(NSString *) addIPadSuffixWhenOnIPad:(NSString *)resourceName {
    if([eMobcViewController isIPad]) {
        return [resourceName stringByAppendingString:@"-iPad"];
    }else {
        return resourceName;
    }
}


@end