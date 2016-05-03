//
//  EditSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class EditSetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var cards = [NSManagedObject]()

    let reuseIdentifier = "cardEditId"
    var setName =  ""
    var setId = -1
    var set:NSManagedObject? = nil
    var listOfCards = [Card]()
    let idCounter = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Edit Set"
        setNameTextField.text = setName
        tableView.alwaysBounceVertical = false
        attatchKeyboardToolbar(setNameTextField)
        setNameTextField.delegate = self
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        getCards()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Card")
        
        var fetchedResults:[NSManagedObject]? = nil
                
        do {
            fetchRequest.predicate = NSPredicate(format: "setId == %d", setId)
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            cards = results
        } else {
            print("Could not fetch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfCards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EditSetTableViewCell
        
        let card = listOfCards[indexPath.row]
        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        attatchKeyboardToolbar(cell.front)
        attatchKeyboardToolbar(cell.back)
        cell.front.userInteractionEnabled = false
        if(card.newCard) {
            cell.front.becomeFirstResponder()
        }
        cell.front.userInteractionEnabled = true
        return cell
    }
    
    func attatchKeyboardToolbar(textField : UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addCard = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditSetTableViewController.addCardBtn(_:)))
        let font = UIFont(name: "Helvetica", size: 35)
        addCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        addCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace]
        textField.inputAccessoryView = toolbar
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let cardId = (idCounter.objectForKey("numCards") as? Int)!
        let createdCard = Card(front: String(), back: String(), id: cardId, setId: setId, edited: false, newCard: true)
        idCounter.setObject(cardId + 1, forKey: "numCards")

        createdCard.newCard = true
        listOfCards.append(createdCard)
        tableView.reloadData()
    }
    
    func saveNewCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Card")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        for cardToSave in listOfCards {
            // print("Card: \(cardToSave.id) Front: \(cardToSave.front) Back: \(cardToSave.back) SetId: \(cardToSave.setId) New?: \(cardToSave.newCard)")
            if (cardToSave.edited && !cardToSave.newCard) {
                
                do {
                    fetchRequest.predicate = NSPredicate(format: "id == %d AND setId == %d", cardToSave.id, setId)
                    try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                } catch {
                    // what to do if an error occurs?
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                
                if let results = fetchedResults {
                    if(results.count > 0) {
                        let card = results[0]
                        
                        // Save or delete card
                        if(cardToSave.front == "" && cardToSave.back == "") {
                            managedContext.deleteObject(card)
                        } else {
                            card.setValue(cardToSave.front, forKey: "front")
                            card.setValue(cardToSave.back, forKey: "back")
                            cardToSave.edited = false
                        }
                    }
                } else {
                    print("Could not fetch")
                }
            } else if (cardToSave.newCard && !(cardToSave.front == "" && cardToSave.back == "")) {
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
                
                let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                card.setValue(cardToSave.front, forKey: "front")
                card.setValue(cardToSave.back, forKey: "back")
                card.setValue(cardToSave.id, forKey: "id")
                card.setValue(cardToSave.setId, forKey: "setId")
                cardToSave.edited = false
                cardToSave.newCard = false
            }
        }

        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // MARK: - Image Storage
    
