//
//  RLBubblesView.m
//  V2EX
//
//  Created by ucs on 16/1/7.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLBubblesView.h"
#import <QuartzCore/QuartzCore.h>

#define notAnimating 0
#define isAnimating 1

@interface RLBubblesView()<UIScrollViewDelegate>
//@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *nodesBtnArray;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) UIView *viewBarrierOuter;
@property (nonatomic, strong) UIView *viewBarrierInner;
@property (nonatomic, assign) CGSize bigSize;
@property (nonatomic, assign) CGSize smallSize;
@end

@implementation RLBubblesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bigSize = CGSizeMake(60, 60);
        self.smallSize = CGSizeMake(30, 30);
        int gutter = 20;
        
        [self setBackgroundColor:[UIColor blackColor]];
        [self setContentSize:CGSizeMake(self.mj_w * 2 + (gutter * 2), self.mj_h * 2 + (gutter * 3))];
        [self setContentOffset:CGPointMake(self.contentSize.width / 2 - self.mj_w / 2, self.contentSize.height / 2 - self.mj_h /2)];
        
        int gap = 5;
        int xValue = gutter;
        int yValue = gutter;
        int rowNumber = 1;
        
        for (int zz = 0; zz < 886; zz++) {
            UIButton *nodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nodeBtn.frame = CGRectMake(xValue, yValue, 60, 60);
            [self addNodeBtnToScrollView:nodeBtn];
            
            xValue += (60+gap+gap);
            
            if (xValue > (self.contentSize.width - (gutter * 3))) {
                if (rowNumber % 2) {
                    xValue = 30 + gutter;
                }else{
                    xValue = 0 + gutter;
                }
                yValue += (60 + gap);
                rowNumber += 1;
            }
        }
        self.delegate = self;
        //Unhide this to see the barrier that is changing the size of the circles/images
        self.viewBarrierOuter = [[UIView alloc]initWithFrame:CGRectMake(self.mj_w / 8, self.mj_h / 8, self.mj_w * 0.75, self.mj_h * 0.75)];
        self.viewBarrierOuter.backgroundColor = [UIColor redColor];
        self.viewBarrierOuter.alpha = 0.3;
        self.viewBarrierOuter.hidden = YES;
        [self.viewBarrierOuter setUserInteractionEnabled:NO];
        [self addSubview:self.viewBarrierOuter];
        
        self.viewBarrierInner = [[UIView alloc]initWithFrame:CGRectMake(self.mj_w / 4, self.mj_h / 4, self.mj_w * 0.5, self.mj_h * 0.5)];
        self.viewBarrierInner.backgroundColor = [UIColor redColor];
        self.viewBarrierInner.alpha = 0.3;
        self.viewBarrierInner.hidden = YES;
        [self.viewBarrierInner setUserInteractionEnabled:NO];
        [self addSubview:self.viewBarrierInner];
    }
    return self;
}

- (void)setNodeModels:(NSArray *)nodeModels {
    _nodeModels = nodeModels;
}

- (void)addNodeBtnToScrollView:(UIButton *)btn {
    [btn setImage:[UIImage imageNamed:[self.imageNameArray objectAtIndex:arc4random()%9]] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:12];
    [btn.layer setMasksToBounds:YES];
    btn.layer.anchorPoint = CGPointMake(0.5,0.5);
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:btn];
    [self.nodesBtnArray addObject:btn];
}

#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (NSMutableArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray = [NSMutableArray array];
        [_imageNameArray addObject:@"icon_one.png"];
        [_imageNameArray addObject:@"icon_two.png"];
        [_imageNameArray addObject:@"icon_three.png"];
        [_imageNameArray addObject:@"icon_four.png"];
        [_imageNameArray addObject:@"icon_five.png"];
        [_imageNameArray addObject:@"icon_six.png"];
        [_imageNameArray addObject:@"icon_seven.png"];
        [_imageNameArray addObject:@"icon_eight.png"];
        [_imageNameArray addObject:@"icon_nine.png"];
        [_imageNameArray addObject:@"icon_ten.png"];
    }
    return _imageNameArray;
}

- (NSMutableArray *)nodesBtnArray {
    if (!_nodesBtnArray) {
        _nodesBtnArray = [NSMutableArray array];
    }
    return _nodesBtnArray;
}

#pragma mark ------------------------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect container = CGRectMake(scrollView.contentOffset.x+(self.viewBarrierOuter.frame.size.width/8), scrollView.contentOffset.y+(self.viewBarrierOuter.frame.size.height/8), self.viewBarrierOuter.frame.size.width, self.viewBarrierOuter.frame.size.height);
    CGRect containerTwo = CGRectMake(scrollView.contentOffset.x+(self.viewBarrierInner.frame.size.width/2), scrollView.contentOffset.y+(self.viewBarrierInner.frame.size.height/2), self.viewBarrierInner.frame.size.width, self.viewBarrierInner.frame.size.height);
    dispatch_queue_t fetchQ = dispatch_queue_create("BubbleQueue", NULL);
    dispatch_async(fetchQ, ^{
        for (UIButton *nodeBtn in self.nodesBtnArray)
        {
            CGRect thePosition =  nodeBtn.frame;
            if(CGRectIntersectsRect(containerTwo, thePosition))
            {
                if (nodeBtn.tag == notAnimating)
                {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             nodeBtn.transform = CGAffineTransformMakeScale(1.0,1.0);
                                         }
                                         completion:^(BOOL finished) {
                                             nodeBtn.tag = notAnimating;
                                         }
                         ];
                    });
                }
            }else if(CGRectIntersectsRect(container, thePosition))
            {
                if (nodeBtn.tag == notAnimating)
                {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             nodeBtn.transform = CGAffineTransformMakeScale(0.7,0.7);
                                         }
                                         completion:^(BOOL finished) {
                                             nodeBtn.tag = notAnimating;
                                         }
                         ];
                    });
                }
            }else{
                if (nodeBtn.tag == notAnimating)
                {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             nodeBtn.transform = CGAffineTransformMakeScale(0.5,0.5);
                                         }
                                         completion:^(BOOL finished) {
                                             nodeBtn.tag = notAnimating;
                                         }
                         ];
                    });
                }
            }
        }
    });
}

@end
