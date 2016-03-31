//
//  MyRecruitsTableViewCell.swift
//  MyRecruits
//
//  Created by Andrew Mogg on 11/29/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MyRecruitsTableViewCell: UITableViewCell {

    @IBOutlet var recruitPic: UIImageView!
    @IBOutlet var recruitName: UILabel!
    @IBOutlet var recruitHometown: UILabel!
    @IBOutlet var recruitGradYear: UILabel!
    @IBOutlet var recruitPosition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        
//        if( traitCollection.forceTouchCapability == .Available){
//            
//            registerForPreviewingWithDelegate(self, sourceView: view)
//            
//        }
        // Initialization code
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
