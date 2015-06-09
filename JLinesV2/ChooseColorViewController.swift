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
    var colorSetLabels = [UILabel]()
    var colorSetButtons = [MyButton]()
    var colorSets = [[]]
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
        
        descriptionsLabel.backgroundColor = UIColor.clearColor()
        descriptionsLabel.text = GV.language.getText("chooseColorSet")
        descriptionsLabel.numberOfLines = 3
        descriptionsLabel.textAlignment = NSTextAlignment.Center
        descriptionsLabel.layer.cornerRadius = 10
        descriptionsLabel.layer.shadowColor = UIColor.blackColor().CGColor
        descriptionsLabel.layer.shadowOffset = CGSizeMake(8, 8)
        descriptionsLabel.layer.shadowOpacity = 1.0
        view.addSubview(descriptionsLabel)
        view.addSubview(buttonsView)
        view.addSubview(backButton)
        
        buttonsView.backgroundColor = GV.darkTurquoiseColor
        buttonsView.layer.cornerRadius = 10
        buttonsView.layer.shadowOpacity = 1.0
        buttonsView.layer.shadowOffset = CGSizeMake(3, 3)
        buttonsView.layer.shadowColor = UIColor.blackColor().CGColor
        colorSets.removeAll(keepCapacity: false)
        var colorSet = [UIView]()
        for index in 0..<GV.colorSets.count {
            colorSetLabels.append(UILabel())
            colorSetLabels[index].setTranslatesAutoresizingMaskIntoConstraints(false)
            colorSetLabels[index].backgroundColor = GV.PeachPuffColor
            colorSetLabels[index].clipsToBounds = true
            colorSetLabels[index].layer.masksToBounds = false
            colorSetLabels[index].layer.cornerRadius = 3.0
            colorSetLabels[index].layer.shadowColor = UIColor.blackColor().CGColor
            colorSetLabels[index].layer.shadowOffset = CGSizeMake(3, 3)
            colorSetLabels[index].layer.shadowOpacity = 1.0
            colorSetLabels[index].layer.name = "colorLabel index: \(index)"
            colorSetButtons.append(MyButton())
            colorSetButtons[index].setTranslatesAutoresizingMaskIntoConstraints(false)
            colorSet.removeAll(keepCapacity: false)
            for colorIndex in 0..<GV.colorSets[index].count - 4 {
                colorSet.append(UIView())
                colorSet[colorIndex].backgroundColor = GV.colorSets[index][colorIndex + 1]
                println("index: \(index), colorIndex: \(colorIndex), bgColor: \(colorSet[colorIndex].backgroundColor)")
                colorSet[colorIndex].layer.cornerRadius = 3.0
                colorSet[colorIndex].layer.shadowColor = UIColor.blackColor().CGColor
                colorSet[colorIndex].layer.shadowOffset = CGSizeMake(3, 3)
                colorSet[colorIndex].layer.shadowOpacity = 1.0
                colorSet[colorIndex].alpha = 1.0
                colorSet[colorIndex].layer.name = "colorset:\(index):\(colorIndex)"
                colorSetLabels[index].addSubview(colorSet[colorIndex])
            }
            colorSets.append(colorSet)
            view.addSubview(colorSetLabels[index])
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
        let buttonsHeight = self.view.frame.height * 0.1
        let buttonsGap = buttonsHeight / 5
        let buttonsViewHeight = countButtons * (buttonsHeight + buttonsGap) + buttonsGap
        
        
        buttonsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // descriptionsLabel
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 40))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.95, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: descriptionsLabel, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight))
        
        // buttonsView
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Top, relatedBy: .Equal, toItem: descriptionsLabel, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.8, constant: 0))
        
        constraintsArray.append(NSLayoutConstraint(item: buttonsView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsViewHeight))
        
        // chooseColorSet Buttons
        
        for index in 0..<colorSetLabels.count {
            let multiplier = CGFloat(index + 1)

            constraintsArray.append(NSLayoutConstraint(item: colorSetLabels[index], attribute: .Left, relatedBy: .Equal, toItem: buttonsView, attribute: .Left, multiplier: 1.0, constant: buttonsGap / 2))
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Right, relatedBy: .Equal, toItem: buttonsView, attribute: .Right, multiplier: 1.0, constant: -buttonsGap / 2))
            
            if index == 0 {
                constraintsArray.append(NSLayoutConstraint(item: colorSetLabels[index], attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: 20))
                constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .CenterY, relatedBy: .Equal, toItem: colorSetLabels[index], attribute: .CenterY, multiplier: 1.0, constant: 0))
            } else {
                constraintsArray.append(NSLayoutConstraint(item: colorSetLabels[index], attribute: .Top, relatedBy: .Equal, toItem: colorSetLabels[index - 1], attribute: .Bottom, multiplier: 1.0, constant: 20))
                constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .CenterY, relatedBy: .Equal, toItem: colorSetLabels[index], attribute: .CenterY, multiplier: 1.0, constant: 0))
            }
            constraintsArray.append(NSLayoutConstraint(item: colorSetLabels[index], attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.6, constant: 1))
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Width, relatedBy: .Equal, toItem: buttonsView, attribute: .Width, multiplier: 0.3, constant: 1))

            constraintsArray.append(NSLayoutConstraint(item: colorSetLabels[index], attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight))
            constraintsArray.append(NSLayoutConstraint(item: colorSetButtons[index], attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonsHeight / 2))
            
            for colorIndex in 0..<colorSets[index].count {
                if colorIndex == 0 {
                    if colorIndex == 0 || colorIndex == 7 {
                        constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Left, relatedBy: .Equal, toItem: colorSetLabels[index], attribute: .Left, multiplier: 1.0, constant: 10))
                    } else {
                        constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Left, relatedBy: .Equal, toItem: colorSets[index][colorIndex], attribute: .Right, multiplier: 1.0, constant: 10))
                    }
                    if colorIndex < 7 {
                        constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Top, relatedBy: .Equal, toItem: colorSetLabels[index], attribute: .Top, multiplier: 1.0, constant: 10))
                    } else {
                        constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Top, relatedBy: .Equal, toItem: colorSetLabels[index], attribute: .Bottom, multiplier: 1.0, constant: -10))
                    }
                    
                    constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 20))
                    
                    constraintsArray.append(NSLayoutConstraint(item: colorSets[index][colorIndex], attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20))
                }
                
            }
            

        }

        
        
        // backButton
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 20.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.05, constant: 0.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Height , relatedBy: .Equal, toItem: backButton, attribute: .Width, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraints(constraintsArray)
    }

}
