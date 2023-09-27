import UIKit

final class AlertDialog {
    static func showAlert(_ controller: AlertPresenterProtocol, model: AlertDialogModel) {
        let alert = UIAlertController(
            title: model.title ,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: model.buttonTitle,
            style: .default,
            handler: model.completion
        )
        alert.addAction(action)
        controller.present(alert)
    }
}
