import Foundation

final class Queue<Parameter> {
    private var parameters = [Parameter?]()
    private var action: ((Parameter?) -> Void)?
    
    func add(_ parameter: Parameter?) {
        parameters.append(parameter)
        if parameters.count > 1 { return }
        next()
    }
    
    func setAction(_ action: @escaping (Parameter?) -> Void) {
        self.action = action
        next()
    }
    
    func next() {
        if parameters.isEmpty { return }
        let parameter = parameters[0]
        parameters.remove(at: 0)
        action?(parameter)
    }
    
    func reset() {
        parameters.removeAll()
    }
}
