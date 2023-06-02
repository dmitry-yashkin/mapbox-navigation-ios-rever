import CarPlay

public extension CPInterfaceController {
    
    /**
     Allows to safely pop existing `CPTemplate`.
     
     In case if there is only one `CPTemplate` left in the stack of templates, popping operation
     will not be performed.
     
     - parameter animated: Boolean flag which determines whether `CPTemplate` popping will be
     animated or not.
     */
    func safePopTemplate(animated: Bool) {
        if templates.count == 1 { return }
        
        if #available(iOS 14.0, *) {
            popTemplate(animated: animated) { (success, error) in
                if let error = error {
                    print("CarPlay error: \(error.localizedDescription)")
                }
            }
        } else {
            popTemplate(animated: animated)
        }
    }
}
