//
//  XLCPostDetailViewCell.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-26.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostDetailViewCell.h"
#import "XLCParagraph.h"
#import "XLCParagraphContent.h"

#define INITIAL_HEIGHT 30

@interface XLCPostDetailViewCell ()
{
    BOOL hasInitialied;
    BOOL hasQuote;
    CGFloat heightOfCell;
    
    NSInteger section;
    NSInteger row;
    
    NSMutableArray *bottomBorderLayers;
}
@end

@implementation XLCPostDetailViewCell

- (id)init
{
    NSLog(@"XLCPostDetailViewCell init");
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
    
    bottomBorderLayers = [[NSMutableArray alloc] init];
}

- (void)setupWithInitialization
{
    if (hasInitialied == TRUE) {
        [self removeBottomBorderLayers];
        return;
    }
    
    //NSLog(@"Init setupWithInitialization");
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
                    isReply:(BOOL)isReply AtIndexPath:(NSIndexPath *)index
{
    heightOfCell = INITIAL_HEIGHT;
    section = index.section;
    row = index.row;
    
    [self constructPostMetadata:postDetail isReply:isReply];
    
    [self constructPostContent:postDetail];
    
    heightOfCell += self.postMetadataView.frame.size.height;
    heightOfCell += self.postContentView.frame.size.height;
    /*
    if (postDetail.qoute.count > 0) {
        hasQuote = TRUE;
        NSLog(@"has qoute");
        // add qoute content
        
        heightOfCell += self.qouteView.frame.size.height;
    } else {
        NSLog(@"no qoute");
        self.qouteView.hidden = YES;
    }
    */
    
    [self adjustViewHeight];
    //[self addBottomBorderForView:self.postMetadataView];
    [self addBottomBorderForView:self];
    
    
    
    NSLog(@"height is %f", [self getHeight]);
}

#pragma mark Load Post Metadata
- (void)constructPostMetadata:(XLCPostDetail *)postDetail isReply:(BOOL)isReply
{
    self.ownerLabel.text = postDetail.metaData.owner;
    self.dateLabel.text = postDetail.metaData.date;
    
    if (isReply) {
        //self.titleLabel.hidden = YES;
        [self.titleLabel removeFromSuperview];
        CGRect metadataFrame = self.postMetadataView.frame;
        metadataFrame.size.height -= self.titleLabel.frame.size.height;
        self.postMetadataView.frame = metadataFrame;
    } else {
        
        self.titleLabel.text = postDetail.metaData.title;
    }
}

#pragma mark Load Post Content

- (void)constructPostContent:(XLCPostDetail *)postDetail
{
    NSLog(@"constructPostContent");
    [self.postContentView setText:@""];
    
    NSArray *paragraphs = postDetail.body;
    
    for (XLCParagraph *paragraph in paragraphs) {
        NSArray *contents = paragraph.paraContent;
        for (XLCParagraphContent *content in contents) {
            if (content.isNewLine) {
                [self.postContentView appendText:@"\n"];
            }
            else if (content.isImage) {
                
            }
            else if (content.isLink) {
                
            }
            else {
                NSLog(@"post content : %@", content.content);
                [self.postContentView appendText:[NSString stringWithFormat:@"%@", content.content]];
            }
        }
        [self.postContentView appendText:@"\n"];
    }
    
    CGSize contentSize = [self.postContentView sizeThatFits:CGSizeMake(300, 10000)];
    
    NSLog(@"width : %f, height : %f", contentSize.width, contentSize.height);
    CGRect postContentFrame = self.postContentView.frame;
    postContentFrame.size.height = contentSize.height;
    //postContentFrame.origin.y = self.postMetadataView.frame.origin.y + self.postMetadataView.frame.size.height;
    
    //self.postContentView.frame = postContentFrame;
    [self.postContentView setFrame:postContentFrame];
    
}

- (void) adjustViewHeight
{
    /*
    if (hasQuote) {
        CGRect qouteFrame = self.qouteView.frame;
        qouteFrame.origin.y = self.postContentView.frame.origin.y +
        self.postContentView.frame.size.height + 5;
        self.qouteView.frame = qouteFrame;
    }
    */
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
