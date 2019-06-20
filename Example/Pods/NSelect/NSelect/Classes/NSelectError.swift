
public enum NSelectError: Error {
    case NotReady
    case InvalidSelection(option: String)
    case Unknown(hint: String?)
}
