//
//  MainImageView.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/07.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit

class MainImageView: UITableViewHeaderFooterView {

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    
    func loadImage(url: String) {
        mainImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic_no_image.png"))
    }
}
