//
//  ViewController.swift
//  KeyboardAccessory
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/12/28.
//
//
//
///*
//     File: ViewController.h
//     File: ViewController.m
// Abstract: View controller that adds a keyboard accessory to a text view.
//
//  Version: 1.5
//
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
//
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
//
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Copyright (C) 2014 Apple Inc. All Rights Reserved.
//
// */
//
//#import <UIKit/UIKit.h>
import UIKit
//
//@interface ViewController : UIViewController
@objc(ViewController)
class ViewController: UIViewController, UITextViewDelegate {
//
//@end
//
//
//#import "ViewController.h"
//
//@interface ViewController () <UITextViewDelegate>
//
//@property (nonatomic, weak) IBOutlet UITextView *textView;
    @IBOutlet weak var textView: UITextView!
//@property (nonatomic, weak) IBOutlet UIView *accessoryView; // view placed on top of keyboard
    @IBOutlet weak var accessoryView: UIView! // view placed on top of keyboard
//
//@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
    @IBOutlet weak var editButton: UIBarButtonItem!
//@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
    @IBOutlet weak var doneButton: UIBarButtonItem!
//
//// the height constraint we want to change when the keyboard shows/hides
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;
    @IBOutlet weak var constraintToAdjust: NSLayoutConstraint!
//
//@end
//
//
//#pragma mark -
//
//@implementation ViewController
//
//- (void)viewDidLoad {
    override func viewDidLoad() {
//
//    [super viewDidLoad];
        super.viewDidLoad()
//
//    // set the right bar button item initially to "Edit" state
//    self.navigationItem.rightBarButtonItem = self.editButton;
        self.navigationItem.rightBarButtonItem = self.editButton
//}
    }
//
//- (void)viewDidAppear:(BOOL)animated {
    override func viewDidAppear(animated: Bool) {
//
//    // observe keyboard hide and show notifications to resize the text view appropriately
//    [[NSNotificationCenter defaultCenter] addObserver:self
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ViewController.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ViewController.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//
//    // start editing the UITextView (makes the keyboard appear when the application launches)
//    [self editAction:self];
        self.editAction(self)
//}
    }
//
//- (void)viewDidDisappear:(BOOL)animated {
    override func viewDidDisappear(animated: Bool) {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
//                                                    name:UIKeyboardWillChangeFrameNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification,
            object: nil)
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
//}
    }
//
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//    [self adjustSelection:self.textView];
        self.adjustSelection(self.textView)
//}
    }
//
//
//#pragma mark - Actions
//
//- (IBAction)doneAction:(id)sender {
    @IBAction func doneAction(_: AnyObject) {
//
//    // user tapped the Done button, release first responder on the text view
//    [self.textView resignFirstResponder];
        self.textView.resignFirstResponder()
//}
    }
//
//- (IBAction)editAction:(id)sender {
    @IBAction func editAction(_: AnyObject) {
//
//    // user tapped the Edit button, make the text view first responder
//    [self.textView becomeFirstResponder];
        self.textView.becomeFirstResponder()
//}
    }
//
//
//#pragma mark - UITextViewDelegate
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//
//    // note: you can create the accessory view programmatically (in code), or from the storyboard
//    if (self.textView.inputAccessoryView == nil) {
        if self.textView.inputAccessoryView == nil {
//
//        self.textView.inputAccessoryView = self.accessoryView;  // use what's in the storyboard
            self.textView.inputAccessoryView = self.accessoryView  // use what's in the storyboard
//    }
        }
//
//    self.navigationItem.rightBarButtonItem = self.doneButton;
        self.navigationItem.rightBarButtonItem = self.doneButton
//
//    return YES;
        return true
//}
    }
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    func textViewShouldEndEditing(aTextView: UITextView) -> Bool {
//
//    [aTextView resignFirstResponder];
        aTextView.resignFirstResponder()
//    self.navigationItem.rightBarButtonItem = self.editButton;
        self.navigationItem.rightBarButtonItem = self.editButton
//
//    return YES;
        return true
//}
    }
//
//- (void)adjustSelection:(UITextView *)textView {
    private func adjustSelection(textView: UITextView) {
//
//    // workaround to UITextView bug, text at the very bottom is slightly cropped by the keyboard
//    if ([textView respondsToSelector:@selector(textContainerInset)]) {
//        [textView layoutIfNeeded];
            textView.layoutIfNeeded()
//        CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
            var caretRect = textView.caretRectForPosition(textView.selectedTextRange!.end)
//        caretRect.size.height += textView.textContainerInset.bottom;
            caretRect.size.height += textView.textContainerInset.bottom
//        [textView scrollRectToVisible:caretRect animated:NO];
            textView.scrollRectToVisible(caretRect, animated: false)
//    }
//}
    }
//
//- (void)textViewDidBeginEditing:(UITextView *)textView {
    func textViewDidBeginEditing(textView: UITextView) {
//
//    [self adjustSelection:textView];
        self.adjustSelection(textView)
//}
    }
