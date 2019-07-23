import NSelect

public class NSelectViewCheckBox: UIView, NSelectView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var backing: NSelect = NSelect()
    
    public var delegate: NSelectViewDelegate?
    
    private lazy var bundle: Bundle = {
        
        let url = Bundle(for: self.classForCoder).url(forResource: "NSelectViewCheckBox", withExtension: "bundle")
        if url == nil {
            print("failed to load bundle")
        }
        
        let bundle = Bundle(url: url!)
        if bundle == nil {
            print("failed to load bundle")
        }
        
        return bundle!
    }()
    
    public func present() {
        
        // clear all exisiting subviews
        // making sure this is the only view to be added there
        // useful for cells
        
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 2
        let nib = bundle.loadNibNamed("NSelectViewCheckBox", owner: self, options: nil)
        
        // 3
        let view = nib?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        titleLabel.text = backing.title
        
        setupCollectionView()
        
        // show default if any
        //  preselectDefaults()
    }
    
    func setupCollectionView() {
        
        let nib = UINib(nibName: "OptionViewCell", bundle: bundle)
        
        collectionView.register(nib, forCellWithReuseIdentifier: OptionViewCell.ID)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        collectionView.allowsMultipleSelection = (backing.mode == .multiple)
    }
    
    
    func preselectDefaults() {
        backing.defaultSelections?.forEach {
            if let idx = backing.options.firstIndex(of: $0) {
                let ip = IndexPath(item: idx, section: 0)
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: ip)
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        
        let itemsPerRow = CGFloat(2)
        let rowSize = CGFloat(50)  // 10 + 30 + 10
        
        let th = self.titleLabel.frame.height
        
        let ch = CGFloat( ceil (  CGFloat(backing.options.count) / itemsPerRow ) * rowSize )
        let hh = 8 + th + 8 + 1 + ch + (50/2)
        return CGSize(width: 300, height: hh)
    }
    
}

extension NSelectViewCheckBox: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backing.options.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionViewCell.ID, for: indexPath) as! OptionViewCell
        
        cell.meta = OptionViewCell.Data(title: backing.options[indexPath.item],
                                        selected: false)
        
        return cell
    }
    
}


extension NSelectViewCheckBox: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let option = backing.options[indexPath.item]
        backing.select(option: option)
        
        let cell = (collectionView.cellForItem(at: indexPath) as! OptionViewCell)
        cell.checkBox.isSelected = true
        
        delegate?.didSelect(self, item: option)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let option = backing.options[indexPath.item]
        backing.deselect(option: option)
        
        let cell = (collectionView.cellForItem(at: indexPath) as! OptionViewCell)
        cell.checkBox.isSelected = false
        
        delegate?.didDeselect(self, item: option)
    }
    
}


// the trickies part
extension NSelectViewCheckBox: UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = self.collectionView.frame.size.width * 0.4
        let h = CGFloat(50)
        return CGSize(width: w, height: h)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
