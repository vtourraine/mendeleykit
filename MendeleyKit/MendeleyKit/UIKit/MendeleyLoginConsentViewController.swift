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
    var roles: [MendeleyUserRole]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        MendeleyKit.sharedInstance().userRoles { (objects: [Any]?, sycnInfo: MendeleySyncInfo?, error: Error?) in
            if objects?.count ?? 0 > 0 {
                self.roles = objects as? [MendeleyUserRole]
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
        
        
    }
    
}

extension MendeleyLoginConsentViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == rolePicker) {
            return roles?[component].role
        } else if (pickerView == disciplinePicker) {
            return disciplines?[component].name
        }
        
        return nil
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
