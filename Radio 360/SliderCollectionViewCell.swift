//
//  SliderCollectionViewCell.swift
//  Radio 360
//
//  Created by hadi ali on 3/11/23.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    static let id: String = "SliderCollectionViewCell"
    static let nib: UINib = UINib(nibName: "SliderCollectionViewCell", bundle: nil)

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func bindCell(image: String) {
        DispatchQueue.main.async {
            self.imageView.image =  UIImage(named: image)
        }
        
    }

}
