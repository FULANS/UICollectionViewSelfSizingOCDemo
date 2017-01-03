//
//  SelfSizingCollectCell.m
//  UICollectionViewSelfSizingOCDemo
//
//  Created by wangzheng on 16/11/30.
//  Copyright © 2016年 WZheng. All rights reserved.
//

#import "SelfSizingCollectCell.h"
#import "Masonry.h"
#define itemHeight 30

@implementation SelfSizingCollectCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment =NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.textLabel];
        

        
       // self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
           // make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            
            make.height.equalTo(@(itemHeight));                // 高度
            
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
   
        }];
        
    }
    
    
    
    return self;
}


- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
   
    
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
   UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];

    CGRect frame = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.textLabel.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textLabel.font,NSFontAttributeName, nil] context:nil];
    
    frame.size.height = itemHeight;
    frame.size.width = frame.size.width + 10;
    attributes.frame = frame;
    

    // 如果不是用约束布局的,这边必须也要去修改cell上控件的frame才行
   // self.textLabel.frame = CGRectMake(0, 0, attributes.frame.size.width, 30);
    
    return attributes;
}
@end
