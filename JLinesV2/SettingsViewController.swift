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
    var languageButton = UIButton()
    var clearButton = UIButton()
    var returnButton = UIButton()
    var gameModusButton = UIButton()
    var pickerData: [[String]] = []
    let chooseView = UIPickerView()
    let chooseOKButton = UIButton()
    let buttonsView = UIView()
    var goWhenEnd: ()->()
    var device = GV.myDevice
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
        
        languageButton.setTitle(GV.language.getText("language"), forState: .Normal)
        languageButton.addTarget(self, action: "chooseLanguage:", forControlEvents: .TouchUpInside)
        languageButton.setupDepression()
        languageButton.layer.cornerRadius = 5
        //languageButton.moveToCenter(self.view.frame)
        languageButton.backgroundColor = GV.PeachPuffColor
        languageButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        gameModusButton.setTitle(GV.language.getText("gameModus"), forState: .Normal)
        gameModusButton.addTarget(self, action: "chooseGameModus:", forControlEvents: .TouchUpInside)
        gameModusButton.setupDepression()
        gameModusButton.layer.cornerRadius = 5
        //gameModusButton.moveToCenter(self.view.frame)
        gameModusButton.backgroundColor = GV.PeachPuffColor
        gameModusButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        clearButton.setTitle(GV.language.getText("cleangame"), forState: .Normal)
        clearButton.layer.cornerRadius = 5
        clearButton.addTarget(self, action: "clearGame:", forControlEvents: .TouchUpInside)
        //clearButton.moveToCenter(self.view.frame)
        clearButton.backgroundColor = GV.PeachPuffColor
        clearButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        returnButton.setTitle(GV.language.getText("return"), forState: .Normal)
        returnButton.layer.cornerRadius = 5
        returnButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)
        //returnButton.moveToCenter(self.view.frame)
        returnButton.backgroundColor = GV.PeachPuffColor
        returnButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        //clearButton.layerGradient(GV.springGreenColor.CGColor, endColor: GV.khakiColor.CGColor)
        
        
        //backButton.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.size.width - 40, y: self.view.frame.origin.y + 40, width: 20, height: 20)
        backButton.setImage(GV.images.getBack(), forState: .Normal)
        backButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)

        chooseView.delegate = self
        chooseView.dataSource = self
        
        //self.view.addSubview(buttonsView)
        //self.view.addSubview(languageButton)
        //self.view.addSubview(clearButton)
        //self.view.addSubview(backButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func endSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {self.goWhenEnd()})
    }
    
    func chooseGameModus () {
        
    }
    
    func chooseLanguage(sender: UIButton) {
        
        chooseOKButton.setTitle(GV.language.getText("OK"), forState: .Normal)
        chooseOKButton.layer.cornerRadius = 5
        chooseOKButton.addTarget(self, action: "chooseOKFunc:", forControlEvents: .TouchUpInside)
        chooseOKButton.backgroundColor = GV.PeachPuffColor
        chooseOKButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        self.view.addSubview(chooseView)
        self.view.addSubview(chooseOKButton)
        setupChooseLayout()
        chooseView.backgroundColor = GV.darkTurquoiseColor
        chooseView.layer.cornerRadius = 10
        let languageIndex = GV.language.getAktLanguageIndex()
        
        pickerData.append(GV.language.getLanguages())
        chooseView.selectRow(GV.language.getAktLanguageIndex(), inComponent: 0, animated: true)
        
    }
    
    func chooseOKFunc(sender: UIButton) {
        chooseView.removeFromSuperview()
        chooseOKButton.removeFromSuperview()
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
        returnButton.setTitle(GV.language.getText("return"), forState: .Normal)
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
        let buttonsHeight = self.view.frame.height * 0.07
        let buttonsGap = buttonsHeight / 2
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
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: languageButton, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.9, constant: 0))
        
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
