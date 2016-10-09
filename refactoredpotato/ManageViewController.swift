//
//  ManageViewController.swift
//  refactoredpotato
//
//  Created by Declan Hopkins on 10/8/16.
//  Copyright © 2016 Ancient Archives. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainProductAnalyticWidthConstraint.constant = UIScreen.main.bounds.size.width * 0.70
        mainTopInfoBarHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.30
        retrieveProducts()
        
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
                    let json = JSON(responseData);
                    let productsJSON = json["products"].array
                    
                    for subJSON in productsJSON!
                    {
                        if let newProduct : Product = Product(json: subJSON)
                        {
                            print("Got product: \(newProduct.name!)")
                            self.productsInStock+=[newProduct]
                        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsInStock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ManageProductTableViewCell
        cell.setLabels(newProduct: productsInStock[indexPath.row])
        
        return cell
    }
    
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
