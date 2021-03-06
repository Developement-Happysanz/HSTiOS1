//
//  CashMethod.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CashMethod: UIViewController
{
    @IBOutlet weak var payOnlineOutlet: UIButton!
    @IBOutlet weak var payCashOutlet: UIButton!
    
    var order_id = String()
    var payable_amount = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    override func viewWillLayoutSubviews() {
        payOnlineOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
        payCashOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "paymentmethodavtitle_text", comment: "")
        self.payOnlineOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "paymentmethodonline_text", comment: ""), for: .normal)
        self.payCashOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "paymentmethodcash_text", comment: ""), for: .normal)
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payOnlineAction(_ sender: Any)
    {
        UserDefaults.standard.set("Cp", forKey: "Advance/customer")
        UserDefaults.standard.set("NO", forKey: "PaybyCash")
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CCWebViewController") as! CCWebViewController
        viewController.accessCode = "AVQM86GG76CA98MQAC"
        viewController.merchantId = "225068"
        viewController.amount = payable_amount
        // advance_amount
        viewController.currency = "INR"
        viewController.orderId = order_id
        
        viewController.redirectUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/service_net_amount.php")
        viewController.cancelUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/service_net_amount.php")
        viewController.rsaKeyUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/GetRSA.php")
        
//        viewController.redirectUrl = "https://www.skilex.in/development/ccavenue_app/service_net_amount.php"
//        viewController.cancelUrl = "https://www.skilex.in/development/ccavenue_app/service_net_amount.php"
//        viewController.rsaKeyUrl = "https://www.skilex.in/development/ccavenue_app/GetRSA.php"
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func payCashAction(_ sender: Any)
    {
        self.webRequestPayCash()
    }
    
    func webRequestPayCash ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"order_id":order_id,"amount":payable_amount]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "pay_by_cash", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        print("%@",msg)
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if status == "success"{
                            self.servicePaymentSuccess(order_id: GlobalVariables.shared.order_id)
                            UserDefaults.standard.set("YES", forKey: "PaybyCash")
                            let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cCResultViewController") as! CCResultViewController
                            self.present(nextViewController, animated:true, completion:nil)
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                }
                            }
                        }
                    }) {
                        (error) -> Void in
                        print(error)
                    }
                }
                catch
                {
                    print("Unable to load data: \(error)")
                }
        }
    }
    
     func servicePaymentSuccess(order_id:String)
        {
            let parameters = ["order_id":order_id]
    //                  MBProgressHUD.showAdded(to: self.view, animated: true)
                      DispatchQueue.global().async
                          {
                              do
                              {
                                  try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_payment_success", params: (parameters ), headers: nil, success:
                                  {
                                      (JSONResponse) -> Void in
    //                                  MBProgressHUD.hide(for: self.view, animated: true)
    //                                  let json = JSON(JSONResponse)
    //                                  let msg = json["msg"].stringValue
    //                                  let msg_en = json["msg_en"].stringValue
    //                                  let msg_ta = json["msg_ta"].stringValue
    //                                  let status = json["status"].stringValue
    //                                  if msg == "Login Successfully" && status == "success"
    //                                  {
    //
    //                                  }
    //                                  else
    //                                  {
    //
    //                                  }
                                  }) {
                                      (error) -> Void in
                                      print(error)
                                  }
                              }
                              catch
                              {
                                  print("Unable to load data: \(error)")
                              }
                      }
        }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Home")
        {
            let _ = segue.destination as! Tabbarcontroller
        }
    }
    

}
