//
//  BlurActionSheetCell.swift
//  BlurActionSheetDemo
//
//  Created by nathan on 15/4/23.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

import UIKit

class BlurActionSheetCell: UITableViewCell {

    let underLineColor = UIColor(white: 0.5, alpha: 0.7)
    
    var underLineView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        underLineView = UIView()
        underLineView.backgroundColor = underLineColor
        contentView.addSubview(underLineView)
        
        backgroundView = nil
        backgroundColor = UIColor.clearColor()
        selectedBackgroundView = UIView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.size.width
        let margin:CGFloat = 20
        
        if (underLineView.frame.size.height != 1){
            underLineView.frame = CGRectMake(margin, 0, width - margin * 2, 1)
        }
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            self.textLabel?.textColor = UIColor.lightGrayColor()
            underLineView.backgroundColor = underLineColor
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted){
            self.textLabel?.textColor = UIColor.lightGrayColor()
            underLineView.backgroundColor = underLineColor
        }
    }

}
