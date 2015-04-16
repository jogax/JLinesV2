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
    var pickerData: [[String]] = []
    let chooseView = UIPickerView()
    var goWhenEnd: ()->()


    init(callBack: ()->()) {
       goWhenEnd = callBack
       super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
/*
    @IBAction func returned() {
        
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        let sourceViewController: AnyObject = sender.sourceViewController
        // Pull any data from the view controller which initiated the unwind segue.
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        languageButton.frame = CGRect(x:100,y:100,width:200,height: 30)
        languageButton.backgroundColor = UIColor.greenColor()
        languageButton.setTitle(GlobalVariables.language.getText("language"), forState: .Normal)
        languageButton.addTarget(self, action: "chooseLanguage:", forControlEvents: .TouchUpInside)
        
        backButton.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 40, width: 20, height: 20)
        backButton.backgroundColor = UIColor.lightGrayColor()
        backButton.setTitle(GlobalVariables.language.getText("x"), forState: .Normal)
        backButton.addTarget(self, action: "endSettings:", forControlEvents: .TouchUpInside)

        chooseView.delegate = self
        chooseView.dataSource = self
        self.view.addSubview(languageButton)
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
        pickerData.append(GlobalVariables.language.getLanguages())
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
        GlobalVariables.language.setLanguage(topping)
        languageButton.setTitle(GlobalVariables.language.getText("language"), forState: .Normal)

    }
    func dummy () ->() {
        
    }
    func callBackWhenEnded(callBack: ()->()) {
        goWhenEnd = callBack
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
