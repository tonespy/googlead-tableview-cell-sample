//
//  ViewController.swift
//  AdMobTest
//
//  Created by Abubakar Oladeji on 25/03/2019.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct DummyField {
    
    let fieldName: String
    let fieldAcre: String
    let fieldDiff: String
    
    static func generateDummyFields() -> [DummyField?] {
        var fields = [DummyField?]()
        
        fields.append(DummyField(fieldName: "Forth Des Moines Field", fieldAcre: "64.8 ac", fieldDiff: "Sun 5p - Sun 6p"))
        fields.append(DummyField(fieldName: "Third Des Moines Field", fieldAcre: "87.8 ac", fieldDiff: "Sun 5p - Sun 6p"))
        fields.append(DummyField(fieldName: "Second Des Moines Field", fieldAcre: "84.1 ac", fieldDiff: "Sun 5p - Sun 6p"))
        fields.append(nil)
        fields.append(DummyField(fieldName: "First Des Moines Field", fieldAcre: "77.4 ac", fieldDiff: "Sun 5p - Sun 6p"))
        
        return fields
    }
}

class ViewController: UIViewController {
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    var nativeAdView: GADUnifiedNativeAdView!
    
    /// The ad unit ID.
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    /// Cell ID
    let mainCellID = "field_list_cell_identifier"
    let adCellID = "field_list_ad_cell_identifier"
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let fieldList = DummyField.generateDummyFields()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        tableView.register(FieldListCell.self, forCellReuseIdentifier: mainCellID)
        tableView.register(AdFieldListCell.self, forCellReuseIdentifier: adCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchAds()
    }
    
    @IBAction func refereshAds(_ sender: UIButton) {
        fetchAds()
    }
    
    func fetchAds() {
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
                               adTypes: [ .unifiedNative ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

extension ViewController: GADUnifiedNativeAdLoaderDelegate, GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Ad loader came with results")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = fieldList[indexPath.row]
        
        if let currentItem = currentItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as! FieldListCell
            cell.fieldItem = currentItem
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: adCellID, for: indexPath) as! AdFieldListCell
        cell.controller = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentItem = fieldList[indexPath.row]
        
        if let _ = currentItem { return 100 }
        return 400
    }
}

class AdFieldListCell: UITableViewCell, GADUnifiedNativeAdLoaderDelegate, GADAdLoaderDelegate {
    
    let mainView: GoogleAdBannerView = {
        let view = GoogleAdBannerView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var controller: ViewController? {
        didSet {
            if let _ = controller {
                fetchAds()
            }
        }
    }
    
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    var adLoader: GADAdLoader!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        addSubview(mainView)
        
        mainView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        mainView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainView.refreshBtn.addTarget(self, action: #selector(refreshFieldAds(_:)), for: .touchUpInside)
    }
    
    private func fetchAds() {
        
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: controller!,
                               adTypes: [ .unifiedNative ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
//        let adRequest = GADRequest()
//        adRequest.testDevices = [kGADSimulatorID, "8bbb9713aa270c13a5b23b0a3702ccbe"]
//        adLoader.load(adRequest)
    }
    
    @IBAction func refreshFieldAds(_ sender: UIButton) {
        fetchAds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Ad loader came with results")
        
        mainView.nativeAd = nativeAd
        
        mainView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (mainView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        
        (mainView.headlineView as? UILabel)?.text = nativeAd.headline
    }
}

class FieldListCell: UITableViewCell {
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var fieldItem: DummyField! {
        didSet {
            headerTitle.text = fieldItem.fieldName
            subTitle.text = fieldItem.fieldAcre
            bottomText.text = fieldItem.fieldDiff
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        addSubview(headerTitle)
        addSubview(subTitle)
        addSubview(bottomText)
        
        headerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        headerTitle.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        headerTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        subTitle.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 8).isActive = true
        subTitle.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        subTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        bottomText.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        bottomText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
