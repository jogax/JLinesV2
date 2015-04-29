//
//  ChoosViewController.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 11.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit


class ChoosViewController: UIViewController {
/*
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
*/
    @IBOutlet weak var firstPackButton: UIButton?
    @IBOutlet weak var bonusPackButton: UIButton!
    @IBOutlet weak var greenPackButton: UIButton!
    
    @IBAction func returned(segue: UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GV.language.callBackWhenNewLanguage(updateLanguage)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {


        if segue.identifier != nil {
            let destination = segue.destinationViewController as! PagedViewController
            destination.packageName = segue.identifier
        }

    }

    func updateLanguage() {
        firstPackButton!.setTitle(GV.language.getText("firstPackButton"), forState: .Normal)
        bonusPackButton!.setTitle(GV.language.getText("bonusPackButton"), forState: .Normal)
        greenPackButton!.setTitle(GV.language.getText("greenPackButton"), forState: .Normal)
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
