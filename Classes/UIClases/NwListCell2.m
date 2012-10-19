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

#import "NwListCell2.h"


@implementation NwListCell2

@synthesize listImageView;
@synthesize listLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		listImageView = [[UIImageView alloc] init];
		listNextImageView = [[UIImageView alloc] init];
		
		
		listLabel = [[UILabel alloc] init];
		listLabel.textAlignment = UITextAlignmentLeft;
		UIFont * font = [UIFont fontWithName:@"Ubuntu-Medium" size:16];
		
		listLabel.font = font;		
		listLabel.textColor =  [UIColor whiteColor];
		[listLabel setBackgroundColor:[UIColor clearColor]];

		
		UIView* bgColorView = [[UIView alloc] init];
		[bgColorView setBackgroundColor:[UIColor redColor]];
		self.selectedBackgroundView = bgColorView;
		[bgColorView release];	
		
		
		[self.contentView addSubview:listImageView];
		[self.contentView addSubview:listLabel];
		[self.contentView addSubview:listNextImageView];
    }
    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

}

-(void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX+10, 4, 73, 55);
	listImageView.frame = frame;
	
	frame = CGRectMake(boundsX+90, 20, 160, 20);
	listLabel.frame = frame;
	
	frame = CGRectMake(boundsX+245, 20, 10, 15);
	listNextImageView.frame = frame;
}

-(void)dealloc {
    [super dealloc];
}


@end
