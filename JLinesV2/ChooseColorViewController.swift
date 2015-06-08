//
//  ChooseColorViewController.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 08.06.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class ChooseColorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate   {

    var backButton = UIButton()
    var pickerData: [[String]] = []
    var topping: String = ""
    let chooseView = UIPickerView()
    var descriptionsLabel = UILabel()
    let buttonsView = UIView()
    var colorSetButtons = [MyButton]()
    var goWhenEnd: ()->()

    init(callBack: ()->()) {
        goWhenEnd = callBack
        
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GV.lightSalmonColor
        
        descriptionsLabel.backgroundColor = GV.lightSalmonColor
        descriptionsLabel.text = GV.language.getText("chooseColorSet")
        descriptionsLabel.numberOfLines = 3
        descriptionsLabel.textAlignment = NSTextAlignment.Center
        descriptionsLabel.layer.cornerRadius = 10
        view.addSubview(descriptionsLabel)
        view.addSubview(buttonsView)
        view.addSubview(backButton)
        
        buttonsView.backgroundColor = GV.darkTurquoiseColor
        buttonsView.layer.cornerRadius = 10
        buttonsView.layer.shadowOpacity = 1.0
        buttonsView.layer.shadowOffset = CGSizeMake(3, 3)
        buttonsView.layer.shadowColor = UIColor.blackColor().CGColor
        for index in 0..<GV.colorSets.count {
            colorSetButtons.append(MyButton())
            colorSetButtons[index].setTranslatesAutoresizingMaskIntoConstraints(false)
            view.addSubview(colorSetButtons[index])
        }
        backButton.setImage(GV.images.getBack(), forState: .Normal)
        backButton.addTarget(self, action: "endChooseColor:", forControlEvents: .TouchUpInside)
        setupLayout()
    }

    func endChooseColor(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {self.goWhenEnd()})
    }

    func callBackWhenEnded(callBack: ()->()) {
        goWhenEnd = callBack
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func setupLayout() {
        
        var constraintsArray = Array<NSObject>()
        
        let countButtons: CGFloat = 4
        let buttonsHeight = self.view.frame.height * 0.2
        let buttonsGap = buttonsHeight / 5
        let buttonsViewHeight = countButtons * (buttonsHeight + buttonsGap) + buttonsGap
        
        
        buttonsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // descriptionsLabel
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: 40))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.95, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight))
        
        // buttonsView
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.8, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsViewHeight))
        
        // chooseColorSet Buttons
        
        for index in 0..<colorSetButtons.count {
            let multiplier = CGFloat(index + 1)
            
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .CenterX, relatedBy: .Equal, toItem: buttonsView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            
            if index == 0 {
                constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: 20))
            } else {
                constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Top, relatedBy: .Equal, toItem: colorSetButtons[index - 1], attribute: .Bottom, multiplier: 1.0, constant: 20))
            }
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.8, constant: 1))
            
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight))
        }

        
        
        // backButton
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 20.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.05, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Height , relatedBy: .Equal, toItem: backButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        self.view.addConstraints(constraintsArray)
    }

}
