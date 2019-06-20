
public protocol NSelectView {
    var backing: NSelect { get set }
    func present()

    var delegate: NSelectViewDelegate? { get set }
}

public protocol NSelectViewDelegate {

    func didSelect(_ view: NSelectView, item: String)
    func didDeselect(_ view: NSelectView, item: String)
}
