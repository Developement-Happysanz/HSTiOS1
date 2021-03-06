//
//  OnGoing Service.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OnGoing_Service: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var serviceListArr = [ServiceList]()
    @IBOutlet weak var tableView: UITableView!
    var sevice_order_id = String()
    var orderStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        //self.webRequestOngoingServiceList(user_master_id: GlobalVariables.shared.user_master_id)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.webRequestOngoingServiceList(user_master_id: GlobalVariables.shared.user_master_id)
        self.preferedLanguage()
    }
    
    func preferedLanguage () {
         self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ongoingservicenavtitle_text", comment: "")
    }

    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webRequestOngoingServiceList(user_master_id: String) {
        let parameters = ["user_master_id": user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "ongoing_services", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service found" && status == "success"{
                           
                            if json["service_list"].count > 0 {
                                
                                self.serviceListArr = []
                                
                                for i in 0..<json["service_list"].count {
                                    
                                    let services = ServiceList.init(json: json["service_list"][i])
                                    self.serviceListArr.append(services)
                                }
                                    self.tableView.reloadData()
                            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OngoingServiceTableViewCell
        let serviceList = serviceListArr[indexPath.row]
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            cell.mainCategoery.text = serviceList.main_category
            cell.subCategoery.text = serviceList.service_name
            cell.customerName.text = serviceList.contact_person_name
            cell.serviceDate.text = serviceList.order_date
                        
            if serviceList.order_status == "Hold"
            {
                cell.statusView.backgroundColor = UIColor.init(red: 238/255.0, green: 25/255.0, blue: 37/255.0, alpha: 1.0)
                cell.statusImg.image = UIImage(named: "onhold")
                if serviceList.order_status == "Accepted"
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusapproved_text", comment: "")
                }
                else if serviceList.order_status == "Assigned"
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusassigned_text", comment: "")
                }
                else
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusongoing_text", comment: "")
                }
            }
            else
            {
                cell.statusView.backgroundColor = UIColor.init(red: 174/255.0, green: 132/255.0, blue: 187/255.0, alpha: 1.0)
                cell.statusImg.image = UIImage(named: "ios_icons-27")
                if serviceList.order_status == "Accepted"
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusapproved_text", comment: "")
                }
                else if serviceList.order_status == "Assigned"
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusassigned_text", comment: "")
                }
                else
                {
                    cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusongoing_text", comment: "")
                }
            }

        }
        else
        {
            cell.mainCategoery.text = serviceList.main_category_ta
            cell.subCategoery.text = serviceList.service_ta_name
            cell.customerName.text = serviceList.contact_person_name
            cell.serviceDate.text = serviceList.order_date
            
            if serviceList.order_status == "Hold"
            {
               cell.statusView.backgroundColor = UIColor.init(red: 238/255.0, green: 25/255.0, blue: 37/255.0, alpha: 1.0)
               cell.statusImg.image = UIImage(named: "onhold")
               if serviceList.order_status == "Accepted"
               {
                  cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusapproved_text", comment: "")
               }
               else if serviceList.order_status == "Assigned"
               {
                 cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusassigned_text", comment: "")
               }
               else
               {
                 cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusongoing_text", comment: "")
               }
            }
            else
            {
               cell.statusView.backgroundColor = UIColor.init(red: 174/255.0, green: 132/255.0, blue: 187/255.0, alpha: 1.0)
               cell.statusImg.image = UIImage(named: "ios_icons-27")
               if serviceList.order_status == "Accepted"
               {
                  cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusapproved_text", comment: "")
               }
               else if serviceList.order_status == "Assigned"
               {
                 cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusassigned_text", comment: "")
               }
               else
               {
                 cell.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingstatusongoing_text", comment: "")
               }
//             cell.statusLabel.text = String(format: "%@ %@", "சேவை நிலை : ",serviceList.order_status!)
            }
            
        }
        
        cell.cellView.dropShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = serviceListArr[indexPath.row]
        if index.order_status == "Started"
        {
            self.sevice_order_id = index.service_order_id!
            self.orderStatus = "Started"
            self.performSegue(withIdentifier: "serviceSummaryPage", sender: self)
        }
        else if index.order_status == "Ongoing"
        {
            self.sevice_order_id = index.service_order_id!
            self.orderStatus = "onGoing"
            self.performSegue(withIdentifier: "serviceSummaryPage", sender: self)
        }
        else
        {
            self.sevice_order_id = index.service_order_id!
            self.webRequestOngoingServiceOrderDetails(service_order_id: index.service_order_id!)
        }
    }
    
    func webRequestOngoingServiceOrderDetails(service_order_id: String) {
        let parameters = ["service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_details", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service found" && status == "success"{
                            
                            if json["service_list"].count > 0 {
                                let servicesDetail = ServicesListDetail(json: json["service_list"])
                                UserDefaults.standard.saveServicesDetail(servicesListDetail: servicesDetail)
                                self.performSegue(withIdentifier: "ongoingservicesDetail", sender: self)
                            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ongoingservicesDetail"){
            let vc = segue.destination as! OngoingServicesDetail
            vc.serviceorderId = sevice_order_id
        }
        else if (segue.identifier == "serviceSummaryPage")
        {
            let vc = segue.destination as! ServiceSummaryDetail
            vc.service_order_id = self.sevice_order_id
            vc.viewFrom = self.orderStatus
        }
    }

}
