
public class NSelect {
    
    // mandatory properties
    public var options: [String]
    public var mode: NSelectMode = .single {
        didSet { reset() }
    }
    
    // provided for your convenience
    // not really be of use for the unit itself
    public var title: String?
    public var defaultSelections: [String]?
    
    
    // troubleshooting
    public var error: NSelectError?
    public var isReady: Bool {
        return error == nil ? true : false
    }
    
    // initializers
    public init(options: [String], mode: NSelectMode = .single) {
        self.options = options
        self.mode    = mode
    }
    
    // core fun part
    private var _selections: [String]?
    
    public func selections() -> [String]? {
        
        guard let selections = _selections else {
            return nil
        }
        
        guard Set(selections).count == selections.count else {
            self.error = .Unknown(hint: "Inconsistency selections")
            return nil
        }
        
        return _selections
    }
    
    public func select(option: String) {
        
        guard options.contains(option) else {
            self.error = .InvalidSelection(option: option)
            return
        }
        
        _select(option: option)
    }
    
    private func _select(option: String) {
        
        switch mode {
        case .single:
            _selections = [option]
            
        case .multiple:
            if _selections == nil { _selections = [] }
            _selections?.append(option)
        }
    }
    
    public func deselect(option: String) {
        
        guard options.contains(option) else {
            self.error = .InvalidSelection(option: option)
            return
        }
        
        _selections?.removeAll(where: { $0 == option })
    }
    
    public func reset() {
        _selections?.removeAll()
    }
    
}


// MARK: Convenience Initializers
public extension NSelect {
    
    convenience init(options: String..., mode: NSelectMode = .single) {
        self.init(options: options, mode: mode)
    }
    
    convenience init() {
        self.init(options: [])
        self.error = .NotReady
    }
}


// MARK: Selects
public extension NSelect {
    
    func selectCarefully(option: String) throws {
        
        guard options.contains(option) else {
            throw NSelectError.InvalidSelection(option: option)
        }
        
        _select(option: option)
    }
    
    func select(options: [String]) {
        options.forEach { self.select(option: $0) }
    }
    
    func select(options: String...) {
        select(options: options)
    }
    
}


// MARK: Deselects
public extension NSelect {
    
    func deselectCarefully(option: String) throws {
        
        guard options.contains(option) else {
            throw NSelectError.InvalidSelection(option: option)
        }
        
        _selections?.removeAll(where: { $0 == option })
    }
    
    func deselect(options: [String]) {
        options.forEach { self.deselect(option: $0) }
    }
    
    func deselect(options: String...) {
        deselect(options: options)
    }
    
}
