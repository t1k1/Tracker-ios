//
//  SelectCategoryViewModel.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 13.11.2023.
//

import Foundation

final class SelectCategoryViewModel: NSObject {
    var onChange: (() -> Void)?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    private weak var delegate: CreateHabitDelegate?
    private let categoryStore = TrackerCategoryStore.shared
    
    init(delegate: CreateHabitDelegate) {
        self.delegate = delegate
        super.init()
        getCategories()
    }
    
    func updateCategory(category: TrackerCategory) {
        delegate?.updateCategory(category: category)
        getCategories()
        onChange?()
    }
    
    func addNewCategory(category: String) {
        try? categoryStore.addNewCategory(category: TrackerCategory(header: category, trackers: []))
        getCategories()
        onChange?()
    }
    
    func getCategories() {
        guard let categories = try? categoryStore.fetchCategories() else { return }
        self.categories = categories
    }
}
