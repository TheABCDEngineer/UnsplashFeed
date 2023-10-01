import Foundation

protocol ImageListCellDelegate {
    func changeLike(
        for photoModelNumber: Int,
        _ completion: @escaping (Bool) -> Void
    )
}
