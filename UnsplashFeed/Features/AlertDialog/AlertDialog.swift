import UIKit

final class AlertDialog {
    static func showAlert(_ controller: AlertPresenterProtocol, model: AlertDialogModel) {
        let alert = UIAlertController(
            title: model.title ,
            message: model.message,
            preferredStyle: .alert
        )
        let actionApply = UIAlertAction(
            title: model.applyTitle,
            style: .default,
            handler: model.applyAction
        )
        alert.addAction(actionApply)
        
        if let action = model.cancelAction {
            let actionCancel = UIAlertAction(
                title: model.cancelTitle,
                style: .default,
                handler: action
            )
            alert.addAction(actionCancel)
        }
        
        controller.present(alert)
    }
    
    static func createDialogModel(
        title: String,
        message: String,
        applyTitle: String,
        cancelTitle: String = "Отмена",
        applyAction: @escaping (UIAlertAction) -> Void,
        cancelAction: ((UIAlertAction) -> Void)? = nil
    ) -> AlertDialogModel {
        return AlertDialogModel(
            title: title,
            message: message,
            applyTitle: applyTitle,
            cancelTitle: cancelTitle,
            applyAction: applyAction,
            cancelAction: cancelAction
        )
    }
}
