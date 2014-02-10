//
//  TSNNewsDetailView.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A UIView subclass to display news item detail, including the headline, summary text and a photo. Lays out content in a UIScrollView. Provides a UIButton to launch another view if the user wants to read the entire article. 

#import "TSNNewsDetailView.h"
#import "TSNNewsItem.h"
#import "UIImageView+AFNetworking.h"

@interface TSNNewsDetailView ()

@property (nonatomic, strong) TSNNewsItem *newsItem;

@end

@implementation TSNNewsDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame newsItem:(TSNNewsItem *)newsItem
{
    self = [self initWithFrame:frame];
    if (self) {
        _newsItem = newsItem;
    }
    return self;
}

#define kContentWidth 290.0
#define kMargin 15.0

- (void)layoutNewsContent
{
    self.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    [self addSubview:scrollView];
    
    // get headline text label and add to scrollview
    UILabel *headlineLabel = [self headlineLabelWithText:_newsItem.headline];
    [scrollView addSubview:headlineLabel];
    
    // add byline and date label
    CGFloat offsetY = CGRectGetMaxY(headlineLabel.frame);
    UILabel *sourceLabel = [self sourceLabelWithText:_newsItem.source andDate:_newsItem.publishedDate];
    CGRect labelFrame = sourceLabel.frame;
    labelFrame.origin.y = offsetY + 3.0;
    sourceLabel.frame = labelFrame;
    [scrollView addSubview:sourceLabel];
    
    // add textview with summary and image
    UIImageView *imageView = [self imageViewForNewsItem];
    UITextView *textView = [self summaryTextViewWithText:_newsItem.summary andImageView:imageView];
    CGRect textFrame = textView.frame;
    textFrame.origin.y += CGRectGetMaxY(sourceLabel.frame);
    textView.frame = textFrame;
    [scrollView addSubview:textView];
    
    // add button to read article
    CGRect buttonFrame = self.moreButton.frame;
    buttonFrame.origin.y = CGRectGetMaxY(textView.frame) + 25.0;
    self.moreButton.frame = buttonFrame;
    [scrollView addSubview:self.moreButton];
    
    // set content size
    [scrollView setContentSize:CGSizeMake(kContentWidth, CGRectGetMaxY(self.moreButton.frame))];
}

- (UIButton *)moreButton
{
    if (_moreButton != nil) {
        return _moreButton;
    }
    
    CGFloat buttonWidth = 160.0;
    CGFloat offsetX = 160.0 - (buttonWidth / 2);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(offsetX, 0, buttonWidth, 21.0);
    [button setTitle:@"Read More" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _moreButton = button;
    return _moreButton;
}

- (UITextView *)summaryTextViewWithText:(NSString *)summaryText andImageView:(UIImageView *)imageView
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = [UIColor blackColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    NSAttributedString *summaryAttributed = [[NSAttributedString alloc] initWithString:summaryText attributes:attributes];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:summaryAttributed];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kContentWidth, CGFLOAT_MAX)];
    [layoutManager addTextContainer:textContainer];
    
    if (!CGSizeEqualToSize(_newsItem.imageSize, CGSizeZero)) {
        CGFloat imagePadding = 6.0;
        CGFloat pathWidth = imageView.bounds.size.width + imagePadding;
        UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, pathWidth, imageView.bounds.size.height)];
        [textContainer setExclusionPaths:[NSArray arrayWithObject:exclusionPath]];
    }
    
    CGRect boundingRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) inTextContainer:textContainer];
    CGFloat textHeight = MAX(imageView.bounds.size.height, ceilf(boundingRect.size.height));
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kMargin - 5.0, 0, kContentWidth + 5.0, textHeight) textContainer:textContainer];
    [textView setEditable:NO];
    [textView setScrollEnabled:NO];
    [textView setTextContainerInset:UIEdgeInsetsZero];
    [textView setContentInset:UIEdgeInsetsZero];
    
    if (!CGSizeEqualToSize(CGSizeZero, _newsItem.imageSize)) {
        CGRect imageFrame = imageView.frame;
        imageFrame.origin.y += 5.0;
        imageFrame.origin.x += 5.0;
        imageView.frame = imageFrame;
        [textView addSubview:imageView];
    }
    return textView;
}

- (UIImageView *)imageViewForNewsItem
{
    CGSize imageSize = _newsItem.imageSize;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return nil;
    }
    
    CGFloat scaledWidth = 120.0;
    CGFloat scaledHeight = imageSize.height * (scaledWidth / imageSize.width);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    [imageView setImageWithURL:_newsItem.imageURL];
    return imageView;
}

- (UILabel *)sourceLabelWithText:(NSString *)sourceName andDate:(NSDate *)itemDate
{
    UIFont *labelFont = [UIFont systemFontOfSize:12.0];
    UIColor *textColor = [UIColor blackColor];
    NSString *labelText = [NSString new];
    if (sourceName != nil) {
        labelText = [NSString stringWithFormat:@"from %@ - ", sourceName];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    labelText = [labelText stringByAppendingString:[formatter stringFromDate:itemDate]];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    CGRect boundingRect = [labelText boundingRectWithSize:CGSizeMake(kContentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    CGFloat labelHeight = ceilf(boundingRect.size.height) + 15.0;
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(kMargin, 0, kContentWidth, labelHeight);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:labelText attributes:attributes];
    [label setAttributedText:attributedString];
    [label setNumberOfLines:0];
    return label;
    
}

- (UILabel *)headlineLabelWithText:(NSString *)title
{
    UIFont *labelFont = [UIFont boldSystemFontOfSize:21.0];
    UIColor *textColor = [UIColor blackColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    NSAttributedString *headline = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    CGRect boundingRect = [headline boundingRectWithSize:CGSizeMake(kContentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat labelHeight = ceilf(boundingRect.size.height) + 10.0;
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(kMargin, 0, kContentWidth, labelHeight);
    label.numberOfLines = 0;
    [label setAttributedText:headline];
    return label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
