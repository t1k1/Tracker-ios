//
//  ViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.09.2023.
//

import UIKit

//MARK: - Protocols
protocol TrackerViewControllerDelegate: AnyObject {
    func addNewTracker(
        category: TrackerCategory,
        sheduleArr: [WeekDay],
        habitName: String,
        emoji: String,
        color: UIColor,
        pinned: Bool
    )
    func updateTracker(
        categoryName: String,
        shedule: [WeekDay],
        name: String,
        emoji: String,
        color: UIColor,
        id: UUID
    )
}
protocol TrackerCellDelegate: AnyObject {
    func updateTrackerRecord(id: UUID, isCompleted: Bool, indexPath: IndexPath)
}

//MARK: - TrackerViewController
class TrackerViewController: UIViewController {
    
    //MARK: - Layout variables
    private lazy var topNavView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var addButton: UIButton = {
        let imageButton = UIImage(named: "PlusIcon")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        
        return button
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.addTarget(self, action: #selector(filterDate), for: .valueChanged)
        
        return datePicker
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("trackers", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var stackViewForSearch: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 14
        
        return stackView
    }()
    private lazy var searchField: UISearchTextField = {
        let search = UISearchTextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        
        search.autocorrectionType = UITextAutocorrectionType.no
        search.returnKeyType = UIReturnKeyType.done
        search.clearButtonMode = UITextField.ViewMode.whileEditing
        search.textColor = UIColor.ypBlack
        search.layer.cornerRadius = 16
        search.delegate = self
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypGray
        ]
        search.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("search", tableName: "LocalizableStr", comment: ""),
            attributes: attributes
        )
        
        return search
    }()
    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            NSLocalizedString("cancellation", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.tintColor = UIColor.ypBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.isHidden = true
        button.addTarget(self, action: #selector(canselSearch), for: .touchUpInside)
        
        return button
    }()
    private lazy var centerImageView: UIImageView = {
        let image = UIImage(named: "CenterImage")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes4", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionViewLayout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(NSLocalizedString("filters", tableName: "LocalizableStr", comment: ""), for: .normal)
        button.backgroundColor = .ypBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Private variables
    private let analyticsService = AnalyticsService()
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    private var pinnedTrackers: [Tracker] = []
    private var currentDate: Date?
    private var currentFilter: Filter?
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analyticsService.reportEvent(event: .open, params: [AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue])
        
        categoryStore.delegate = self
        trackerStore.delegate = self
        updateCategories()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.reportEvent(event: .close, params: [AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue])
    }
}

//MARK: - UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText == "" {
                showFilteredTrackersByDay()
            } else {
                showFilteredTrackersByText(updatedText)
            }
        }
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cancelSearchButton.isHidden = true
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.isHidden = false
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension TrackerViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        updateCategories()
        collectionView.reloadData()
    }
}

//MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        updateCategories()
        collectionView.reloadData()
        changeVisibility()
    }
}

//MARK: - TrackerViewControllerDelegate
extension TrackerViewController: TrackerViewControllerDelegate {
    func addNewTracker(
        category: TrackerCategory,
        sheduleArr: [WeekDay],
        habitName: String,
        emoji: String,
        color: UIColor,
        pinned: Bool
    ) {
        let newTracker = Tracker(
            id: UUID(),
            name: habitName,
            color: color,
            emoji: emoji,
            pinned: pinned,
            shedule: sheduleArr
        )
        
        try? trackerStore.addNewTracker(tracker: newTracker, category: category)
        
        dismiss(animated: true)
    }
    
    func updateTracker(
        categoryName: String,
        shedule: [WeekDay],
        name: String,
        emoji: String,
        color: UIColor,
        id: UUID
    ) {
        try? trackerStore.updateTracker(categoryName: categoryName, shedule: shedule, name: name, emoji: emoji, color: color, id: id)
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.configureCell(
            tracker: tracker,
            isCompleted: isTrackerComleted(tracker.id),
            daysCount: getComletedCount(id: tracker.id),
            indexPath: indexPath,
            selectedDate: datePicker.date,
            pinned: tracker.pinned
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "headerCell",
            for: indexPath
        ) as? TrackerHeaderColletcionviewCell else {
            return UICollectionReusableView()
        }
        header.configureCell(header: visibleCategories[indexPath.section].header)
        
        return header
    }
}

//MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterButton.isHidden = visibleCategories.count == 0 && currentFilter == nil
        return visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        let id = "\(indexPath.row):\(indexPath.section)" as NSString
        let contextMenuConfiguration = UIContextMenuConfiguration(identifier: id, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu() }

            let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
            return self.configureContextMenu(tracker: tracker)
        }

        return contextMenuConfiguration
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        guard let identifier = configuration.identifier as? String else { return nil }
        let components = identifier.components(separatedBy: ":")

        guard let first = components.first,
              let last = components.last,
              let row = Int(first),
              let section = Int(last) else {
            return nil
        }
        let indexPath = IndexPath(row: row, section: section)

        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }

        return UITargetedPreview(view: cell.menuView)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 30)
    }
}

//MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func updateTrackerRecord(id: UUID, isCompleted: Bool, indexPath: IndexPath) {
        analyticsService.reportEvent(event: .click, params: [
            AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue,
            AnalyticsKeys.item.rawValue:AnalyticsItems.track.rawValue
        ])
        
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        
        if isCompleted {
            try? recordStore.addTrackerRecord(trackerRecord)
        } else {
            try? recordStore.deleteRecordWith(id: trackerRecord.id, date: trackerRecord.date)
        }
        
        guard let completedTrackers = try? recordStore.fetchTrackerRecords() else { return }
        self.completedTrackers = completedTrackers
        
        collectionView.reloadData()
        showFilteredTrackersByDay()
    }
}

//MARK: - TrackerCellDelegate
extension TrackerViewController: FiltesViewControllerDelegate {
    func changeCurrentFilter(_ filter: Filter) {
        currentFilter = filter
        canselSearch()
        
        switch currentFilter {
            case .todayTrackers:
                datePicker.date = Date()
                filterDate()
            default:
                updateCategories()
        }
    }
}

private extension TrackerViewController {
    //MARK: - Configurating functions
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        addSubViews()
        configureCollectionView()
        configureConstraints()
        
        showFilteredTrackersByDay()
        changeVisibility()
    }
    
    func configureCollectionView() {
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(
            TrackerHeaderColletcionviewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "headerCell"
        )
        
        collectionView.reloadData()
    }
    
    func addSubViews(){
        view.addSubview(topNavView)
        view.addSubview(collectionView)
        
        topNavView.addSubview(addButton)
        topNavView.addSubview(datePicker)
        topNavView.addSubview(titleLabel)
        topNavView.addSubview(stackViewForSearch)
        
        stackViewForSearch.addArrangedSubview(searchField)
        stackViewForSearch.addArrangedSubview(cancelSearchButton)
        
        view.addSubview(centerImageView)
        view.addSubview(centerLabel)
        
        view.addSubview(filterButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            topNavView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topNavView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            topNavView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            topNavView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            addButton.topAnchor.constraint(equalTo: topNavView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            
            datePicker.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: topNavView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 13),
            
            stackViewForSearch.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            stackViewForSearch.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor),
            stackViewForSearch.heightAnchor.constraint(equalToConstant: 30),
            stackViewForSearch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topNavView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            centerImageView.widthAnchor.constraint(equalToConstant: 80),
            centerImageView.heightAnchor.constraint(equalToConstant: 80),
            centerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            centerLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 8),
            centerLabel.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    //MARK: - Buttons functions
    @objc
    func addTracker() {
        analyticsService.reportEvent(event: .click, params: [
            AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue,
            AnalyticsKeys.item.rawValue:AnalyticsItems.add_track.rawValue
        ])
        
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        
        let navigatonViewController = UINavigationController(rootViewController: addNewTrackerViewController)
        present(navigatonViewController, animated: true)
    }
    
    @objc
    func filterDate() {
        showFilteredTrackersByDay()
    }
    
    @objc
    func canselSearch() {
        searchField.text = ""
        showFilteredTrackersByDay()
        cancelSearchButton.isHidden = true
        searchField.resignFirstResponder()
    }
    
    @objc
    func showFilters() {
        analyticsService.reportEvent(event: .click, params: [
            AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue,
            AnalyticsKeys.item.rawValue:AnalyticsItems.filter.rawValue
        ])
        
        let filtesViewController = FiltesViewController()
        
        filtesViewController.delegate = self
        filtesViewController.currentFiler = currentFilter
        
        present(filtesViewController, animated: true)
    }
    
    //MARK: - Private class functions
    func showFilteredTrackersByDay() {
        currentDate = datePicker.date
        
        guard let currentDate = currentDate else { return }
        
        let selectDay = Calendar.current.component(.weekday, from: currentDate)
        
        visibleCategories = categories.compactMap { category in
            let tracker = category.trackers.filter { tracker in
                let filterDatePicker = tracker.shedule.contains {
                    $0.numberOfDay == selectDay
                } == true
                
                let filterCompletedTrackers = completedTrackers.contains {
                    $0.id == tracker.id &&
                    Calendar.current.component(.weekday, from: $0.date) == selectDay
                }
                
                if currentFilter == .completedTrackers {
                    return filterDatePicker && filterCompletedTrackers
                } else if currentFilter == .uncompletedTrackers {
                    return filterDatePicker && !filterCompletedTrackers
                }
                
                return filterDatePicker
            }
            
            
            if tracker.isEmpty {
                return nil
            }
            
            return TrackerCategory(header: category.header, trackers: tracker)
        }
        
        collectionView.reloadData()
        changeVisibility()
    }
    
    func showFilteredTrackersByText(_ text: String) {
        let newText = text.lowercased()
        
        visibleCategories = categories.compactMap { category in
            let tracker = category.trackers.filter { tracker in
                let filterTextField = newText.isEmpty || tracker.name.lowercased().contains(newText)
                
                return filterTextField
            }
            
            if tracker.isEmpty {
                return nil
            }
            
            return TrackerCategory(header: category.header, trackers: tracker)
        }
        
        collectionView.reloadData()
        changeVisibility(search: true)
    }
    
    func changeVisibility(search: Bool = false) {
        var image = UIImage(named: "CenterImage")
        var text = NSLocalizedString("mes4", tableName: "LocalizableStr", comment: "")
        
        if search || (currentFilter != nil && currentFilter != .allTrackers) {
            image = UIImage(named: "CenterImageSearch")
            text = NSLocalizedString("mes5", tableName: "LocalizableStr", comment: "")
        }
        
        if visibleCategories.count == 0 {
            centerImageView.image = image
            centerLabel.text = text
            centerLabel.isHidden = false
            centerImageView.isHidden = false
        } else {
            centerLabel.isHidden = true
            centerImageView.isHidden = true
        }
    }
    
    func updateCategories() {
        guard let categories = try? categoryStore.fetchCategories() else { return }
        self.categories = categories
        self.visibleCategories = categories
        
        guard let completedTrackers = try? recordStore.fetchTrackerRecords() else { return }
        self.completedTrackers = completedTrackers
        
        guard let pinnedTrackers = try? trackerStore.fetchPinnedTrackers() else { return }
        self.pinnedTrackers = pinnedTrackers
        
        showPinnedTrackers()
        
        showFilteredTrackersByDay()
    }
    
    func isTrackerComleted(_ id: UUID) -> Bool {
        let calendar = Calendar.current
        return completedTrackers.contains { tracker in
            let date = calendar.isDate( tracker.date, inSameDayAs: datePicker.date)
            let id = tracker.id == id
            return id && date
        }
    }
    
    func getComletedCount(id: UUID) -> Int {
        var result: Int = 0
        
        completedTrackers.forEach { trackerRecord in
            if trackerRecord.id == id {
                result += 1
            }
        }
        return result
    }
    
    func configureContextMenu(tracker: Tracker) -> UIMenu {
        var titlePin: String
        if tracker.pinned {
            titlePin = NSLocalizedString("unpin", tableName: "LocalizableStr", comment: "")
        } else {
            titlePin = NSLocalizedString("pin", tableName: "LocalizableStr", comment: "")
        }
        let pin = UIAction(title: titlePin, image: nil) { [weak self] _ in
            guard let self = self else { return }
            try? self.trackerStore.changePinTracker(tracker)
        }
        
        let edit = UIAction(
            title: NSLocalizedString("edit", tableName: "LocalizableStr", comment: ""),
            image: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.analyticsService.reportEvent(event: .click, params: [
                AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue,
                AnalyticsKeys.item.rawValue:AnalyticsItems.edit.rawValue
            ])
            self.openEditViewController(for: tracker, daysCount: getComletedCount(id: tracker.id))
        }
        
        let delete = UIAction(
            title: NSLocalizedString("delete", tableName: "LocalizableStr", comment: ""),
            image: nil,
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.analyticsService.reportEvent(event: .click, params: [
                AnalyticsKeys.screen.rawValue:AnalyticsKeys.main.rawValue,
                AnalyticsKeys.item.rawValue:AnalyticsItems.delete.rawValue
            ])
            self.showDeleteAlert(for: tracker)
        }
        
        return UIMenu(children: [pin, edit, delete])
    }
    
    func showPinnedTrackers() {
        let headerPinned = NSLocalizedString("pinned", tableName: "LocalizableStr", comment: "")
        let indexPinnedCategory = categories.firstIndex { category in
            category.header == headerPinned
        }
        
        if let indexPinnedCategory = indexPinnedCategory {
            categories.remove(at: indexPinnedCategory)
        }
        
        if !pinnedTrackers.isEmpty {
            var nonPinned: [TrackerCategory] = []
            categories.forEach { category in
                let trackers = category.trackers.filter { tracker in
                    !tracker.pinned
                }
                
                nonPinned.append(
                    TrackerCategory(
                        header: category.header,
                        trackers: trackers
                    )
                )
            }
            categories = nonPinned
            categories.insert(
                TrackerCategory(
                    header: headerPinned,
                    trackers: pinnedTrackers
                ), at: 0)
        }
    }
    
    func openEditViewController(for tracker: Tracker, daysCount: Int) {
        let editViewController = CreateHabitViewController()
        
        editViewController.editTracker = tracker
        editViewController.editCount = daysCount
        editViewController.delegate = self
        editViewController.tableCellNames = [
            0: ["textField"],
            1: ["category","shedule"],
            2: ["emoji"],
            3: ["colors"]
        ]
        
        let navigatonViewController = UINavigationController(rootViewController: editViewController)
        present(navigatonViewController, animated: true)
    }
    
    func showDeleteAlert(for tracker: Tracker) {
        let alert = UIAlertController(
            title: NSLocalizedString("mes17", tableName: "LocalizableStr", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("delete", tableName: "LocalizableStr", comment: ""),
                                      style: .destructive) { [weak self] _ in
            try? self?.trackerStore.deleteTracker(tracker)
            try? self?.recordStore.deleteAllRecordsFor(id: tracker.id)
        })
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("cancel", tableName: "LocalizableStr", comment: ""),
            style: .cancel
        ) { _ in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
