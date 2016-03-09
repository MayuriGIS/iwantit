//
//  SummaryCardView.m
//  BeaconstacExample
//
//  Created by Kshitij-Deo on 05/01/15.
//

#import "SummaryCardView.h"

@interface SummaryCardView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SummaryCardView

- (void)setNeedsLayout
{
    self.summaryView.delegate = self;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    self.imageView.layer.masksToBounds = YES;
}


- (IBAction)button2Clicked:(id)sender
{
    if (self.okAction && [self.okAction length]) {
        if (self.delegate) [self.delegate summaryButtonClickedAtIndex:1];
    } else {
        if (self.delegate) [self.delegate summaryButtonClickedAtIndex:0];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

@end