//    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
//    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
//        
//        // create url request to send
//        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
//        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
//        let boundaryConstant = "myRandomBoundary12345";
//        let contentType = "multipart/form-data;boundary="+boundaryConstant
//        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        
//        
//        // create upload data to send
//        let uploadData = NSMutableData()
//        
//        // add image
//        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData(imageData)
//        
//        // add parameters
//        for (key, value) in parameters {
//            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
//        }
//        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        
//        
//        // return URLRequestConvertible and NSData
//        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
//    }
//    
//    func sendImage(){
//        
////        let docDir:AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
////        let imagePath = (docDir as! String) + "/turtle.jpg"
////        
////        var imageData = UIImage.init(contentsOfFile: imagePath)
////        
////        var parameters = [
////            "pic"           :NetData(pngImage: UIImage(named:"pic-04")!, filename: "pic-o4.png"),
////            "otherParm"     :"Value"
////        ]
////        
////        print(parameters)
////        let urlRequest = self.urlRequestWithComponents("https://shielded-basin-17847.herokuapp.com/upload", parameters: parameters)
//
//        // init paramters Dictionary
//        var parameters = [
//            "task": "task",
//            "variable1": "var"
//        ]
//
//        // add addtionial parameters
//        parameters["userId"] = "27"
//        parameters["body"] = "This is the body text."
//
//        // example image data
//        let image = UIImage(named: "pic-04.png")
//        let imageData = UIImagePNGRepresentation(image!)
//
//
//        // CREATE AND SEND REQUEST ----------
//
//        let urlRequest = urlRequestWithComponents("https://shielded-basin-17847.herokuapp.com/upload", parameters: parameters, imageData: imageData!)
//        Alamofire.upload(urlRequest.0, data: urlRequest.1).progress{ (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//            print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//        }.responseJSON { (response) in
//            print("REQUEST \(response.request)")
//            print("RESPONSE \(response.response)")
//            print("JSON \(response.debugDescription)")
//
//        }
//        
//    }
//    
//    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
//        
//        // create url request to send
//        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
//        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
//        //let boundaryConstant = "myRandomBoundary12345"
//        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
//        let contentType = "multipart/form-data;boundary="+boundaryConstant
//        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        
//        
//        // create upload data to send
//        let uploadData = NSMutableData()
//        
//        // add parameters
//        for (key, value) in parameters {
//            print("here")
//            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            
//            if value is NetData {
//                // add image
//                var postData = value as! NetData
//                print("here2")
//                
//                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//                
//                // append content disposition
//                var filenameClause = " filename=\"\(postData.filename)\""
//                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
//                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
//                uploadData.appendData(contentDispositionData!)
//                
//                
//                // append content type
//                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
//                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
//                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
//                uploadData.appendData(contentTypeData!)
//                uploadData.appendData(postData.data)
//                
//            }else{
//                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
//            }
//        }
//        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        
//        print("return")
//        // return URLRequestConvertible and NSData
//        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
//    }
    
    @IBAction func addPIC(sender: AnyObject) {
        print ("save image")
//        self.sendImage()
        let URL = "https://shielded-basin-17847.herokuapp.com/upload"
        
        // example image data
        let image = UIImage(named: "pic-04.png")
        let imageData = UIImagePNGRepresentation(image!)
        
        let postDataProlife:[String:AnyObject] = ["CardId": 1,"ImageType": 1,"ImageData": imageData!]
        let parameters = [
            "CardId": 1,
            "ImageType": 1,
            "front": "hey",
            "back": "you",
            "ImageData": imageData!
        ]
        
        uplaodImageData(URL, postData: parameters, successHandler: successDataHandler, failureHandler: failureDataHandler)
    }
    
    func successDataHandler(responseData:String){
        
        print ("IMAGE UPLOAD SUCCESSFUL    !!!")
        
    }
    
    func failureDataHandler(errorData:String){
        
        print ("  !!!   IMAGE UPLOAD FAILURE   !!! ")
        
    }
    
    
    func uplaodImageData(RequestURL: String,postData:[String:AnyObject]?,successHandler: (String) -> (),failureHandler: (String) -> ()) -> () {
        
//        let headerData:[String : String] = ["Content-Type":"application/json"]
        
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
//        Alamofire.request(.POST, "https://shielded-basin-17847.herokuapp.com/upload", headers: headers, parameters: parameters, encoding: .JSON)

        
        Alamofire.request(.POST,RequestURL, parameters: postData, headers: headers).responseString{ response in
            switch response.result {
            case .Success:
                print(response.response?.statusCode)
                print(response.response?.debugDescription)
                successHandler(response.result.value!)
            case .Failure(let error):
                failureHandler("\(error)")
            }
        }
    }
    
    // MARK: - Segue
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SetTableViewController {
            destination.setName = setNameTextField.text!
            destination.setId = setId
            self.view.endEditing(true)
            
            saveNewCards()
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
