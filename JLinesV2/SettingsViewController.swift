//
//  SettingsViewController.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 11.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    var backButton = UIButton()
    var languageButton = MyButton()
    var clearButton = MyButton()
    var pickerData: [[String]] = []
    let chooseView = UIPickerView()
    var goWhenEnd: ()->()


    init(callBack: ()->()) {
        goWhenEnd = callBack
        super.init(nibName: nil, bundle: nil)
        GV.language.callBackWhenNewLanguage(self.updateLanguage)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        languageButton.frame = CGRect(x:0,y:100,width:200,height: 30)
        //languageButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        languageButton.setTitle(GV.language.getText("language"), forState: .Normal)
        //languageButton.setTitleShadowColor(UIColor.blueColor(), forState: .Normal)
        languageButton.addTarget(self, action: "chooseLanguage:", forControlEvents: .TouchUpInside)
        languageButton.setupDepression()
        languageButton.moveToCenter(self.view.frame)
        
        clearButton.frame = CGRect(x:0,y:150,width:200,height: 30)
        //clearButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        clearButton.setTitle(GV.language.getText("cleangame"), forState: .Normal)
        clearButton.addTarget(self, action: "clearGame:", forControlEvents: .TouchUpInside)
        clearButton.moveToCenter(self.view.frame)
        
        let back = UIImage(named: "back.jpg") as UIImage?
        backButton.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.size.width - 20, y: self.view.frame.origin.y + 40, width: 20, height: 20)
        backButton.setImage(back, forState: .Normal)
        backButton.backgroundColor = UIColor.lightGrayColor()
        //backButton.setTitle(GV.language.getText("x"), forState: .Normal)
        backButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)

        chooseView.delegate = self
        chooseView.dataSource = self
        self.view.addSubview(languageButton)
        self.view.addSubview(clearButton)
        self.view.addSubview(backButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func endSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {self.goWhenEnd()})
    }
    
    
    func chooseLanguage(sender: UIButton) {
        chooseView.frame.origin.y = self.view.frame.size.height / 2
        chooseView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(chooseView)
        pickerData.append(GV.language.getLanguages())
    }
    
    func clearGame(sender: UIButton) {
        var clearGameAlert:UIAlertController
        var messageTxt = GV.language.getText("areYouSure")

        clearGameAlert = UIAlertController(title: GV.language.getText("cleangame"),
            message: messageTxt,
            preferredStyle: .Alert)
        
        let firstAction = UIAlertAction(title: GV.language.getText("yes"),
            style: UIAlertActionStyle.Default,
            handler: {(paramAction:UIAlertAction!) in
                GV.dataStore.deleteAllRecords()
                println("Anzahl Records:\(GV.dataStore.getCountRecords())")
            }
        )
        
        let secondAction = UIAlertAction(title: GV.language.getText("no"),
            style: UIAlertActionStyle.Cancel,
            handler: {(paramAction:UIAlertAction!) in
                
            }
            
        )
        
        clearGameAlert.addAction(firstAction)
        clearGameAlert.addAction(secondAction)
        presentViewController(clearGameAlert,
            animated:true,
            completion: nil)
    }
    


    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[0].count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[0][row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){
        let topping = pickerData[0][chooseView.selectedRowInComponent(0)]
        GV.language.setLanguage(topping)

    }
    func dummy () ->() {
        
    }
    func callBackWhenEnded(callBack: ()->()) {
        goWhenEnd = callBack
    }
    func updateLanguage() {
        languageButton.setTitle(GV.language.getText("language"), forState: .Normal)
        clearButton.setTitle(GV.language.getText("cleangame"), forState: .Normal)
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
