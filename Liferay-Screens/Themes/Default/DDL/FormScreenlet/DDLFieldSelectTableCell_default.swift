/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit


public class DDLFieldSelectTableCell_default: DDLBaseFieldTextboxTableCell_default {

	@IBOutlet internal var chooseButton: UIButton? {
		didSet {
			setButtonDefaultStyle(chooseButton)
		}
	}


	//MARK: Actions

	@IBAction private func chooseButtonAction(sender: AnyObject) {
		textField!.becomeFirstResponder()
	}


	//MARK: DDLBaseFieldTextboxTableCell

	override internal func onChangedField() {
		super.onChangedField()

		if let stringField = field as? DDLFieldStringWithOptions {
			textField?.text = stringField.currentValueAsLabel

			setFieldPresenter(stringField)
		}
	}


	//MARK: Private methods

	private func setFieldPresenter(field:DDLFieldStringWithOptions) {

		func dataSource() -> DTPickerDataSource {
			var rows:[String] = [""]

			for option in field.options {
				rows.append(option.label)
			}

			return DTPickerDataSource.datasourceWithItems([rows])
		}

		func currentValueIndex() -> Int? {
			for (index,option) in enumerate(field.options) {
				if option.label == field.currentValueAsLabel {
					return index
				}
			}

			return nil
		}

		let onChangeClosure = {
			(selectedComponents:[AnyObject]!, selectedIndexPath:NSIndexPath!) -> Void in

			var text = ""
            if let t = selectedComponents.first?.description as NSString? {
                text = t as String
            }
			self.textField?.text = text
			field.currentValue = text

			let fullRange = NSMakeRange(0, count(text))

			self.textField(self.textField,
					shouldChangeCharactersInRange:fullRange,
					replacementString: text)
		}

		let optionsPresenter = DTPickerViewPresenter(
				datasource: dataSource(),
				changeBlock: onChangeClosure)

		optionsPresenter.pickerView.backgroundColor = UIColor.whiteColor()
		optionsPresenter.pickerView.layer.borderColor = UIColor.lightGrayColor().CGColor
		optionsPresenter.pickerView.layer.borderWidth = 1.5

		if let currentIndex = currentValueIndex() {
			optionsPresenter.pickerView.selectRow(currentIndex + 1, inComponent: 0, animated: false)
		}

		textField?.dt_setPresenter(optionsPresenter)
	}

}
