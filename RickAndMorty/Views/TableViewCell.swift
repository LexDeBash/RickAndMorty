//
//  TableViewCell.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var chracterImageView: UIImageView! {
        didSet {
            chracterImageView.contentMode = .scaleAspectFit
            chracterImageView.clipsToBounds = true
            chracterImageView.layer.cornerRadius = chracterImageView.bounds.height/2
            chracterImageView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var chracterContentView: UIView! {
        didSet {
            chracterContentView.backgroundColor = .black
        }
    }
    
    // MARK: - Public methods
    func configure(with result: Result?) {
        nameLabel.text = result?.name
        DispatchQueue.global().async {
            guard let stringUrl = result?.image else { return }
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.chracterImageView.image = UIImage(data: imageData)
            }
        }
    }
}
