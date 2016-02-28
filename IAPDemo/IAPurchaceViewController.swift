//
//  IAPurchaceViewController.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import StoreKit


protocol IAPurchaceViewControllerDelegate {
    
    func didBuyColorsCollection(collectionIndex: Int)
    
}

class IAPurchaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var delegate: IAPurchaceViewControllerDelegate!
    
    var productIDs: Array<String!> = []
    
    var productsArray: Array<SKProduct!> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    

    @IBOutlet weak var tblProducts: UITableView!
   
    
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                delegate.didBuyColorsCollection(selectedProductIndex)
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblProducts.delegate = self
        tblProducts.dataSource = self
        
        
        productIDs.append("MyFirstPushes")
        productIDs.append("MyTestPurshesSecond")
        
        requestProductInfo()
        
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            print("There are no products.")
        }
        
        
        if response.invalidProductIdentifiers.count > 0 {
            print(response.invalidProductIdentifiers.description)
        }
        
        tblProducts.reloadData()
    }
    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIndentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIndentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        } else  {
            print("Cannot perform In App Purchases")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: IBAction method implementation
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITableView method implementation
    
    
    
    func showAction() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "IAPDemo", message: "What do you want to dp?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as SKProduct)
            
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProductIndex = indexPath.row
        showAction()
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(productsArray.count)
        return productsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let product = productsArray[indexPath.row]
        
        cell.textLabel?.text = product.localizedTitle
        cell.detailTextLabel?.text = product.localizedDescription
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
}
