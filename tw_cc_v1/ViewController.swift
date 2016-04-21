//
//  ViewController.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 19.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

	// Pole vsech UITextField ve formalu.
	var allTextFields = [String: UITextField]()

	// Vysledne pole, ktere se predava k zobrazeni na tableView
	var allInformations = [String: String]()

	weak var sendButton: UIButton!

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
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		allInformations = [:]

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
		allTextFields[name] = txt

		let stackView = UIStackView(arrangedSubviews: [lbl, txt])
		stackView.axis = .Horizontal
		stackView.spacing = 10

		return stackView
	}

	func sendForm(sender: UIButton) {
		let resultController = ResultTableViewController()
		resultController.info = allInformations
		self.navigationController?.pushViewController(resultController, animated: true)
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
