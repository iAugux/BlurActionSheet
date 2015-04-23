//
//  ViewController.swift
//  BlurActionSheetDemo
//
//  Created by nathan on 15/4/23.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func buttonClick(sender: AnyObject) {
        
        let titles = ["commit","reload image","save image","copy image","share image","cancel"]
        
        BlurActionSheet.showWithTitles(titles, handler: { (index) -> Void in
            
            println("selected at \(index)")
        })
        
    }
    
}

