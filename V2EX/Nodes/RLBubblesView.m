//
//  RLBubblesView.m
//  V2EX
//
//  Created by ucs on 16/1/7.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLBubblesView.h"
#import "RLNode.h"
#import "RLNodeBtn.h"
#import <QuartzCore/QuartzCore.h>

#define notAnimating 0
#define isAnimating 1
#define gutter 20
#define gap 5

@interface RLBubblesView()<UIScrollViewDelegate>

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
        [self setBackgroundColor:[UIColor blackColor]];
        self.delegate = self;
    }
    return self;
}

- (void)setNodeModels:(NSArray *)nodeModels {
    _nodeModels = nodeModels;
    
    float num = (self.mj_w * 2 - gutter * 2) / (60 + gap);
    int rowNum = nodeModels.count / num ;
    [self setContentSize:CGSizeMake(self.mj_w * 2 + (gutter * 2) - gap, rowNum * (60 + gap) + (gutter * 2))];
    [self setContentOffset:CGPointMake(self.contentSize.width / 2 - self.mj_w / 2, self.contentSize.height / 2 - self.mj_h /2)];

    int xValue = gutter;
    int yValue = gutter;
    int rowNumber = 1;
    
    for (int zz = 0; zz < nodeModels.count; zz++) {
        RLNode *nodeModel = nodeModels[zz];
        RLNodeBtn *nodeBtn = [RLNodeBtn nodeBtnWithNodeModel:nodeModel];
        [nodeBtn setTitle:nodeModel.title forState:UIControlStateNormal];
        
        nodeBtn.frame = CGRectMake(xValue, yValue, 60, 60);
        [self addNodeBtnToScrollView:nodeBtn];
        [nodeBtn addTarget:self action:@selector(nodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        xValue += (60 + gap);
        
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
}

- (void)addNodeBtnToScrollView:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:[self.imageNameArray objectAtIndex:arc4random() % 8]] forState:UIControlStateNormal];
    [self addSubview:btn];
    [self.nodesBtnArray addObject:btn];
}

- (void)nodeBtnClick:(RLNodeBtn *)nodeBtn {
    if (_nodeModels) {
        _clickAction(nodeBtn.nodeModel);//用block传出去
    }
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

- (UIView *)viewBarrierOuter {
    if (!_viewBarrierOuter) {
        _viewBarrierOuter = [[UIView alloc]initWithFrame:CGRectMake(self.mj_w / 8, self.mj_h / 8, self.mj_w * 0.75, self.mj_h * 0.75)];
        _viewBarrierOuter.backgroundColor = [UIColor redColor];
        _viewBarrierOuter.alpha = 0.3;
        _viewBarrierOuter.hidden = YES;
        [_viewBarrierOuter setUserInteractionEnabled:NO];
        [self addSubview:self.viewBarrierOuter];
    }
    return _viewBarrierOuter;
}

- (UIView *)viewBarrierInner {
    if (!_viewBarrierInner) {
        _viewBarrierInner = [[UIView alloc]initWithFrame:CGRectMake(self.mj_w / 4, self.mj_h / 4, self.mj_w * 0.5, self.mj_h * 0.5)];
        _viewBarrierInner.backgroundColor = [UIColor redColor];
        _viewBarrierInner.alpha = 0.3;
        _viewBarrierInner.hidden = YES;
        [_viewBarrierInner setUserInteractionEnabled:NO];
        [self addSubview:self.viewBarrierInner];
    }
    return _viewBarrierInner;
}

#pragma mark ------------------------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect container = CGRectMake(scrollView.contentOffset.x + (self.viewBarrierOuter.mj_w / 8),
                                  scrollView.contentOffset.y + (self.viewBarrierOuter.mj_h / 8),
                                  self.viewBarrierOuter.mj_w,
                                  self.viewBarrierOuter.mj_h);
    
    CGRect containerTwo = CGRectMake(scrollView.contentOffset.x + (self.viewBarrierInner.mj_w / 2),
                                     scrollView.contentOffset.y + (self.viewBarrierInner.mj_h / 2),
                                     self.viewBarrierInner.mj_w,
                                     self.viewBarrierInner.mj_h);
    
    dispatch_queue_t fetchQ = dispatch_queue_create("BubbleQueue", NULL);
    dispatch_async(fetchQ, ^{
        for (UIButton *nodeBtn in self.nodesBtnArray) {
            CGRect thePosition = nodeBtn.frame;
            if(CGRectIntersectsRect(containerTwo, thePosition)) {
                if (nodeBtn.tag == notAnimating) {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.3 animations:^{
                            nodeBtn.transform = CGAffineTransformMakeScale(1.0,1.0);
                        } completion:^(BOOL finished) {
                            nodeBtn.tag = notAnimating;
                        }];
                    });
                }
            }else if(CGRectIntersectsRect(container, thePosition)) {
                if (nodeBtn.tag == notAnimating) {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.3 animations:^{
                            nodeBtn.transform = CGAffineTransformMakeScale(0.7,0.7);
                        } completion:^(BOOL finished) {
                            nodeBtn.tag = notAnimating;
                        }];
                    });
                }
            }else {
                if (nodeBtn.tag == notAnimating) {
                    nodeBtn.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.3 animations:^{
                            nodeBtn.transform = CGAffineTransformMakeScale(0.5,0.5);
                        } completion:^(BOOL finished) {
                            nodeBtn.tag = notAnimating;
                        }];
                    });
                }
            }
        }
    });
}

@end
