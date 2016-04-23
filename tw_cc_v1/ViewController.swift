//
//  ViewController.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 19.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate{

	// Pole vsech UITextField ve formalu.
	var allTextFields = [String: UITextField]()

	// Vysledne pole, ktere se predava k zobrazeni na tableView
	var allInformations = [String: String]()

	weak var sendButton: UIButton!
    
    var gyroscope = Gyroscope()
    
    override func viewWillDisappear(animated: Bool) {
        gyroscope.pauseGyroCollection()
        gyroscope.pauseMotionCollection()
    }
    
    override func viewWillAppear(animated: Bool) {
        if gyroscope.gyroGathering{
            gyroscope.startGyroCollection()
        }
        
        if gyroscope.motionGathering{
            gyroscope.startMotionCollection()
        }
    }

	override func loadView() {
		super.loadView()
		self.view.backgroundColor = UIColor.whiteColor()
		self.title = "Registrace"

		let btnSend = UIButton()
		btnSend.setTitle("Send", forState: .Normal)
		btnSend.backgroundColor = UIColor.redColor()
		self.sendButton = btnSend

		let mainStackView = UIStackView(arrangedSubviews: [createStackHorizontalLine("Jmeno"),
			createStackHorizontalLine("Prijmeni"),
			createStackHorizontalLine("Adresa"),
			createStackHorizontalLine("Mesto"),
			createStackHorizontalLine("PSČ"),
			btnSend])

		mainStackView.axis = .Vertical
		mainStackView.spacing = 10
		self.view.addSubview(mainStackView)
		mainStackView.snp_makeConstraints { make in
			make.leading.equalTo(10)
			make.trailing.equalTo(-10)
			make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
		}
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        gyroscope.startMotionCollection()
        
		self.sendButton.addTarget(self, action: #selector(sendForm(_:)), forControlEvents: .TouchUpInside)

		let info = DeviceInfo().getAllInformation()
		// Vse co se sem prida se pak zobrazi v tableView
		allInformations.merge(info)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func createStackHorizontalLine(name: String) -> UIStackView {
		let lbl = UILabel()
		lbl.text = name
		lbl.snp_makeConstraints { make in
			make.width.equalTo(80)
		}

		let txt = UITextField()
		txt.borderStyle = .RoundedRect
        txt.delegate = self
		allTextFields[name] = txt
        
		let stackView = UIStackView(arrangedSubviews: [lbl, txt])
		stackView.axis = .Horizontal
		stackView.spacing = 10

		return stackView
	}

	func sendForm(sender: UIButton) {
        gyroscope.stopMotionCollection()
        if let motionResults = gyroscope.getAverageMotionData(){
            allInformations["user position"] = (motionResults.roll > 1.5) ? "mostly lying" : "mostly standing"
        }
		let resultController = ResultTableViewController()
		resultController.info = allInformations
		self.navigationController?.pushViewController(resultController, animated: true)
	}
    
    func textFieldDidBeginEditing(textField: UITextField) {
        gyroscope.startGyroCollection()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let fieldLabel = textField.superview?.subviews.first as! UILabel
        
        gyroscope.stopGyroCollection()
        if let results = gyroscope.getAverageGyroData() {
            allInformations["\(fieldLabel.text!) - avg handshake X"] = String(format: "%.4f", results.x)
            allInformations["\(fieldLabel.text!) - avg handshake Y"] = String(format: "%.4f", results.y)
            allInformations["\(fieldLabel.text!) - avg handshake Z"] = String(format: "%.4f", results.z)
        }
        
    }
    
    //for diasble editing of textField when clicked somewhere else
    func tap(gesture: UITapGestureRecognizer) {
        allTextFields.forEach({key,textField in
            textField.resignFirstResponder()
        })
    }
}

//Spojeni dvou Dictionary
extension Dictionary {
	mutating func merge(other: Dictionary) {
		for (key, value) in other {
			self.updateValue(value, forKey: key)
		}
	}
}
