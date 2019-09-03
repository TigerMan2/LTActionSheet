//
//  LTSheetCell.m
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "LTActionSheetCell.h"
#import "LTActionSheetItem.h"

@interface LTActionSheetCell ()
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIView *topLine;
@end

@implementation LTActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:LTActionSheetBackColor];
        self.contentView.backgroundColor = self.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _contentAlignment = LTItemContentAlignmentCenter;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.tintColor = [UIColor colorWithHexString:LTActionSheetItemNormalColor];
    _titleButton.titleLabel.font = [UIFont systemFontOfSize:LTActionSheetItemTitleFontSize];
    _titleButton.userInteractionEnabled = NO;
    _titleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleButton];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleButton)]];
    
    // top line
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = [UIColor colorWithHexString:LTActionSheetRowTopLineColor];
    _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_topLine];
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale; //!< top line height
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topLine]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"v:|[_topLine(lineHeight)]|" options:0 metrics:@{@"lineHeight":@(lineHeight)} views:NSDictionaryOfVariableBindings(_topLine)]];
    
}

- (void)setItem:(LTActionSheetItem *)item {
    _item = item;
    
    UIColor *tintColor;
    if (item.tintColor) {
        tintColor = item.tintColor;
    } else {
        if (item.type == LTActionSheetTypeNormal) {
            tintColor = [UIColor colorWithHexString:LTActionSheetItemNormalColor];
        } else {
            tintColor = [UIColor colorWithHexString:LTActionSheetItemHighlightColor];
        }
    }
    _titleButton.tintColor = tintColor;
    
    // 调整图片与标题的间距
    _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, item.image?-LTActionSheetItemContentSpacig/2:0, item.image?1:0, item.image?LTActionSheetItemContentSpacig/2:0);
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(item.image?1:0, item.image?LTActionSheetItemContentSpacig/2:0, 0, item.image?-LTActionSheetItemContentSpacig/2:0);
    
    [_titleButton setTitle:item.title forState:UIControlStateNormal];
    [_titleButton setImage:item.image forState:UIControlStateNormal];
}

- (void)setContentAlignment:(LTItemContentAlignment)contentAlignment {
    
    if (_contentAlignment == contentAlignment) return;
    
    _contentAlignment = contentAlignment;
    
    //!< update titleButton layout
    [self updateButtonLayout];
    
    switch (contentAlignment) {
        case LTItemContentAlignmentLeft:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, LTActionSheetDefaultMargin, 0, -LTActionSheetDefaultMargin);
        }
            break;
        case LTItemContentAlignmentCenter:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            _titleButton.contentEdgeInsets = UIEdgeInsetsZero;
        }
            break;
        case LTItemContentAlignmentRight:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, -LTActionSheetDefaultMargin, 0, LTActionSheetDefaultMargin);
        }
            break;
        default:
            break;
    }
}

- (void)updateButtonLayout {
    if (!_item.image) return;
    
    if (_contentAlignment == LTItemContentAlignmentRight) {
        CGFloat titleWidth = [[_titleButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:_titleButton.titleLabel.font}].width;
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 1, -titleWidth);
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(1, -_item.image.size.width - LTActionSheetItemContentSpacig, 0, _item.image.size.width + LTActionSheetItemContentSpacig);
    } else {
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LTActionSheetItemContentSpacig/2, 1, LTActionSheetItemContentSpacig/2);
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(1, LTActionSheetItemContentSpacig/2, 0, -LTActionSheetItemContentSpacig/2);
    }
}

- (void)setHideTopLine:(BOOL)hideTopLine {
    _topLine.hidden = hideTopLine;
}

@end
