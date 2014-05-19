//
//  XLCPostDetailViewCell.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-18.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostDetailViewCell.h"

@implementation XLCPostDetailViewCell


- (id)init
{
    self = [super init];
    if (self) {
        [self initCell];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCell];
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initCell];
}

- (void) initCell
{
    hasInitialied = FALSE;
    hasQuote = FALSE;
    heightOfCell = INITIAL_HEIGHT;
    
    section = -1;
    row = -1;
    
    postContentLabel = nil;
    bottomBorderLayers = [[NSMutableArray alloc] init];
}

- (void)setupWithInitialization
{
    if (hasInitialied == TRUE) {
        [self removeBottomBorderLayers];
        return;
    }
    
    [self setup];
}


- (void)setup
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.backgroundColor = [UIColor whiteColor];
    
    /*
     UIImage *stretchableImage = [[UIImage imageNamed:@"quoteBackground"]
     stretchableImageWithLeftCapWidth:130 topCapHeight:14];
     self.qouteBgView = [[UIImageView alloc] initWithImage:stretchableImage];
     self.qouteView = [[UIView alloc] initWithFrame:CGRectInset(bounds, 10.0f, 0)];
     [self.qouteView addSubview:self.qouteBgView];
     //[self.qouteView setBackgroundColor:[UIColor redColor]];
     */
    //[self addSubview:self.qouteView];
    
    
    hasQuote = FALSE;
    hasInitialied = TRUE;
}

- (void)setupWithPostDetail:(XLCPostDetail *)postDetail
                AtIndexPath:(NSIndexPath *)index
{
    heightOfCell = INITIAL_HEIGHT;
    section = index.section;
    row = index.row;
    
    [self adjustViewHeight];
    
}

- (void) adjustViewHeight
{
    CGRect cellFrame = self.frame;
    cellFrame.size.height = [self getHeight];
    self.frame = cellFrame;
    
}

- (void) addBottomBorderForView:(UIView *)theView
{
    CALayer *bottomBorder = [CALayer layer];
    float height = theView.frame.size.height - 1.0f;
    float width = theView.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [theView.layer addSublayer:bottomBorder];
    
    [bottomBorderLayers addObject:bottomBorder];
}

- (void) removeBottomBorderLayers
{
    for (CALayer *bottomBorder in bottomBorderLayers) {
        [bottomBorder removeFromSuperlayer];
    }
    
    [bottomBorderLayers removeAllObjects];
}


- (CGFloat)getHeight
{
    return heightOfCell;
}

- (BOOL) isForIndexPath:(NSIndexPath *)index
{
    return section == index.section && row == index.row;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
