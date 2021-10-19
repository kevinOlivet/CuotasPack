//
//  EnterAmountCleanPresenter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIElementsPack
import Foundation

protocol EnterAmountCleanPresentationLogic {
    func presentSetUpUI(response: EnterAmountClean.Texts.Response)
    func presentTextFieldWithRegexNumber(response: EnterAmountClean.Regex.Response)
    func presentPaymentMethod()
    func presentCatchCuotaAlert(response: EnterAmountClean.CatchNotification.Response)
    func presentInputAlert(response: EnterAmountClean.Errors.Response)
}

class EnterAmountCleanPresenter: EnterAmountCleanPresentationLogic {
    
    weak var viewController: EnterAmountCleanDisplayLogic?
    
    // MARK: Methods
    func presentSetUpUI(response: EnterAmountClean.Texts.Response) {
        let viewModel = EnterAmountClean.Texts.ViewModel(
            title: NSLocalizedString(response.title, bundle: .module, comment: ""),
            enterAmountLabel: NSLocalizedString(response.enterAmountLabel, bundle: .module, comment: ""),
            nextButton: NSLocalizedString(response.nextButton, bundle: .module, comment: "")
        )
        viewController?.displaySetUpUI(viewModel: viewModel)
    }
    
    func presentTextFieldWithRegexNumber(response: EnterAmountClean.Regex.Response) {
        let viewModel = EnterAmountClean.Regex.ViewModel(numberToUse: response.numberToUse)
        viewController?.displayTextFieldWithRegexNumber(viewModel: viewModel)
    }
    
    func presentPaymentMethod() {
        viewController?.showPaymentMethod()
    }
    
    func presentCatchCuotaAlert(response: EnterAmountClean.CatchNotification.Response) {
        let viewModel = EnterAmountClean.CatchNotification.ViewModel(
            successTitle: NSLocalizedString(response.successTitle, bundle: .module, comment: ""),
            successMessage: NSLocalizedString(response.successMessage, bundle: .module, comment: ""),
            buttonTitle: NSLocalizedString(response.buttonTitle, bundle: .module, comment: "")
        )
        viewController?.displayCatchCuotaAlert(viewModel: viewModel)
    }
    
    func presentInputAlert(response: EnterAmountClean.Errors.Response) {
        let viewModel = EnterAmountClean.Errors.ViewModel(
            errorTitle: NSLocalizedString(response.errorTitle, bundle: .module, comment: ""),
            errorMessage: NSLocalizedString(response.errorMessage, bundle: .module, comment: ""),
            buttonTitle: NSLocalizedString(response.buttonTitle, bundle: .module, comment: ""),
            image: MainAsset.iconCloseBlack.image
        )
        viewController?.displayInputAlert(viewModel: viewModel)
    }

}
