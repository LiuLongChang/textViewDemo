//
//  ViewController.swift
//  TextViewDemo
//
//  Created by zgzzzs on 2017/10/30.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit






class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let textField = UITextView.init(frame: CGRect.init(x: 10, y: 100, width: 300, height: 100))
        NotificationCenter.default.addObserver(textField, selector: #selector(UITextView.swizzled_textViewDidChangeNotification(noti:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil);
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.font = UIFont.systemFont(ofSize: 16);
        textField.setPlaceholder(placeholder: "请输入您的意见反馈")
        textField.setPlaceholderAttributes(placeholderAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.init(red: 175/255.0, green: 175/255.0, blue: 175/255.0, alpha: 1)])
        textField.setMaxInputLength(maxInputLength: 30)
        self.view.addSubview(textField)
        print("%d",textField.placeholder());

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("viewWillAppear");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
