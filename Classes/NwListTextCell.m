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

#import "NwListTextCell.h"
#import "eMobcViewController.h"
#import "NwUtil.h"

@implementation NwListTextCell

@synthesize listLabel;
@synthesize varStyles;
@synthesize varFormats;
@synthesize theStyle;
@synthesize theFormat;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		listNextImageView = [[UIImageView alloc] init];

		theStyle = [[NwUtil instance] readStyles];
		theFormat =[[NwUtil instance] readFormats];
		
		varStyles = [theStyle.stylesMap objectForKey:@"IMAGE_LIST_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		listNextImageView.image = [UIImage imageNamed:@"images/icons/redarrow.png"];
		
		UIView* bgColorView = [[UIView alloc] init];
		[bgColorView setBackgroundColor:[UIColor grayColor]];
		self.selectedBackgroundView = bgColorView;
		[bgColorView release];	
		
		[self.contentView addSubview:listLabel];
		[self.contentView addSubview:listNextImageView];
    }
    return self;
}

-(void)loadThemesComponents {
	NSString *type = [varStyles.mapFormatComponents objectForKey:@"selection_list"];
	
	varFormats = [theFormat.formatsMap objectForKey:type];
	
	listLabel = [[UILabel alloc] init];
	listLabel.textAlignment = UITextAlignmentLeft;
	
	int varSize = 0;
	if([eMobcViewController isIPad]){
		varSize = [varFormats.textSize intValue] + 10;
	}else{
		varSize = [varFormats.textSize intValue];
	}
	
	UIFont * font = [UIFont  fontWithName:varFormats.typeFace size:varSize];
	listLabel.font = font;		
	
	//Hay que convertirlo a hexadecimal.
	//	varFormats.textColor
	listLabel.textColor = [UIColor blackColor];
	[listLabel setBackgroundColor:[UIColor clearColor]];
	
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
 


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
}

-(void) layoutSubviews {
	[super layoutSubviews];
	
	if([eMobcViewController isIPad]){
		CGRect contentRect = self.contentView.bounds;
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX+20, 0, 700, 100);
		listLabel.frame = frame;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(boundsX+990, 32, 16, 26);
		}else{
			frame = CGRectMake(boundsX+740, 32, 16, 26);
		}				
		
		listNextImageView.frame = frame;
	}else{
		CGRect contentRect = self.contentView.bounds;
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		frame = CGRectMake(boundsX+10, 0, 270, 50);
		listLabel.frame = frame;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			frame = CGRectMake(boundsX+220, 40, 9, 13);
		}else{
			frame = CGRectMake(boundsX+295, 40, 9, 13);
		}	
		
		listNextImageView.frame = frame;
	}
	

}

-(void)dealloc {
    [super dealloc];
}

@end