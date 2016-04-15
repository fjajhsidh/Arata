//
//  StayApprovalViewCell.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "StayApprovalViewCell.h"
static CGFloat const kBounceValue = 20.0f;
@interface StayApprovalViewCell()

@property (nonatomic,assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCconstraint;

@end


@implementation StayApprovalViewCell

- (void)awakeFromNib {
    // Initialization code
    self.edit = YES;
    UIPanGestureRecognizer *swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollBgView:)];
    swip.delegate = self;
    [self.bgView addGestureRecognizer:swip];
    
    
}


#pragma mark - Action

- (void)scrollBgView:(UIPanGestureRecognizer *)recognizer{
    if (!self.isEdit) {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.bgView];
            self.startingRightLayoutConstraintConstant = self.rightCconstraint.constant;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [recognizer translationInView:self.bgView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) { //2
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0); //3
                    if (constant == 0) { //4
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //5
                        self.rightCconstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //6
                    if (constant == [self buttonTotalWidth]) { //7
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //8
                        self.rightCconstraint.constant = constant;
                    }
                }
            }
            else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //1
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0); //2
                    if (constant == 0) { //3
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //4
                        self.rightCconstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //5
                    if (constant == [self buttonTotalWidth]) { //6
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //7
                        self.rightCconstraint.constant = constant;
                    }
                }
            }
            
            self.leftCconstraint.constant = -self.rightCconstraint.constant; //8
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //Cell was opening
                CGFloat halfOfButtonOne = CGRectGetWidth(self.agreeBtn.frame) / 2; //2
                if (self.rightCconstraint.constant >= halfOfButtonOne) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.agreeBtn.frame) + (CGRectGetWidth(self.backBtn.frame) / 2); //4
                if (self.rightCconstraint.constant >= buttonOnePlusHalfOfButton2) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"Pan Cancelled");
            break;
        default:
            break;
    }
    
}

- (void)setClose:(BOOL)close{
    _close = close;
    if (close) {
        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
    }
}

#pragma mark - Custom Methods

- (CGFloat)buttonTotalWidth {
   // return 100.0f;
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.backBtn.frame);
}
- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing
{
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.rightCconstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.rightCconstraint.constant = -kBounceValue;
    self.leftCconstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.rightCconstraint.constant = 0;
        self.leftCconstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.rightCconstraint.constant;
        }];
    }];
}
    
- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.rightCconstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.leftCconstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.rightCconstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.leftCconstraint.constant = -[self buttonTotalWidth];
        self.rightCconstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.rightCconstraint.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Btn Action
- (IBAction)selectItem:(UIButton *)sender {
    
    if (self.selectItem) {
        _selectItem();
    }
    
}
- (IBAction)agreeApply:(id)sender {
    if (self.agreeApply) {
        _agreeApply(self);
    }
}

- (IBAction)backApply:(id)sender {
    if (self.backApply) {
        _backApply(self);
    }
}


@end