//
//- (void)textViewDidChangeSelection:(UITextView *)textView {
    func textViewDidChangeSelection(textView: UITextView) {
//
//    [self adjustSelection:textView];
        self.adjustSelection(textView)
//}
    }
//
//
//#pragma mark - Responding to keyboard events
//
//- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    private func adjustTextViewByKeyboardState(showKeyboard: Bool, keyboardInfo info: [NSObject: AnyObject]) {
//
//    /*
//     Reduce the size of the text view so that it's not obscured by the keyboard.
//     Animate the resize so that it's in sync with the appearance of the keyboard.
//     */
//
//    // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
//    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        let animationCurve = UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
//    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
        var animationOptions = UIViewAnimationOptions.BeginFromCurrentState
//    if (animationCurve == UIViewAnimationCurveEaseIn) {
        if animationCurve == .EaseIn {
//        animationOptions |= UIViewAnimationOptionCurveEaseIn;
            animationOptions.unionInPlace(.CurveEaseIn)
//    }
//    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        } else if animationCurve == .EaseInOut {
//        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
            animationOptions.unionInPlace(.CurveEaseInOut)
//    }
//    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        } else if animationCurve == .EaseOut {
//        animationOptions |= UIViewAnimationOptionCurveEaseOut;
            animationOptions.unionInPlace(.CurveEaseOut)
//    }
//    else if (animationCurve == UIViewAnimationCurveLinear) {
        } else if animationCurve == .Linear {
//        animationOptions |= UIViewAnimationOptionCurveLinear;
            animationOptions.unionInPlace(.CurveLinear)
//    }
        }
//
//    [self.textView setNeedsUpdateConstraints];
        self.textView.setNeedsUpdateConstraints()
//
//    if (showKeyboard) {
        if showKeyboard {
//        UIDeviceOrientation orientation = self.interfaceOrientation;
            let orientation = UIDeviceOrientation(rawValue: self.interfaceOrientation.rawValue)!
//        BOOL isPortrait = UIDeviceOrientationIsPortrait(orientation);
            let isPortrait = UIDeviceOrientationIsPortrait(orientation)
//
//        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
            let keyboardFrameVal = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
//        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
            let keyboardFrame = keyboardFrameVal.CGRectValue()
//        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
            let height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width
//
//        // adjust the constraint constant to include the keyboard's height
//        self.constraintToAdjust.constant += height;
            self.constraintToAdjust.constant += height
//    }
//    else {
        } else {
//        self.constraintToAdjust.constant = 0;
            self.constraintToAdjust.constant = 0
//    }
        }
//
//    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
//
//    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: {
//        [self.view layoutIfNeeded];
            self.view.layoutIfNeeded()
//    } completion:nil];
        }, completion: nil)
//
//    // now that the frame has changed, move to the selection or point of edit
//    NSRange selectedRange = self.textView.selectedRange;
        let selectedRange = self.textView.selectedRange
//    [self.textView scrollRangeToVisible:selectedRange];
        self.textView.scrollRangeToVisible(selectedRange)
//}
    }
//
//- (void)keyboardWillShow:(NSNotification *)notification {
    @objc func keyboardWillShow(notification: NSNotification) {
//
//    /*
//     Reduce the size of the text view so that it's not obscured by the keyboard.
//     Animate the resize so that it's in sync with the appearance of the keyboard.
//     */
//
//    NSDictionary *userInfo = [notification userInfo];
        let userInfo = notification.userInfo!
//    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
        self.adjustTextViewByKeyboardState(true, keyboardInfo: userInfo)
//}
    }
//
//- (void)keyboardWillHide:(NSNotification *)notification {
    @objc func keyboardWillHide(notification: NSNotification) {
//
//    /*
//     Restore the size of the text view (fill self's view).
//     Animate the resize so that it's in sync with the disappearance of the keyboard.
//     */
//
//    NSDictionary *userInfo = [notification userInfo];
        let userInfo = notification.userInfo!
//    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
        self.adjustTextViewByKeyboardState(false, keyboardInfo: userInfo)
//}
    }
//
//
//#pragma mark - Accessory view action
//
//- (IBAction)tappedMe:(id)sender {
    @IBAction func tappedMe(_: UIButton) {
//
//    // when the accessory view button is tapped, add a suitable string to the text view
//    NSMutableString *text = [self.textView.text mutableCopy];
        let text = self.textView.text.mutableCopy() as! NSMutableString
//    NSRange selectedRange = self.textView.selectedRange;
        let selectedRange = self.textView.selectedRange
//
//    [text replaceCharactersInRange:selectedRange withString:@"\nYou tapped me."];
        text.replaceCharactersInRange(selectedRange, withString: "\nYou tapped me.")
//    self.textView.text = text;
        self.textView.text = text as String
//
//    [self adjustSelection:sender];
        self.adjustSelection(self.textView) //###
//}
    }
//
//@end
}