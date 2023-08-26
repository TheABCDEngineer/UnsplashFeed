import UIKit

struct AlertDialogModel {
    let title: String
    let message: String
    let buttonTitle: String
    let completion: (UIAlertAction) -> Void
}
