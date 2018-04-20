//
//  NoteViewController+Events.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 20/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - View Events
extension NoteViewController {
    
    // Instead of keyboard for endDate edition, we'll use DatePicker
    @objc func editingEndDateTextField(textField: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.locale = Locale.current
        datePickerView.date = model.endDate
        textField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    // Update endDate from Model and Sync View
    @objc func datePickerValueChanged(datePicker:UIDatePicker) {
        model.endDate = datePicker.date
        syncModelWithView()
        
        // Notify delegate
        self.delegate?.didChange(note: model, type: .expirationDate)
    }
    
    // User edits titleTextField
    @objc func titleTextFieldChanged(textField: UITextField) {
        if let value = textField.text {
            model.title = value
        } else {
            model.title = ""
        }
        
        // Notify delegate
        self.delegate?.didChange(note: model, type: .title)
    }
    
}
