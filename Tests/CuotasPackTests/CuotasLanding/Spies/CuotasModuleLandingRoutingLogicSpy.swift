//
//  CuotasModuleLandingRoutingLogicSpy.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

@testable import CuotasPack
import Foundation

class CuotasModuleLandingRoutingLogicSpy: NSObject, CuotasModuleLandingRoutingLogic, CuotasModuleLandingDataPassing {

    var dataStore: CuotasModuleLandingDataStore?
    var routeToCuotasModuleCalled = false

    func routeToCuotasModule() {
        routeToCuotasModuleCalled = true
    }
}
