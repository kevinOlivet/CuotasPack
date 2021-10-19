//
//  CuotasModuleLandingRouter.swift
//  Pods
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

import CommonsPack
import UIKit

@objc
protocol CuotasModuleLandingRoutingLogic {
    func routeToCuotasModule()
}

protocol CuotasModuleLandingDataPassing {
    var dataStore: CuotasModuleLandingDataStore? { get }
}

class CuotasModuleLandingRouter: NSObject, CuotasModuleLandingRoutingLogic, CuotasModuleLandingDataPassing {
    weak var viewController: CuotasModuleLandingViewController?
    var dataStore: CuotasModuleLandingDataStore?

    // MARK: Routing

    func routeToCuotasModule() {
        let storyboard = UIStoryboard(
            name: "CuotasMain",
            bundle: Bundle.module
        )
        let destinationNVC = storyboard.instantiateInitialViewController() as! UINavigationController
        destinationNVC.modalPresentationStyle = .fullScreen
        navigateToCuotasModule(source: viewController!, destination: destinationNVC)
    }

    // MARK: Navigation
    func navigateToCuotasModule(source: CuotasModuleLandingViewController, destination: UINavigationController) {
        source.present(destination, animated: true, completion: nil)
    }
}
