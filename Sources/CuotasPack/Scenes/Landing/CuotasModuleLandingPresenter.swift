//
//  CuotasModuleLandingPresenter.swift
//  Pods
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

import UIKit

protocol CuotasModuleLandingPresentationLogic {
    func presentSetupUI(response: CuotasModuleLanding.Basic.Response)
}

class CuotasModuleLandingPresenter: CuotasModuleLandingPresentationLogic {
    weak  var viewController: CuotasModuleLandingDisplayLogic?

    // MARK: Methods

    func presentSetupUI(response: CuotasModuleLanding.Basic.Response) {
        let viewModel = CuotasModuleLanding.Basic.ViewModel(
            title: NSLocalizedString(response.title, bundle: .module, comment: ""),
            subtitle: NSLocalizedString(response.subtitle, bundle: .module, comment: "")
        )
        viewController?.displaySetupUI(viewModel: viewModel)
    }
}
