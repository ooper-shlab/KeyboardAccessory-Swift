//
//  ViewController.swift
//  KeyboardAccessory
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/12/28.
//
//
//
/*
     File: ViewController.h
     File: ViewController.m
 Abstract: View controller that adds a keyboard accessory to a text view.

  Version: 1.5

 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Copyright (C) 2014 Apple Inc. All Rights Reserved.

 */

import UIKit

@objc(ViewController)
class ViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var accessoryView: UIView! // view placed on top of keyboard
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // the height constraint we want to change when the keyboard shows/hides
    @IBOutlet weak var constraintToAdjust: NSLayoutConstraint!
    
    
    //MARK: -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set the right bar button item initially to "Edit" state
        self.navigationItem.rightBarButtonItem = self.editButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // observe keyboard hide and show notifications to resize the text view appropriately
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
        // start editing the UITextView (makes the keyboard appear when the application launches)
        self.editAction(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillChangeFrame,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.adjustSelection(self.textView)
    }
    
    
    //MARK: - Actions
    
    @IBAction func doneAction(_: Any) {
        
        // user tapped the Done button, release first responder on the text view
        self.textView.resignFirstResponder()
    }
    
    @IBAction func editAction(_: Any) {
        
        // user tapped the Edit button, make the text view first responder
        self.textView.becomeFirstResponder()
    }
    
    
    //MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        // note: you can create the accessory view programmatically (in code), or from the storyboard
        if self.textView.inputAccessoryView == nil {
            
            self.textView.inputAccessoryView = self.accessoryView  // use what's in the storyboard
        }
        
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        return true
    }
    
    func textViewShouldEndEditing(_ aTextView: UITextView) -> Bool {
        
        aTextView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = self.editButton
        
        return true
    }
    
    private func adjustSelection(_ textView: UITextView) {
        
        // workaround to UITextView bug, text at the very bottom is slightly cropped by the keyboard
        textView.layoutIfNeeded()
        var caretRect = textView.caretRect(for: textView.selectedTextRange!.end)
        caretRect.size.height += textView.textContainerInset.bottom
        textView.scrollRectToVisible(caretRect, animated: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.adjustSelection(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        self.adjustSelection(textView)
    }
    
    
    //MARK: - Responding to keyboard events
    
    private func adjustTextViewByKeyboardState(_ showKeyboard: Bool, keyboardInfo info: [AnyHashable: Any]) {
        
        /*
         Reduce the size of the text view so that it's not obscured by the keyboard.
         Animate the resize so that it's in sync with the appearance of the keyboard.
         */
        
        // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
        let animationCurve = UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
        var animationOptions = UIViewAnimationOptions.beginFromCurrentState
        if animationCurve == .easeIn {
            animationOptions.formUnion(.curveEaseIn)
        } else if animationCurve == .easeInOut {
            animationOptions.formUnion(UIViewAnimationOptions())
        } else if animationCurve == .easeOut {
            animationOptions.formUnion(.curveEaseOut)
        } else if animationCurve == .linear {
            animationOptions.formUnion(.curveLinear)
        }
        
        self.textView.setNeedsUpdateConstraints()
        
        if showKeyboard {
            let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
            
            let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width
            
            // adjust the constraint constant to include the keyboard's height
            self.constraintToAdjust.constant += height
        } else {
            self.constraintToAdjust.constant = 0
        }
        
        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        // now that the frame has changed, move to the selection or point of edit
        let selectedRange = self.textView.selectedRange
        self.textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        /*
         Reduce the size of the text view so that it's not obscured by the keyboard.
         Animate the resize so that it's in sync with the appearance of the keyboard.
         */
        
        let userInfo = notification.userInfo!
        self.adjustTextViewByKeyboardState(true, keyboardInfo: userInfo)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        /*
         Restore the size of the text view (fill self's view).
         Animate the resize so that it's in sync with the disappearance of the keyboard.
         */
        
        let userInfo = notification.userInfo!
        self.adjustTextViewByKeyboardState(false, keyboardInfo: userInfo)
    }
    
    
    //MARK: - Accessory view action
    
    @IBAction func tappedMe(_: UIButton) {
        
        // when the accessory view button is tapped, add a suitable string to the text view
        let text = self.textView.text ?? ""
        let selectedRange = Range(self.textView.selectedRange, in: text)!
        
        self.textView.text = text.replacingCharacters(in: selectedRange, with: "\nYou tapped me.")
        
        self.adjustSelection(self.textView) //###
    }
    
}
