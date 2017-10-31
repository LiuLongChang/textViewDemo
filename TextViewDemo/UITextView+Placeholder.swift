//
//  UITextView+Placeholder.swift
//  TextViewDemo
//
//  Created by zgzzzs on 2017/10/30.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import Foundation
import UIKit


var placeholderKey = "\(3)"
var placeholderColorKey = "\(4)"
var placeholderLabelKey = "\(5)"
var maxInputLengthKey = "\(6)"


extension UITextView:SelfAware{

    static func awake() {UITextView.classInit()}
    static func classInit(){swizzleMethod}

    func setPlaceholder(placeholder:NSString){
        objc_setAssociatedObject(self, &placeholderKey, placeholder, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.setNeedsDisplay()
    }

    func placeholder()->NSString{
        return objc_getAssociatedObject(self, &placeholderKey) as! NSString
    }

    func setPlaceholderAttributes(placeholderAttributes:NSDictionary){
        objc_setAssociatedObject(self, &placeholderColorKey, placeholderAttributes, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.setNeedsDisplay()
    }

    func placeholderAttributes()->NSDictionary{
        return objc_getAssociatedObject(self, &placeholderColorKey) as! NSDictionary
    }

    func setPlaceholderLabel(placeholderLabel:UILabel){
        objc_setAssociatedObject(self, &placeholderLabelKey, placeholderLabel, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func placeholderLabel() -> UILabel {
        return objc_getAssociatedObject(self, &placeholderLabelKey) as! UILabel
    }

    func setMaxInputLength(maxInputLength:NSInteger) -> Void {
        objc_setAssociatedObject(self, &maxInputLengthKey, maxInputLength, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func maxInputLength() -> NSInteger {
        let inputNumber : NSInteger = objc_getAssociatedObject(self, &maxInputLengthKey) as! NSInteger
        return inputNumber
    }


    @objc func swizzled_textViewDidChangeNotification(noti:NSNotification){
        self.setNeedsDisplay()
        if self.maxInputLength() <= 0 {
            return;
        }
        let inputMethodType = UIApplication.shared.textInputMode?.primaryLanguage;
        //如果当前输入法为汉语输入法
        if inputMethodType == "zh-Hans" {
            //获取选中部分
            let selectedRange = self.markedTextRange
            //获取选中部分的偏移量 此部分为用户为决定输入部分
            let position = self.position(from: (selectedRange?.start)!, offset: 0)
            //当没有标记部分时截取字符串
            if position == nil {
                self.text = self.textViewCurrentText() as String!
            }
        }else{
            self.text = self.textViewCurrentText() as String!
        }
    }

    func textViewCurrentText()->NSString{
        let selfLength = self.text.characters.count;
        let maxInput = self.maxInputLength();
        return (selfLength > maxInput) ? (NSString.init(string: self.text).substring(to: maxInput) as NSString) : NSString.init(string:self.text);
    }

    @objc func swizzled_drawRect(_ rect:CGRect){
        if self.hasText {return;}
        /*placeholder文字的描绘情况跟自身的text属性相关 所以要重写set方法去调用drawRect方法(setNeedsDisplay)*/
        var rectNow = rect;
        rectNow.origin.x = 5;
        rectNow.origin.y = 7;
        rectNow.size.width -= 2*rectNow.origin.x;
        self.placeholder().draw(in: rectNow, withAttributes: self.placeholderAttributes() as? [NSAttributedStringKey : Any]);
    }


    @objc func swizzled_setText(str:String!){
        self.swizzled_setText(str: str)
        self.setNeedsDisplay()
    }

    @objc func swizzled_setFont(font:CGFloat){
        self.swizzled_setFont(font: font)
        self.setNeedsDisplay()
    }

    @objc func swizzled_setAttribute(str:NSAttributedString){
        self.swizzled_setAttribute(str: attributedText)
        self.setNeedsDisplay()
    }



    private static let swizzleMethod: Void = {

//        let originalSelector = #selector(UITextView.init(frame:));
//        let swizzledSelector = #selector(UITextView.swizzled_init(frame:));
//        swizzlingForClassNow(UITextView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector);

        let originalSelector0 = #selector(UITextView.draw(_:));
        let swizzledSelector0 = #selector(UITextView.swizzled_drawRect(_:));
        swizzlingForClassNow(UITextView.self, originalSelector: originalSelector0, swizzledSelector: swizzledSelector0)


        let originalSelector1 = #selector(setter: UITextView.text)
        let swizzledSelector1 = #selector(UITextView.swizzled_setText)
        swizzlingForClassNow(UITextView.self, originalSelector: originalSelector1, swizzledSelector: swizzledSelector1)


        let originalSelector2 = #selector(setter: UITextView.font);
        let swizzledSelector2 = #selector(UITextView.swizzled_setFont(font:));
        swizzlingForClassNow(UITextView.self, originalSelector: originalSelector2, swizzledSelector: swizzledSelector2);



        let originalSelector3 = #selector(setter: UITextView.attributedText);
        let swizzledSelector3 = #selector(UITextView.swizzled_setAttribute(str:));
        swizzlingForClassNow(UITextView.self, originalSelector: originalSelector3, swizzledSelector: swizzledSelector3)
    }()

    private static func swizzlingForClassNow(_ forClass:AnyClass,originalSelector:Selector,swizzledSelector:Selector){

        let originalMethod = class_getInstanceMethod(forClass, originalSelector);
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector);
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return;
        }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        }else{
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }




}




extension UIViewController:SelfAware{

    static func awake() {
        UIViewController.classInit()
    }
    static func classInit(){
        swizzleMethod
    }
    @objc func swizzled_viewWillAppear(_ animated:Bool){
        swizzled_viewWillAppear(animated);
        print("swizzled_viewWillAppear")
    }

    private static let swizzleMethod: Void = {
        let originalSelector = #selector(viewWillAppear(_:));
        let swizzledSelector = #selector(swizzled_viewWillAppear(_:));
        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector);
    }()

    private static func swizzlingForClass(_ forClass: AnyClass,originalSelector:Selector,swizzledSelector:Selector){

        let originalMethod = class_getInstanceMethod(forClass, originalSelector);
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector);

        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }

        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!));
        }else{
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }

    }

}





extension UITextView{
    /*不想定义变量 只想保证某一段代码只执行一次*/
    static let doOneTime : Void = {
        print("Just do one time");
    }()
    /*通过调用一个参数来执行一些代码有些奇怪 可以在外面再包一层函数*/
    static func doOneTimeFunction(){
        doOneTime
    }
}





