//
//  DefaultNSelectView.swift
//  NSelect
//
//  Created by iOSDev on 13/06/19.
//

public class DefaultNSelectView: UIView, NSelectView {
    
    public var backing: NSelect = NSelect()
    
    public var delegate: NSelectViewDelegate?
    
    var tableView: UITableView = UITableView()
    
    public func present() {
        
        tableView.frame = self.bounds
        addSubview(tableView)
        
        // setup
        if backing.mode == .multiple {
            tableView.allowsMultipleSelection = true
        } else {
            tableView.allowsMultipleSelection = false
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.reloadData()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        // sizing
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 42
        tableView.sectionHeaderHeight = 40
   

        // lock in layout
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // select the default by default
        backing.defaultSelections?.forEach { defaultOption in
            if let idx = backing.options.firstIndex(of: defaultOption) {
                tableView.delegate?.tableView?(tableView,
                                               didSelectRowAt: IndexPath(row: idx, section: 0))
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        
        let h = (tableView.rowHeight
            * CGFloat(tableView.numberOfRows(inSection: 0))
            + tableView.sectionHeaderHeight)
        tableView.frame.size.height = h
        
        var size = super.intrinsicContentSize
        size.height = h
        
        return size
    }
    
}


extension DefaultNSelectView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backing.options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = backing.options[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return backing.title
    }
}

extension DefaultNSelectView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let option = backing.options[indexPath.row]
        backing.select(option: option)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        delegate?.didSelect(self, item: option)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let option = backing.options[indexPath.row]
        backing.deselect(option: option)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        delegate?.didDeselect(self, item: option)
    }
}
