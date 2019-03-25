//
//  GoogleAdBannerView.swift
//  AdMobTest
//
//  Created by Abubakar Oladeji on 25/03/2019.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GoogleAdBannerView: GADUnifiedNativeAdView {
    
    let modMediaView: GADMediaView = {
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()
    
    let bannerImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let adTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let refreshBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Refresh", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
        mediaView = modMediaView
        iconView = bannerImageView
        headlineView = adTitle
        
        addSubview(mediaView!)
        addSubview(iconView!)
        addSubview(headlineView!)
        addSubview(refreshBtn)
        
        mediaView?.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        mediaView?.heightAnchor.constraint(equalToConstant: 160).isActive = true
        mediaView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mediaView?.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        iconView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView?.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        iconView?.topAnchor.constraint(equalTo: mediaView!.bottomAnchor, constant: 16).isActive = true
        
        headlineView?.leftAnchor.constraint(equalTo: iconView!.rightAnchor, constant: 16).isActive = true
        headlineView?.topAnchor.constraint(equalTo: iconView!.topAnchor).isActive = true
        headlineView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        refreshBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        refreshBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        refreshBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3, constant: -32).isActive = true
        refreshBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
}
