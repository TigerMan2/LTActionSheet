//
//  TMSheetCell.m
//  TMActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "TMActionSheetCell.h"
#import "TMActionSheetItem.h"

@interface TMActionSheetCell ()
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIView *topLine;
@end

@implementation TMActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:TMActionSheetBackColor];
        self.contentView.backgroundColor = self.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _contentAlignment = TMItemContentAlignmentCenter;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.tintColor = [UIColor colorWithHexString:TMActionSheetItemNormalColor];
    _titleButton.titleLabel.font = [UIFont systemFontOfSize:TMActionSheetItemTitleFontSize];
    _titleButton.userInteractionEnabled = NO;
    _titleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleButton];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleButton)]];
    
    // top line
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = [UIColor colorWithHexString:TMActionSheetRowTopLineColor];
    _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_topLine];
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale; //!< top line height
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topLine]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"v:|[_topLine(lineHeight)]|" options:0 metrics:@{@"lineHeight":@(lineHeight)} views:NSDictionaryOfVariableBindings(_topLine)]];
    
}

- (void)setItem:(TMActionSheetItem *)item {
    _item = item;
    
    UIColor *tintColor;
    if (item.tintColor) {
        tintColor = item.tintColor;
    } else {
        if (item.type == TMActionSheetTypeNormal) {
            tintColor = [UIColor colorWithHexString:TMActionSheetItemNormalColor];
        } else {
            tintColor = [UIColor colorWithHexString:TMActionSheetItemHighlightColor];
        }
    }
    _titleButton.tintColor = tintColor;
    
    // 调整图片与标题的间距
    _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, item.image?-TMActionSheetItemContentSpacig/2:0, item.image?1:0, item.image?TMActionSheetItemContentSpacig/2:0);
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(item.image?1:0, item.image?TMActionSheetItemContentSpacig/2:0, 0, item.image?-TMActionSheetItemContentSpacig/2:0);
    
    [_titleButton setTitle:item.title forState:UIControlStateNormal];
    [_titleButton setImage:item.image forState:UIControlStateNormal];
}

- (void)setContentAlignment:(TMItemContentAlignment)contentAlignment {
    
    if (_contentAlignment == contentAlignment) return;
    
    _contentAlignment = contentAlignment;
    
    //!< update titleButton layout
    [self updateButtonLayout];
    
    switch (contentAlignment) {
        case TMItemContentAlignmentLeft:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, TMActionSheetDefaultMargin, 0, -TMActionSheetDefaultMargin);
        }
            break;
        case TMItemContentAlignmentCenter:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            _titleButton.contentEdgeInsets = UIEdgeInsetsZero;
        }
            break;
        case TMItemContentAlignmentRight:
        {
            _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, -TMActionSheetDefaultMargin, 0, TMActionSheetDefaultMargin);
        }
            break;
        default:
            break;
    }
}

- (void)updateButtonLayout {
    if (!_item.image) return;
    
    if (_contentAlignment == TMItemContentAlignmentRight) {
        CGFloat titleWidth = [[_titleButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:_titleButton.titleLabel.font}].width;
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 1, -titleWidth);
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(1, -_item.image.size.width - TMActionSheetItemContentSpacig, 0, _item.image.size.width + TMActionSheetItemContentSpacig);
    } else {
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -TMActionSheetItemContentSpacig/2, 1, TMActionSheetItemContentSpacig/2);
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(1, TMActionSheetItemContentSpacig/2, 0, -TMActionSheetItemContentSpacig/2);
    }
}

- (void)setHideTopLine:(BOOL)hideTopLine {
    _topLine.hidden = hideTopLine;
}

@end
