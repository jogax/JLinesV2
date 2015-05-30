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
    var returnButton = MyButton()
    var gameModusButton = MyButton()
    var pickerData: [[String]] = []
    let chooseView = UIPickerView()
    var gameControllView = UISegmentedControl()
    let chooseOKButton = MyButton()
    let buttonsView = UIView()
    var goWhenEnd: ()->()
    var device = GV.myDevice
    var topping: String = ""
    var chooseLanguageOpen = false
    private var sizes = [String:AnyObject]()
    
    init(callBack: ()->()) {
        goWhenEnd = callBack
        

        super.init(nibName: nil, bundle: nil)

        GV.language.callBackWhenNewLanguage(self.updateLanguage)
    }

    override func viewWillLayoutSubviews() {
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GV.lightSalmonColor
        self.view.addSubview(buttonsView)
        self.view.addSubview(backButton)
        buttonsView.addSubview(languageButton)
        buttonsView.addSubview(clearButton)
        buttonsView.addSubview(returnButton)
        self.view.addSubview(gameModusButton)
        
        
        //let myWert = self.view.frame.width / 10
        NSLayoutConstraint.deactivateConstraints(self.view.constraints())
        
        buttonsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        languageButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        clearButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        returnButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        chooseView.setTranslatesAutoresizingMaskIntoConstraints(false)
        gameModusButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        setupLayout()
        
        buttonsView.backgroundColor = GV.darkTurquoiseColor
        buttonsView.layer.cornerRadius = 10
        buttonsView.layer.shadowOpacity = 1.0
        buttonsView.layer.shadowOffset = CGSizeMake(3, 3)
        buttonsView.layer.shadowColor = UIColor.blackColor().CGColor
        
        languageButton.setTitle(GV.language.getText("language"), forState: .Normal)
        languageButton.addTarget(self, action: "chooseLanguage:", forControlEvents: .TouchUpInside)

        gameModusButton.setTitle(GV.language.getText("gameModus"), forState: .Normal)
        gameModusButton.addTarget(self, action: "chooseGameControll:", forControlEvents: .TouchUpInside)
        
        clearButton.setTitle(GV.language.getText("cleangame"), forState: .Normal)
        clearButton.addTarget(self, action: "clearGame:", forControlEvents: .TouchUpInside)
        
        returnButton.setTitle(GV.language.getText("return"), forState: .Normal)
        returnButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)

        backButton.setImage(GV.images.getBack(), forState: .Normal)
        backButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)

        chooseView.delegate = self
        chooseView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func endSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {self.goWhenEnd()})
    }

    func chooseGameControll (sender: UIButton) {
        
        let items = ["Finger", "Joystick", "Accelerometer", "Pipeline"]
        gameControllView = UISegmentedControl(items: items)
        gameControllView.selectedSegmentIndex = GV.gameControll.rawValue
        gameControllView.addTarget(self, action: "changedModus:", forControlEvents:  .ValueChanged)
        gameControllView.backgroundColor = GV.PeachPuffColor
        gameControllView.layer.shadowColor = GV.BlackColor.CGColor
        gameControllView.layer.shadowOffset = CGSizeMake(3, 3)
        gameControllView.layer.shadowOpacity = 1.0
        self.view.addSubview(gameControllView)
        setupGameControllView()
        
    }
    
    func changedModus (sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            GV.gameControll = .Finger
        case 1:
            GV.gameControll = .JoyStick
        case 2:
            GV.gameControll = .Accelerometer
        case 3:
            GV.gameControll = .Accelerometer
        case 4:
            GV.gameControll = .PipeLine
        default:
            GV.gameControll = .Finger
        }
        GV.appData.gameControll = Int64(GV.gameControll.rawValue)
        GV.notificationCenter.postNotificationName(GV.notificationGameControllChanged, object: nil)
        GV.dataStore.createAppVariablesRecord(GV.appData)
        gameControllView.removeFromSuperview()
    }    

    func chooseLanguage(sender: UIButton) {
        
        languageButton.enabled = false
        clearButton.enabled = false
        gameModusButton.enabled = false
        returnButton.enabled = false
        chooseLanguageOpen = true
        chooseOKButton.setTitle(GV.language.getText("OK"), forState: .Normal)
        chooseOKButton.addTarget(self, action: "chooseOKFunc:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(chooseView)
        self.view.addSubview(chooseOKButton)
        setupChooseLayout()
        chooseView.backgroundColor = GV.darkTurquoiseColor
        chooseView.layer.cornerRadius = 10
        let languageIndex = GV.language.getAktLanguageIndex()
        
        pickerData.append(GV.language.getLanguages())
        chooseView.selectRow(GV.language.getAktLanguageIndex(), inComponent: 0, animated: true)
        chooseView.layer.shadowColor = GV.BlackColor.CGColor
        chooseView.layer.shadowOpacity = 1.0
        chooseView.layer.shadowOffset = CGSizeMake(5, 5)
        
    }
    
    func chooseOKFunc(sender: UIButton) {
        chooseView.removeFromSuperview()
        chooseOKButton.removeFromSuperview()
        GV.language.setLanguage(topping)
        pickerData.removeAll(keepCapacity: false)
        languageButton.enabled = true
        clearButton.enabled = true
        gameModusButton.enabled = true
        returnButton.enabled = true
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
                //println("Anzahl Records:\(GV.dataStore.getCountRecords())")
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
        topping = pickerData[0][chooseView.selectedRowInComponent(0)]

    }
    func dummy () ->() {
        
    }
    func callBackWhenEnded(callBack: ()->()) {
        goWhenEnd = callBack
    }
    func updateLanguage() {
        languageButton.setTitle(GV.language.getText("language"), forState: .Normal)
        clearButton.setTitle(GV.language.getText("cleangame"), forState: .Normal)
        gameModusButton.setTitle(GV.language.getText("gameModus"), forState: .Normal)
        returnButton.setTitle(GV.language.getText("return"), forState: .Normal)
    }

    func setupGameControllView() {
        
        gameControllView.setTranslatesAutoresizingMaskIntoConstraints(false)
        var constraintsArray = Array<NSObject>()
        
        // gameModusVew
        
        
        constraintsArray.append(NSLayoutConstraint(item: gameControllView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameControllView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -80.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameControllView, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameControllView, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 70.0))
        
      
        self.view.addConstraints(constraintsArray)
        
    }
    func setupChooseLayout() {
        chooseView.setTranslatesAutoresizingMaskIntoConstraints(false)
        chooseOKButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraintsArray = Array<NSObject>()
        // chooseView
        
        
        constraintsArray.append(NSLayoutConstraint(item: chooseView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -80.0))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseView, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseView, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 70.0))

        // chooseOKButton
        constraintsArray.append(NSLayoutConstraint(item: chooseOKButton, attribute: .CenterX, relatedBy: .Equal, toItem: chooseView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseOKButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -30.0))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseOKButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: chooseView.frame.width / 6))
        
        constraintsArray.append(NSLayoutConstraint(item: chooseOKButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30.0))
     
        
        
        self.view.addConstraints(constraintsArray)
 
    }
    func setupLayout() {
        var constraintsArray = Array<NSObject>()
        
        let countButtons: CGFloat = 4
        let buttonsHeight = self.view.frame.height * 0.08
        let buttonsGap = buttonsHeight / 5
        let buttonsViewHeight = countButtons * (buttonsHeight + buttonsGap) + buttonsGap
        

        buttonsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        languageButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        clearButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // buttonsView
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.8, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsViewHeight))
        
      // constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: countButtons * (buttonsHeight + buttonsGap) + buttonsGap)
        
        // languageButton
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: buttonsView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: buttonsGap))
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.95, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight))
        
        // clearButton
        
        constraintsArray.append(NSLayoutConstraint(item: clearButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: languageButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: clearButton, attribute: .Top, relatedBy: .Equal, toItem: languageButton, attribute: .Bottom, multiplier: 1.0, constant: buttonsGap))
        
        constraintsArray.append(NSLayoutConstraint(item: clearButton, attribute: .Width, relatedBy: .Equal, toItem: languageButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: clearButton, attribute: .Height , relatedBy: .Equal, toItem: languageButton, attribute: .Height, multiplier: 1.0, constant: 0.0))
        
        // gameModusButton
        
        constraintsArray.append(NSLayoutConstraint(item: gameModusButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: languageButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameModusButton, attribute: .Top, relatedBy: .Equal, toItem: clearButton, attribute: .Bottom, multiplier: 1.0, constant: buttonsGap))
        
        constraintsArray.append(NSLayoutConstraint(item: gameModusButton, attribute: .Width, relatedBy: .Equal, toItem: languageButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameModusButton, attribute: .Height , relatedBy: .Equal, toItem: languageButton, attribute: .Height, multiplier: 1.0, constant: 0.0))
        
        // returnButton
        
        constraintsArray.append(NSLayoutConstraint(item: returnButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: languageButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: returnButton, attribute: .Top, relatedBy: .Equal, toItem: gameModusButton, attribute: .Bottom, multiplier: 1.0, constant: buttonsGap))
        
        constraintsArray.append(NSLayoutConstraint(item: returnButton, attribute: .Width, relatedBy: .Equal, toItem: languageButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: returnButton, attribute: .Height , relatedBy: .Equal, toItem: languageButton, attribute: .Height, multiplier: 1.0, constant: 0.0))
        
        // backButton
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 20.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.05, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Height , relatedBy: .Equal, toItem: backButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        

        
        
        self.view.addConstraints(constraintsArray)
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
