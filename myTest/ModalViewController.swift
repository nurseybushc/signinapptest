//
//  ModalViewController.swift
//  myTest
//
//  Created by APS Mac 1 on 11/1/15.
//  Copyright © 2015 APS Mac 1. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func login(sender: UIButton) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertController = UIAlertController(title: "Sign in Failed", message: "Please enter Username and Password", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                print("The user is okay.")
            }
            alertController.addAction(yesAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        } else {
            
            do {
                let post:NSString = "username=\(username)&password=\(password)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string:"http://ec2-54-68-228-124.us-west-2.compute.amazonaws.com/loginDoctor2.php")!
                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength:NSString = String( postData.length )
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData?
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        NSLog("Response ==> %@", responseData);
                        
                        //var error: NSError?
                        
                        let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        
                        
                        let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                            NSLog("Login SUCCESS");
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.synchronize()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            
                            /*let alertView:UIAlertView = UIAlertView()
                            alertView.title = "Sign in Failed!"
                            alertView.message = error_msg as String
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()*/
                            
                            let alertController = UIAlertController(title: "Sign in Failed", message: error_msg as String, preferredStyle: .Alert)
                            
                            let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                                print("The user is okay.")
                            }
                            alertController.addAction(yesAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                        }
                        
                    } else {
                        /*let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Connection Failed"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()*/
                        let alertController = UIAlertController(title: "Sign in Failed", message: "Connection failed", preferredStyle: .Alert)
                        
                        let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                            print("The user is okay.")
                        }
                        alertController.addAction(yesAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                } else {
                    /*let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failure"
                    if let error = reponseError {
                        alertView.message = (error.localizedDescription)
                    }
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()*/
                    
                    let errorMessage = "Error"
                    /*if let error = responseError {
                        errorMessage = error.localizedDescription
                    }*/
                    let alertController = UIAlertController(title: "Sign in Failed", message: errorMessage, preferredStyle: .Alert)
                    
                    let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                        print("The user is okay.")
                    }
                    alertController.addAction(yesAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } catch {
                /*let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Server Error"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()*/
                
                let alertController = UIAlertController(title: "Sign in Failed", message: "Server Error", preferredStyle: .Alert)
                
                let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("The user is okay.")
                }
                alertController.addAction(yesAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
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

}
