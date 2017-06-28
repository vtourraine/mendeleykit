/*
 ******************************************************************************
 * Copyright (C) 2014-2017 Elsevier/Mendeley.
 *
 * This file is part of the Mendeley iOS SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************
 */

import UIKit

open class MendeleyLoginConsentViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    @IBOutlet var rolePicker: UIPickerView!
    @IBOutlet var disciplinePicker: UIPickerView!
    
    @IBOutlet var publicProfileSwitch: UISwitch!
    @IBOutlet var publicProfileLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    
    var disciplines: [MendeleyDiscipline]?
    var roles: [MendeleyAcademicStatus]?
    
    public var completionBlock: ((MendeleyAmendmentProfile, Bool) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        MendeleyKit.sharedInstance().userRoles { (objects: [Any]?, sycnInfo: MendeleySyncInfo?, error: Error?) in
            if objects?.count ?? 0 > 0 {
                self.roles = objects as? [MendeleyAcademicStatus]
                self.rolePicker.reloadAllComponents()
            }
        }
        
        MendeleyKit.sharedInstance().subjectAreas { (objects: [Any]?, syncInfo: MendeleySyncInfo?, error: Error?) in
            if objects?.count ?? 0 > 0 {
                self.disciplines = objects as? [MendeleyDiscipline]
                self.disciplinePicker.reloadAllComponents()
            }
        }
    }
    
    @IBAction func didTapDoneButton(sender: UIButton) {
        let publicProfile = publicProfileSwitch.isOn
        
        let roleIndex = rolePicker.selectedRow(inComponent: 0)
        let role = roles?[roleIndex]
        
        let disciplineIndex = disciplinePicker.selectedRow(inComponent: 0)
        let discipline = disciplines?[disciplineIndex]
        
        let amendmentProfile = MendeleyAmendmentProfile()
        if (discipline != nil) {
            amendmentProfile.disciplines = [discipline!]
        }
        if (role != nil) {
        amendmentProfile.academic_status = role?.objectDescription
        }
        
        completionBlock?(amendmentProfile, publicProfile)
    }
}

extension MendeleyLoginConsentViewController: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text: String?
        if (pickerView == rolePicker) {
            text = roles?[row].objectDescription
        } else if (pickerView == disciplinePicker) {
            text = disciplines?[row].name
        }
        
        if let label = view as? UILabel {
            label.text = text
            return label
        }
        
        let newLabel = UILabel()
        
        newLabel.font = UIFont(name: "Arial", size: 16.0)
        newLabel.textColor = UIColor.init(white: 71.0/255.0, alpha: 1.0)
        newLabel.textAlignment = .center
        
        newLabel.adjustsFontSizeToFitWidth = true
        if #available(iOS 9.0, *) {
            newLabel.allowsDefaultTighteningForTruncation = true
        }
        newLabel.minimumScaleFactor = 0.7
        
        newLabel.text = text
        
        return newLabel
    }

}

extension MendeleyLoginConsentViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (pickerView == rolePicker || pickerView == disciplinePicker) {
            return 1
        }
        
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == rolePicker) {
            return roles?.count ?? 0
        } else if (pickerView == disciplinePicker) {
            return disciplines?.count ?? 0
        }
        
        return 0
    }
}
