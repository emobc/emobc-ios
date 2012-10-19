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

#import "NwListCell.h"


@implementation NwListCell

@synthesize listImageView;
@synthesize listLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		listImageView = [[AsyncImageView alloc] init];
		listImageView.tag = 999;
		
		listNextImageView = [[UIImageView alloc] init];
		
		
		listLabel = [[UILabel alloc] init];
		listLabel.textAlignment = UITextAlignmentLeft;
		UIFont * font = [UIFont fontWithName:@"Ubuntu-Medium" size:16];
		listLabel.font = font;

		
		listNextImageView.image = [UIImage imageNamed:@"flecha_siguiente.png"];
		
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
	
	frame = CGRectMake(boundsX+10, 0, 73, 55);
	listImageView.frame = frame;
	
	frame = CGRectMake(boundsX+120, 20, 150, 20);
	listLabel.frame = frame;
	
	frame = CGRectMake(boundsX+275, 20, 9, 13);
	listNextImageView.frame = frame;
}

-(void)dealloc {
    [super dealloc];
}


@end
