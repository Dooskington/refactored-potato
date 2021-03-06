//
//  ManageViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import AVFoundation

class ManageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var mainTopInfoBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainProductAnalyticWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var averageAgeLabel: UILabel!
    @IBOutlet weak var popularGenderLabel: UILabel!
    @IBOutlet weak var popularRaceLabel: UILabel!
    @IBOutlet weak var smileAverageLabel: UILabel!
    @IBOutlet weak var mainProductQuantityLabel: UILabel!
    @IBOutlet weak var mainProductBrandLabel: UILabel!
    @IBOutlet weak var mainProductImageView: UIImageView!
    @IBOutlet weak var mainProductNameLabel: UILabel!
    
    var productsInStock = [Product]()
    
    let downloader = ImageDownloader()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainProductAnalyticWidthConstraint.constant = UIScreen.main.bounds.size.width * 0.70
        mainTopInfoBarHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.30
        retrieveProducts()
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //Test Product
        /*
        let testProduct = Product(barcode: "234", name: "bullshit", brand: "test", price: 1.00)
        productsInStock+=[testProduct!]
        DispatchQueue.main.async{
            self.productsTableView.reloadData()
        }
        */
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveProducts()
    {
        Alamofire.request(Constants.API.ADDRESS + Constants.API.CALL_GET_PRODUCTS)
        .responseJSON()
        {
            response in
            debugPrint(response)
            switch response.result
            {
                case .success(let responseData):
                    let json = JSON(responseData).array;
                    for subJSON in json!
                    {
                        if let newProduct : Product = Product(json: subJSON)
                        {
                            print("Got product: \(newProduct.name!)")
                            self.productsInStock+=[newProduct]
                        }
                    }
                    
                    DispatchQueue.main.async{
                        self.productsTableView.reloadData()
                    }
                    
                    return
                
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    return
            }
        }
    }
    
    // MARK: TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.size.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsInStock.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageProductCell", for: indexPath) as! ManageProductTableViewCell
        let product = productsInStock[indexPath.row]
        cell.setLabels(newProduct: product)

        // Download the image
        Alamofire.request(product.imageUrl!).responseImage
        {
            response in
            
            if let image = response.result.value
            {
                print("image downloaded: \(image)")
                cell.productImageView!.image = response.result.value
                
                cell.productImageView.contentMode = UIViewContentMode.scaleAspectFit
                var newFrame = cell.productImageView.frame as CGRect
                newFrame.size.width = cell.frame.size.width * 0.15
                cell.productImageView.frame = newFrame
                cell.layoutSubviews()

                cell.setNeedsLayout()
            }
        }

        cell.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)

        if indexPath.row == 0
        {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        }
        
        var newFrame = cell.contentView.frame as CGRect
        newFrame.size.height = UIScreen.main.bounds.size.height * 0.10
        newFrame.origin.y = (newFrame.size.height - UIScreen.main.bounds.size.height * 0.25)/2
        cell.contentView.frame = newFrame
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.textColor = UIColor.white
        cell.brandLabel.textColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        cell.layer.cornerRadius = 0
        
        print(cell.nameLabel.text)
        
        //mainProductQuantityLabel: UILabel!
        //@IBOutlet weak var mainProductBrandLabel: UILabel!
        //@IBOutlet weak var mainProductImageView: UIImageView!
        //@IBOutlet weak var mainProductNameLabel:
        
        //mainProductQuantityLabel.text = pro
        mainProductBrandLabel.text = cell.brandLabel.text
        mainProductImageView.image = cell.productImageView.image
        mainProductNameLabel.text = cell.nameLabel.text
    }
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.textColor = UIColor(red:0.01, green:0.01, blue:0.01, alpha:1.0)
        cell.brandLabel.textColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 20

        return indexPath
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ManageProductTableViewCell
        
        cell.nameLabel.tintColor = UIColor.white
        cell.brandLabel.tintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        
        print(cell.nameLabel.text)
        
        var extensionFrame = cell.frame
        extensionFrame.origin.x=cell.frame.size.width + cell.frame.origin.x
        let cellExtension = UIView(frame: extensionFrame)
        cellExtension.backgroundColor = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
        cell.addSubview(cellExtension)
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func increaseStock(_ sender: UIButton) {
    }
    
    @IBAction func decreaseStock(_ sender: UIButton) {
    }

}
