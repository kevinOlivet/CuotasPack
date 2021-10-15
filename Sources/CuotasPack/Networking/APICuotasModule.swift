//
//  APICuotasModule.swift
//  CuotasModule
//
//  Created by Jon Olivet on 8/28/18.
//  Copyright © 2018 Jon Olivet. All rights reserved.
//

import Alamofire
import CommonsPack

protocol APICuotasModuleProtocol {

    func getPaymentMethods(success: @escaping (_ result: [PaymentMethodModel], Int) -> Void,
                           failure: @escaping (_ error: APIManagerError, Int) -> Void)

    func getBankSelect(selectedPaymentMethodId: String,
                       success: @escaping (_ result: [BankSelectModel], Int) -> Void,
                       failure: @escaping (_ error: APIManagerError, Int) -> Void)

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   success: @escaping (_ result: [CuotasResult], Int) -> Void,
                   failure: @escaping (_ error: APIManagerError, Int) -> Void)
}

class APICuotasModule: APICuotasModuleProtocol {

    let apiManager: APIManagerProtocol = APIManager.shared

    // PaymentMethod
    func getPaymentMethods(success: @escaping (_ result: [PaymentMethodModel], Int) -> Void,
                           failure: @escaping (_ error: APIManagerError, Int) -> Void) {

        let url = Configuration.Api.paymentMethods

        apiManager.get(uri: url)  { (result: Result<[PaymentMethodModel], APIManagerError>) in
            switch result {
            case .success(let items):
                success(items, 200)
            case .failure(let err):
                failure(err, Int(err.statusCode)!)
            }
        }
//        self.requestGeneric(
//            type: [PaymentMethodModel].self,
//            url: url,
//            method: HTTPMethod.get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            validStatusCodes: [Int](200..<300),
//            onSuccess: { paymentMethodModelResult, _, statusCode in
//                success(paymentMethodModelResult!, statusCode!)
//            }, onFailure: { error, statusCode in
//                failure(error, statusCode)
//            }
//        )
    }

    // BankSelect
    func getBankSelect(selectedPaymentMethodId: String,
                       success: @escaping (_ result: [BankSelectModel], Int) -> Void,
                       failure: @escaping (_ error: APIManagerError, Int) -> Void) {

        let url = Configuration.Api.bankSelect + "&payment_method_id=\(selectedPaymentMethodId)"

        apiManager.get(uri: url)  { (result: Result<[BankSelectModel], APIManagerError>) in
            switch result {
            case .success(let items):
                success(items, 200)
            case .failure(let err):
                failure(err, Int(err.statusCode)!)
            }
        }
//        self.requestGeneric(
//            type: [BankSelectModel].self,
//            url: url,
//            method: HTTPMethod.get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            validStatusCodes: [Int](200..<300),
//            onSuccess: { bankSelectModelResult, _, statusCode in
//                success(bankSelectModelResult!, statusCode!)
//            }, onFailure: { error, statusCode in
//                failure(error, statusCode)
//            }
//        )
    }

    // Cuotas Methods

    func getCuotas(amountEntered: Int,
                   selectedPaymentMethodId: String,
                   bankSelectedId: String,
                   success: @escaping (_ result: [CuotasResult], Int) -> Void,
                   failure: @escaping (_ error: APIManagerError, Int) -> Void) {

        let url = Configuration.Api.cuotas + "&amount=\(amountEntered)&payment_method_id=\(selectedPaymentMethodId)&issuer.id=\(bankSelectedId)"

        apiManager.get(uri: url)  { (result: Result<[CuotasResult], APIManagerError>) in
            switch result {
            case .success(let items):
                success(items, 200)
            case .failure(let err):
                failure(err, Int(err.statusCode)!)
            }
        }

//        self.requestGeneric(
//            type: [CuotasResult].self,
//            url: url,
//            method: HTTPMethod.get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            validStatusCodes: [Int](200..<300),
//            onSuccess: { cuotasResult, _, statusCode in
//                success(cuotasResult!, statusCode!)
//            }, onFailure: { error, statusCode in
//                failure(error, statusCode)
//            }
//        )
    }
}
