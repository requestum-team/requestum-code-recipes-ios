import UIKit

import SwiftyStoreKit
import StoreKit
import SVProgressHUD
import Alamofire
import FacebookCore

let productIdUpgardeFullAccess = ""

class ProductManager {
    
    
    static let shared = ProductManager()
    
    
    // MARK: - Properties
    
    var productIdSubscriptions: [String] = [productIdUpgardeFullAccess]
    
    
    // MARK: - SwiftyStoreKit Actions
    
    func isSubscriptionsPurchased() -> Bool {
        
        return false
    }
    
    func appDidFinishLaunching() {
        
        ProductManager.shared.completeTransactions()
        ProductManager.shared.getProductsPrices()
    }
    
    
    // MARK: - SwiftyStoreKit ApiCalls
    
    func purchaseProduct(_ productId: String, completion: @escaping (_ error: APIError?, _ productId: String?, _ transactionId: String?) -> Void) {
        
        SwiftyStoreKit.purchaseProduct(productId) { [weak self] result in
            
            switch result {
                
            case .success(let purchaseResult):
                
                if var productPrice = self?.getPrice(for: productId) {
                    
                    productPrice.remove(at: productPrice.startIndex)
                    
                    guard let double = Double(productPrice) else {
                        return completion(nil, purchaseResult.productId, nil)
                    }
                    
                    AppEventsLogger.log(.purchased(amount: double))
                }
                
                return completion(nil, purchaseResult.productId, nil)
                
            case .error(let error):
                
                return completion(APIError(response: nil, data: nil, error: error), nil, nil)
            }
        }
    }
    
    func fetchReceipt(_ transactionId: String?, _ completion: @escaping (_ error: APIError?) -> Void) {
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self] result in
            
            switch result {
            case .success(let receiptData):
                
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                self?.patchReceipt(receipt: encryptedReceipt, completion)
                
            case .error(let error):
                
                completion(APIError(response: nil, data: nil, error: error))
            }
        }
    }
    
    func getProductInfo(_ productId: String, completion: @escaping (_ error: APIError?, _ product: SKProduct?) -> Void) {

        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            
            if let product = result.retrievedProducts.first {
                completion(nil, product)
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid product identifier: \(invalidProductId)"])
                return completion(APIError(response: nil, data: nil, error: error), nil)
                
            } else {
                return completion(APIError(response: nil, data: nil, error: result.error), nil)
            }
        }
    }
    
    func getProductsInfo(_ productsId: [String], completion: ((_ invalidProductIDs: Set<String>?, _ retrievedProducts: Set<SKProduct>?) -> Void)? = nil) {
        
        let productsIdSet = Set(productsId)
        
        SwiftyStoreKit.retrieveProductsInfo(productsIdSet) { result in
            
            completion?(result.invalidProductIDs, result.retrievedProducts)
        }
    }
    
    func restoreProducts(_ completion: @escaping (_ error: APIError?) -> Void) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            
            if results.restoreFailedPurchases.count > 0 {
             
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: R.string.alerts.alertErrorRestored()])
                completion(APIError(response: nil, data: nil, error: error))
            } else if results.restoredPurchases.count > 0 {
               
                self?.fetchReceipt( results.restoredPurchases.first?.productId, completion)
            } else {
                
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: R.string.alerts.alertNothingToRestore()])
                completion(APIError(response: nil, data: nil, error: error))
            }
        }
    }
    
    func completeTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            
            for product in products {
                
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    
                    if product.needsFinishTransaction {
                        
                        // Deliver content from server if needed
                        
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                }
            }
        }
    }
}


// MARK: - ProductPrice

extension ProductManager {
    
    func getProductsPrices(completion: (() -> Void)? = nil) {
        
        let subscriptions = [productIdUpgardeFullAccess]
        
        ProductManager.shared.getProductsInfo(subscriptions) { _, retrievedProducts in
            
            guard let retrievedProducts = retrievedProducts else {
                return
            }
            
            for retrievedProduct in retrievedProducts {
                
                guard let localizedPrice = retrievedProduct.localizedPrice else {
                    return
                }
                
                self.setPrice(for: retrievedProduct.productIdentifier, localizedPrice)
            }
            
            completion?()
        }
    }
    
    func getPrice(for productId: String) -> String? {
        
        guard let productPrice = StoreManager.shared.productsPrice?[productId] else {
            return nil
            
        }
        return productPrice
    }
    
    func setPrice(for productId: String, _ productPrice: String) {
        
        if StoreManager.shared.productsPrice == nil {
            StoreManager.shared.productsPrice = [:]
        }
        
        StoreManager.shared.productsPrice?[productId] = productPrice
    }
}


// MARK: - SKError handler

extension ProductManager {
    
    func getErrorDescription(from skError: SKError) -> String {
        
        switch skError.code {
            
        case .paymentCancelled:
            return R.string.profile.paymentCancelledError()
        case .paymentInvalid:
            return R.string.profile.paymentInvalidError()
        case .paymentNotAllowed:
            return R.string.profile.paymentNotAllowedError()
        case .storeProductNotAvailable:
            return R.string.profile.storeProductNotAvailableError()
        case .cloudServicePermissionDenied:
            return R.string.profile.cloudServicePermissionDeniedError()
        case .cloudServiceNetworkConnectionFailed:
            return R.string.profile.cloudServiceNetworkConnectionFailedError()
        case .cloudServiceRevoked:
            return R.string.profile.cloudServiceRevokedError()
        case .unknown:
            return R.string.profile.unknownError()
        case .clientInvalid:
            return R.string.profile.clientInvalidError()
        case .privacyAcknowledgementRequired:
            return R.string.profile.privacyAcknowledgementRequiredError()
        case .unauthorizedRequestData:
             return R.string.profile.unauthorizedRequestDataError()
        case .invalidOfferIdentifier:
             return R.string.profile.invalidOfferIdentifierError()
        case .invalidSignature:
             return R.string.profile.invalidSignatureError()
        case .missingOfferParams:
             return R.string.profile.missingOfferParamsError()
        case .invalidOfferPrice:
             return R.string.profile.invalidOfferPriceError()
        }
    }
}


// MARK: - API calls

extension ProductManager {
    
    private func patchReceipt(receipt: String, _ completion: @escaping (_ error: APIError?) -> Void) {

        guard let userId = App.userSession.currentUser?.id else {
            return completion(nil)
        }
    
        App.apiClient.purchaseSubsribtion(userId: String(userId), receipt: receipt) { response in

            switch response.result {

            case .failure(let error):

                return completion(error)
            case .success(let user):
                App.userSession.currentUser = user
                completion(nil)
            }
        }
    }
}
