//  ApiStore.swift
//  MyOutdoorAgent

import UIKit
import Alamofire
import PKHUD

class ApiStore : NSObject {
    
    // MARK: - Shared Instance
    static let shared = ApiStore()
    
    var isShowLoader = true
    var authHeaders : [String : String] = [String: String]()
    
    // MARK: - Functions
    func handleErrorCase(_ statusCode : Int?, _ dict : NSDictionary?) {
        let msg = dict?.value(forKey: "message") as? String
        print("msg->", msg)
        print("statusCode->",statusCode!)
        HUD.hide()
        
        if msg != nil {
            if msg == AppErrors.sessionExpire.localizedDescription {
                HUD.flash(.labeledError(title: EMPTY_STR, subtitle: msg), onView: UIApplication.visibleViewController.view, delay: 1.5) { _ in
                    self.goToLogin()
                }
            } else {
                HUD.show(.labeledError(title: EMPTY_STR, subtitle: msg))
            }
        }
    }
    
    // -- Go to Login Page
    func goToLogin(){
        let refreshAlert = UIAlertController(title: AppAlerts.alert.title, message: CommonKeys.tokenExpired.name, preferredStyle: UIAlertController.Style.alert)
        LocalStore.shared.userId = EMPTY_STR
        refreshAlert.addAction(UIAlertAction(title: ButtonText.ok.text, style: .default, handler: { (action: UIAlertAction!) in
            let loginVC = UIStoryboard(name: Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Navigation.loginNav.name)
            UIApplication.shared.currentWindow?.rootViewController = loginVC
            UIApplication.shared.currentWindow?.makeKeyAndVisible()
        }))
        
        UIApplication.shared.currentWindow?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    // -- To check whether the json is valid or not
    func isValidJson(check data: Data) -> Bool {
        do {
            if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                return true
            } else if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    
    // MARK: - Base Request API
    func baseRequestApi<T: Codable>(_ url: URLConvertible, _ method : HTTPMethod, _ params: [String: Any]? = nil, _ headers: [String: String]? = nil, completion: @escaping (_ response : T?) -> Void){
        
        print("method",method)
        print("url",url)
        print("params",params)
        print("headers",headers)
        
        
        if Reachability.isConnectedToInternet {
            AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers?.toHeader()) { $0.timeoutInterval = 10 }.validate().responseDecodable(of: T.self) { response in
                print("@@@@######",response)
                if response.data != nil {
                    if response.response?.statusCode == 200 {
                        do {
                            if let jsonData = response.data {
//                                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                                       print("Raw JSON Response: \(jsonString)")
//                                   } else {
//                                       print("Failed to convert response data to string")
//                                   }
                                                               print("response.data",response.data)
                                                               print("jsonData",jsonData)
                                                               
                               
                                if self.isValidJson(check: jsonData) {
                                    do {
                                        print(jsonData)
                                         print(jsonData.base64EncodedString())
                                        let dataModel = try JSONDecoder().decode(T.self, from: jsonData)
                                        completion(dataModel)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    
                                } else {
                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                                        UIApplication.shared.windows.first?.rootViewController = vC
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else if (response.response?.statusCode == 400) || (response.response?.statusCode == 401) {
                        do {
                            if let jsonData = response.data {
                                if self.isValidJson(check: jsonData) {
                                    let dataModel = try JSONDecoder().decode(T.self, from: jsonData)
                                    completion(dataModel)
                                } else {
                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                                        UIApplication.shared.windows.first?.rootViewController = vC
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else if response.response?.statusCode == 500 {
                        do {
                            if let jsonData = response.data {
                                print(jsonData)
                                if self.isValidJson(check: jsonData) {
                                    let dataModel = try JSONDecoder().decode(T.self, from: jsonData)
                                    completion(dataModel)
                                } else {
                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                                        UIApplication.shared.windows.first?.rootViewController = vC
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        do {
                            if let jsonData = response.data {
                                if self.isValidJson(check: jsonData) {
                                    let dataModel = try JSONDecoder().decode(T.self, from: jsonData)
                                    completion(dataModel)
                                    self.handleErrorCase(response.response?.statusCode, dataModel as? NSDictionary)
                                } else {
                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                                        UIApplication.shared.windows.first?.rootViewController = vC
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                                    }
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                        UIApplication.shared.windows.first?.rootViewController = vC
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                }
            }
        } else {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.internetConnection.localizedDescription), delay: 1.0)
        }
    }
    func baseRequestApi1<T: Codable>(_ url: URLConvertible, _ method: HTTPMethod, _ params: [String: Any]? = nil, _ headers: [String: String]? = nil, completion: @escaping (T?) -> Void) {
        print(method)
        print(url)
        print(params ?? "No parameters")
        print(headers ?? "No headers")
        
        if Reachability.isConnectedToInternet {
            AF.upload(multipartFormData: { multipartFormData in
                params?.forEach { key, value in
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }, to: url, method: method, headers: HTTPHeaders(headers ?? [:]))
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let dataModel):
                    completion(dataModel)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    
                    if let responseData = response.data {
                        print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "No response data")")
                        HUD.flash(.labeledError(title: "Error", subtitle: "Request failed with status code \(response.response?.statusCode ?? 0)."), delay: 1.0)
                    } else {
                        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 1.0)
                    }
                    completion(nil)
                }
            }
        } else {
            HUD.flash(.labeledError(title: "Error", subtitle: "No internet connection."), delay: 1.0)
        }
    }

    


    


    private func isValidJsons(check data: Data) -> Bool {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) != nil
    }

   

    

    
    // MARK: - SOCIAL REGISTER API
    func socialRegisterApi(_ view: UIView, _ firstName: String, _ streetAddress: String, _ city: String, _ st: String, _ zip: String, _ phone: String, _ groupName: String, _ getNotifications: Bool, _ isBlacklisted: Bool, _ email: String, _ password: String, _ accountType: Int, _ authenticationKey: String, _ authorizationKey: String, _ authenticationType: String, _ sourceClientID: Int, completion: @escaping(_ : SocialRegisterModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let registerParams : [String: Any] = [
            SocialRegisterApi.firstName                     :       firstName,
            SocialRegisterApi.streetAddress                 :       streetAddress,
            SocialRegisterApi.city                          :       city,
            SocialRegisterApi.st                            :       st,
            SocialRegisterApi.zip                           :       zip,
            SocialRegisterApi.phone                         :       phone,
            SocialRegisterApi.groupName                     :       groupName,
            SocialRegisterApi.getNotifications              :       getNotifications,
            SocialRegisterApi.isBlacklisted                 :       isBlacklisted,
            SocialRegisterApi.email                         :       email,
            SocialRegisterApi.password                      :       password,
            SocialRegisterApi.accountType                   :       accountType,
            SocialRegisterApi.authenticationKey             :       authenticationKey,
            SocialRegisterApi.authorizationKey              :       authorizationKey,
            SocialRegisterApi.authenticationType            :       authenticationType,
            SocialRegisterApi.sourceClientID                :       sourceClientID
        ]
        
        baseRequestApi(SocialRegisterApi.baseApi, .post, registerParams, headers) { (result: SocialRegisterModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - REGISTER API
    func registerApi(_ view: UIView, _ firstName: String, _ lastName: String, _ email: String, _ password: String, _ confirmPassword: String, _ accountType: String, _ authenticationKey: String, _ authenticationType: String, _ sourceClientID: String, completion: @escaping(_ : RegisterModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let registerParams : [String: String] = [
            RegisterApi.firstName              :       firstName,
            RegisterApi.lastName               :       lastName,
            RegisterApi.email                  :       email,
            RegisterApi.password               :       password,
            RegisterApi.confirmPassword        :       confirmPassword,
            RegisterApi.accountType            :       accountType,
            RegisterApi.authenticationKey      :       authenticationKey,
            RegisterApi.authenticationType     :       authenticationType,
            RegisterApi.sourceClientID         :       sourceClientID
        ]
        
        baseRequestApi(RegisterApi.baseApi, .post, registerParams, headers) { (result: RegisterModel?) in
            print("1233",result!)
            completion(result!)
        }
    }
    
    // MARK: - LOGIN API
    func loginApi(_ view: UIView, _ email: String, _ password: String, _ authorizationKey: String, _ authenticationType: String, completion: @escaping(_ : LoginModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let loginParams : [String: String] = [
            LoginApi.email                  :       email,
            LoginApi.password               :       password,
            LoginApi.authorizationKey       :       authorizationKey,
            LoginApi.authenticationType     :       authenticationType
        ]
        
        baseRequestApi(LoginApi.baseApi, .post, loginParams, headers) { (result: LoginModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - FORGOT PASSWORD API
    func forgotPasswordApi(_ view: UIView, _ email: String, completion: @escaping(_ : ForgotPasswordModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let forgotPassParams : [String : String] = [
            ForgotPasswordApi.email          :       email,
        ]
        
        baseRequestApi(ForgotPasswordApi.baseApi, .post, forgotPassParams, headers) { (result: ForgotPasswordModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - FORGOT PASSWORD API
    func forgotPasswordApiMoa(_ view: UIView, _ email: String, completion: @escaping(_ : ForgotPasswordModelMoa) -> Void) {
        HUD.show(.progress, onView: view)
        
        let forgotPassParams : [String : String] = [
            ForgotPasswordApi.email          :       email,
        ]
        
        baseRequestApi(ForgotPasswordApi.baseApi, .post, forgotPassParams, headersMoa) { (result: ForgotPasswordModelMoa?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - FORGOT PASSWORD API
    func sendVerificationCodeMoa(_ view: UIView, 
                                  _ Type: String,
                                  _ Email: String,
                                  _ Phone: String,
                                  _ Name: String,
                                  _ PublicKey: String,
                                  completion: @escaping(_ : SendVerificationCodeModelMoa) -> Void) {
        HUD.show(.progress, onView: view)
        
        let sendVerificationCodeModeParams : [String : String] = [
            "Type" : Type,
            "Email" : Email,
            "Phone" : Phone,
            "Name" : Name,
            "PublicKey" : PublicKey,
        ]
        
        baseRequestApi((Apis.baseUrl) + "account/sendverificationcode", .post, sendVerificationCodeModeParams, headersMoa) { (result: SendVerificationCodeModelMoa?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - Verify Code
    func verifyCodeMoa(_ view: UIView,
                       _ PublicKey: String,
                       _ Token: String,
                       completion: @escaping(_ : SendVerificationCodeModelMoa) -> Void) {
        HUD.show(.progress, onView: view)
        
        let sendVerificationCodeModeParams : [String : String] = [
            "PublicKey" : PublicKey,
            "Token" : Token
        ]
        
        baseRequestApi((Apis.baseUrl) + "account/verifyCode", .post, sendVerificationCodeModeParams, headersMoa) { (result: SendVerificationCodeModelMoa?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - Update Password
    func updatePasswordMoa(_ view: UIView,
                       _ Password: String,
                       _ PublicKey: String,
                       _ Token: String,
                       completion: @escaping(_ : ChangePasswordModelMoa) -> Void) {
        HUD.show(.progress, onView: view)
        
        let sendVerificationCodeModeParams : [String : String] = [
            "Password" : Password,
            "PublicKey" : PublicKey,
            "Token" : Token
        ]
        
        baseRequestApi((Apis.baseUrl) + "account/updatepasswordv2", .post, sendVerificationCodeModeParams, headersMoa) { (result: ChangePasswordModelMoa?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - GET ALL AMENITIES(Home) API
    func getAllAmenitiesApi(_ view: UIView, completion: @escaping(_ : GetAllAmenitiesModel) -> Void) {
        //HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GetAllAmenitiesApi.baseApi, .get, nil, authHeaders) { (result: GetAllAmenitiesModel?) in
           // print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SEARCH HOME API
    func searchHomeApi(_ view: UIView, _ stateName: [String], _ regionName: [String], _ propertyName: [String], _ freeText: [String], _ county: [String], _ rLU: [String], _ amenities: [String], _ rLUAcresMin: Int, _ rLUAcresMax: Int, _ priceMin: Int, _ priceMax: Int, _ userAccountID: Int, _ iPAddress: String, _ client: String, _ productTypeID: Int, _ order: String, _ sort: String,pageNumber: Int, completion: @escaping(_ : SearchHomeModel) -> Void) {
        HUD.show(.progress, onView: view)
//        "State": [],
//            "County": [],
//            "Product": [],
//            "Amenities": [],
//            "ProductAcresMin": 0,
//            "ProductAcresMax": 0,
//            "ProductPriceMin": 0,
//            "ProductPriceMax": 0,
//            "Client": "",
//            "ProductTypeID": 0,
//            "Sort": "",
//            "Order": "",
//            "PageNumber": 1
        let params: [String: Any] = [
            SearchHomeApi.stateName             : stateName,
            SearchHomeApi.Product               : propertyName,
            SearchHomeApi.county                : county,
            SearchHomeApi.amenities             : amenities,
            SearchHomeApi.ProductAcresMin       : rLUAcresMin,
            SearchHomeApi.ProductAcresMax       : rLUAcresMax,
            SearchHomeApi.priceMin              : priceMin,
            SearchHomeApi.priceMax              : priceMax,
            SearchHomeApi.client                : client,
            SearchHomeApi.productTypeID         : productTypeID,
            SearchHomeApi.order                 : order,
            SearchHomeApi.sort                  : sort,
            SearchHomeApi.PageNumber            : pageNumber
        ]
   
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(SearchHomeApi.baseApi, .post, params, authHeaders) { (result: SearchHomeModel?) in
            //print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SELECT REGIONWISE PROPERTIES(Home) API
    func selectRegionwisePropertiesApi(_ view: UIView, completion: @escaping(_ : SelectRegionWisePropertiesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(RegionwiseProperties.baseApi, .get, nil, authHeaders) { (result: SelectRegionWisePropertiesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - ACTIVITY DETAIL(Home) API
    func activityDetailApi(_ view: UIView, _ publicKey: String, _ token: String, completion: @escaping(_ : ActivityDetailModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        let params: [String: Any] = [
            ActivityDetailApi.publicKey             : publicKey,
            ActivityDetailApi.token             : token
        ]
        
        baseRequestApi(ActivityDetailApi.baseApi, .post, params, authHeaders) { (result: ActivityDetailModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    
//    func activityDetailApis(_ view: UIView, _ preSaleToken: String, completion: @escaping#imageLiteral(resourceName: "simulator_screenshot_8157D257-2E76-4B24-B29A-24C97D09385A.png")(_ : ActivityDetailModels) -> Void) {
//        HUD.show(.progress, onView: view)
//        
//        authHeaders = [
//            Headers.content_Type    : Headers.content_Type_Value,
//            Headers.client_site     : Headers.client_site_Value,
//            Headers.authorization   : LocalStore.shared.userId
//        ]
//        
//        let params: [String: Any] = [
//            ActivityDetailApi.preSaleToken             : preSaleToken
//        ]
//        
//        baseRequestApi(ActivityDetailApi.baseApi, .post, params, authHeaders) { (result: ActivityDetailModels?) in
//            print(result!)
//            completion(result!)
//        }
//    }
    // MARK: - RIGHT OF ENTRY FORM API
    func rightOfEntryFormApi(_ view: UIView, _ roERequestID: Int, _ productID: Int, _ userAccountID: Int, _ tractName: String, _ productNo: String, _ county: String, _ state: String, _ userName: String, _ dateOfAccessRequested: String, _ permittee: String, _ address: String, _ roEUsersLists: String, completion: @escaping(_ : RightOfEntryModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        let params: [String: Any] = [
            RightOfEntryFormApi.roERequestID             : roERequestID,
            RightOfEntryFormApi.productID                : productID,
            RightOfEntryFormApi.userAccountID            : userAccountID,
            RightOfEntryFormApi.tractName                : tractName,
            RightOfEntryFormApi.productNo                : productNo,
            RightOfEntryFormApi.county                   : county,
            RightOfEntryFormApi.state                    : state,
            RightOfEntryFormApi.userName                 : userName,
            RightOfEntryFormApi.dateOfAccessRequested    : dateOfAccessRequested,
            RightOfEntryFormApi.permittee                : permittee,
            RightOfEntryFormApi.address                  : address,
            RightOfEntryFormApi.roEUsersLists            : roEUsersLists
        ]
        
        baseRequestApi(RightOfEntryFormApi.baseApi, .post, params, authHeaders) { (result: RightOfEntryModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - GET PAYMENT TOKEN API
    func getPaymentTokenApi(_ view: UIView, _ requestType: String, _ rluNo: String, _ fundAccountKey: String, _ clientInvoiceId: Int, _ userAccountId: Int, _ email: String, _ licenseFee: Float, _ paidBy: String, _ cancelUrl: String, _ errorUrl: String, _ productTypeId: Int, _ returnUrl: String, _ productID: Int, _ invoiceTypeID: Int, completion: @escaping(_ : GetPaymentTokenModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GetPaymentTokenApi.requestType              : requestType,
            GetPaymentTokenApi.rluNo                    : rluNo,
            GetPaymentTokenApi.fundAccountKey           : fundAccountKey,
            GetPaymentTokenApi.clientInvoiceId          : clientInvoiceId,
            GetPaymentTokenApi.userAccountId            : userAccountId,
            GetPaymentTokenApi.email                    : email,
            GetPaymentTokenApi.licenseFee               : licenseFee,
            GetPaymentTokenApi.paidBy                   : paidBy,
            GetPaymentTokenApi.cancelUrl                : cancelUrl,
            GetPaymentTokenApi.errorUrl                 : errorUrl,
            GetPaymentTokenApi.productTypeId            : productTypeId,
            GetPaymentTokenApi.returnUrl                : returnUrl,
            GetPaymentTokenApi.productID                : productID,
            GetPaymentTokenApi.invoiceTypeID            : invoiceTypeID,
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GetPaymentTokenApi.baseApi, .post, params, authHeaders) { (result: GetPaymentTokenModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - DAY PASS AVAILABILITY API
    func dayPassAvailabilityApi(_ view: UIView, _ licenseActivityID: Int, _ dateOfArrival: String, _ daysCount: Int, completion: @escaping(_ : DayPassModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        let params: [String: Any] = [
            DayPassAvailabilityApi.licenseActivityID         : licenseActivityID,
            DayPassAvailabilityApi.dateOfArrival             : dateOfArrival,
            DayPassAvailabilityApi.daysCount                 : daysCount
        ]
        
        baseRequestApi(DayPassAvailabilityApi.baseApi, .post, params, authHeaders) { (result: DayPassModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - ADD HARVESTING DETAILS API
    func addHarvestingDetailsApi(_ view: UIView, _ huntingSeason: Int, _ buckCount: String, _ doeCount: String, _ turkeyCount: String, _ bearCount: String, _ productID: Int, completion: @escaping(_ : AddHarvestingDetailModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        let params: [String: Any] = [
            AddHarvestingDetailsApi.huntingSeason         : huntingSeason,
            AddHarvestingDetailsApi.buckCount             : buckCount,
            AddHarvestingDetailsApi.doeCount              : doeCount,
            AddHarvestingDetailsApi.turkeyCount           : turkeyCount,
            AddHarvestingDetailsApi.bearCount             : bearCount,
            AddHarvestingDetailsApi.productID             : productID,
        ]
        
        baseRequestApi(AddHarvestingDetailsApi.baseApi, .post, params, authHeaders) { (result: AddHarvestingDetailModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - PROPERTY LICENSE AGREEMENT API
    func generateLicenseContractApi(_ view: UIView, _ licenseActivityID: Int, completion: @escaping(_ : GenerateContractModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GenerateLicenseContractApi.licenseActivityID   : licenseActivityID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GenerateLicenseContractApi.baseApi, .post, params, authHeaders) { (result: GenerateContractModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SEARCH AUTOFILL API
    func searchAutofillApi(_ view: UIView, _ searchText: String, completion: @escaping(_ : SearchAutoFillModel) -> Void) {
        
        if isShowLoader == true {
            HUD.show(.progress, onView: view)
            isShowLoader = false
        } else {
            HUD.hide()
        }
        
        let params: [String: Any] = [
            AutoFillSearchApi.searchText             : searchText
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AutoFillSearchApi.baseApi, .post, params, authHeaders) { (result: SearchAutoFillModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - Delete Account API
    func deleteAccountApi(_ view: UIView, completion: @escaping(_ : SearchAutoFillModel) -> Void) {
        
        if isShowLoader == true {
            HUD.show(.progress, onView: view)
            isShowLoader = false
        } else {
            HUD.hide()
        }
        
        let params: [String: Any] = [:]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(DeleteAccountApi.baseApi, .post, params, authHeaders) { (result: SearchAutoFillModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - AVAILABLE STATES API
    func availableStatesApi(_ view: UIView, completion: @escaping(_ : AvailableStatesModel) -> Void) {
       // HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AvailableStatesApi.baseApi, .get, nil, authHeaders) { (result: AvailableStatesModel?) in
          //  print(result!)
            completion(result!)
        }
    }
    
    // MARK: - GET AVAILABLE COUNTY BY STATES API
    func getAvailableCountiesByStatesApi(_ view: UIView, _ stateAbbr: String, completion: @escaping(_ : GetAvailableCountyByStatesModel) -> Void) {
       // HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GetAvailableCountyByStates.stateAbbr             : stateAbbr
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GetAvailableCountyByStates.baseApi, .post, params, authHeaders) { (result: GetAvailableCountyByStatesModel?) in
           // print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SAVE SEARCH API
    func saveSearchApi(_ view: UIView, _ stateName: [String], _ regionName: [String], _ propertyName: [String], _ freeText: [String], _ county: [String], _ rLU: [String], _ amenities: [String], _ rLUAcresMin: Int, _ rLUAcresMax: Int, _ priceMin: Int, _ priceMax: Int, _ userAccountID: Int, _ iPAddress: String, _ client: String, _ productTypeID: Int, _ searchName: String, completion: @escaping(_ : SaveSearchModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            SaveSearchApi.stateName             : stateName,
            SaveSearchApi.regionName            : regionName,
            SaveSearchApi.propertyName          : propertyName,
            SaveSearchApi.freeText              : freeText,
            SaveSearchApi.county                : county,
            SaveSearchApi.rLU                   : rLU,
            SaveSearchApi.amenities             : amenities,
            SaveSearchApi.rLUAcresMin           : rLUAcresMin,
            SaveSearchApi.rLUAcresMax           : rLUAcresMax,
            SaveSearchApi.priceMin              : priceMin,
            SaveSearchApi.priceMax              : priceMax,
            SaveSearchApi.userAccountID         : userAccountID,
            SaveSearchApi.iPAddress             : iPAddress,
            SaveSearchApi.client                : client,
            SaveSearchApi.productTypeID         : productTypeID,
            SaveSearchApi.searchName            : searchName
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(SaveSearchApi.baseApi, .post, params, authHeaders) { (result: SaveSearchModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - MESSAGE LIST(MyConversations) API
    func myConversationsApi(_ view: UIView, completion: @escaping(_ : MyConversationsModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(MyConversationsApi.baseApi, .get, nil, authHeaders) { (result: MyConversationsModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - GET ALL MESSAGE API
    func getAllMessageApi(_ view: UIView, _ productID: Int, completion: @escaping(_ : GetAllMessagesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GetAllMessagesApi.productID             : productID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GetAllMessagesApi.baseApi, .post, params, authHeaders) { (result: GetAllMessagesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SEND MESSAGE API
//    func sendMessageApi(_ view: UIView, _ productID: Int, _ messageText: String, completion: @escaping(_ : SendMessageModel) -> Void) {
//        //   HUD.show(.progress, onView: view)
//        
//        let params: [String: Any] = [
//            SendMessageApi.productID                : productID,
//            SendMessageApi.messageText              : messageText
//        ]
//        
//        authHeaders = [
//            Headers.content_Type    : Headers.content_Type_Value,
//            Headers.client_site     : Headers.client_site_Value,
//            Headers.authorization   : LocalStore.shared.userId
//        ]
//        print(params)
//        print(authHeaders)
//        
//        baseRequestApi1(SendMessageApi.baseApi, .post, params, authHeaders) { (result: SendMessageModel?) in
//            print(result!)
//            completion(result!)
//        }
//    }
    
    func sendMessageApi(_ view: UIView, _ productID: Int, _ messageText: String, completion: @escaping (SendMessageModel?) -> Void) {
        let params: [String: Any] = [
            SendMessageApi.productID: productID,
            SendMessageApi.messageText: messageText
        ]
        
        let authHeaders: [String: String] = [
            Headers.content_Type: Headers.content_Type_Value,
            Headers.client_site: Headers.client_site_Value,
            Headers.authorization: LocalStore.shared.userId
        ]
        
        print(params)
        print(authHeaders)
        
        baseRequestApi1(SendMessageApi.baseApi, .post, params, authHeaders) { (result: SendMessageModel?) in
            if let result = result {
                print(result)
                completion(result)
            } else {
                // Handle error if needed
                completion(nil)
            }
        }
    }
    
    
    // MARK: - REFRESH MESSAGE API
    func refreshMessageApi(_ userMsgID: Int, _ productID: Int, completion: @escaping(_ : GetAllMessagesModel) -> Void) {
        let params: [String: Any] = [
            RefreshMessageApi.userMsgID                 : userMsgID,
            RefreshMessageApi.productID                 : productID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(RefreshMessageApi.baseApi, .post, params, authHeaders) { (result: GetAllMessagesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - EDIT USER PROFILE API
    func editUserProfileApi(_ view: UIView, _ userProfileID : Int, _ userAccountID : Int, _ firstName : String, _ lastName: String, _ streetAddress : String, _ city : String, _ st : String, _ zip : String, _ phone : String, _ groupName : String, _ clubName : String, _ email : String, _ getNotifications : Bool, _ authenticationType : String, _ isUserProfileComplete : Bool, _ stateName : String, _ status : Int, completion: @escaping(_ : EditUserProfileModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            EditUserProfileApi.userProfileID            : userProfileID,
            EditUserProfileApi.userAccountID            : userAccountID,
            EditUserProfileApi.firstName                : firstName,
            EditUserProfileApi.lastName                 : lastName,
            EditUserProfileApi.streetAddress            : streetAddress,
            EditUserProfileApi.city                     : city,
            EditUserProfileApi.st                       : st,
            EditUserProfileApi.zip                      : zip,
            EditUserProfileApi.phone                    : phone,
            EditUserProfileApi.groupName                : groupName,
            EditUserProfileApi.clubName                 : clubName,
            EditUserProfileApi.email                    : email,
            EditUserProfileApi.getNotifications         : getNotifications,
            EditUserProfileApi.authenticationType       : authenticationType,
            EditUserProfileApi.isUserProfileComplete    : isUserProfileComplete,
            EditUserProfileApi.stateName                : stateName,
            EditUserProfileApi.status                   : status
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(EditUserProfileApi.baseApi, .post, params, authHeaders) { (result: EditUserProfileModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - USER PROFILE API
    func userProfileApi(_ view: UIView, completion: @escaping(_ : UserProfileModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        print("Headers.content_Type_Value--" , Headers.content_Type_Value)
        print("Headers.client_site_Value--", Headers.client_site_Value)
        print("Headers.authorization--", LocalStore.shared.userId)
        baseRequestApi(UserProfileApi.baseApi, .post, nil, authHeaders) { (result: UserProfileModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - GET ALL STATES API
    func getAllStatesApi(_ view: UIView, completion: @escaping(_ : GetAllStatesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        baseRequestApi(StatesApi.baseApi, .get, nil, nil) { (result: GetAllStatesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - MANAGE NOTIFICATIONS API
    func manageNotificationsApi(_ view: UIView, _ notifications: Bool, completion: @escaping(_ : MobileNotificationsModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            ManageNotificationsApi.notifications            : notifications
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(ManageNotificationsApi.baseApi, .post, params, authHeaders) { (result: MobileNotificationsModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - CHANGE PASSWORD API
    func changePassApi(_ view: UIView, _ password: String, _ newPassword: String, completion: @escaping(_ : ChangePasswordModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            ChangePasswordApi.password               : password,
            ChangePasswordApi.newPassword            : newPassword,
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(ChangePasswordApi.baseApi, .post, params, authHeaders) { (result: ChangePasswordModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SAVED SEARCHES API
    func savedSearchesApi(_ view: UIView, completion: @escaping(_ : SavedSearchesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(SavedSearchesApi.baseApi, .get, nil, authHeaders) { (result: SavedSearchesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - DELETE SEARCHES API
    func deleteSearchesApi(_ view: UIView, _ userSearchID: Int, completion: @escaping(_ : DeleteSearchesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            DeleteSearchesApi.userSearchID            : userSearchID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(DeleteSearchesApi.baseApi, .post, params, authHeaders) { (result: DeleteSearchesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - LOGOUT API
    func logoutApi(_ view: UIView, completion: @escaping(_ : LogOutModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        print(authHeaders)
        baseRequestApi(LogOutApi.baseApi, .get, nil, authHeaders) { (result: LogOutModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - MY LICENSES API(Active Licenses Api)
    func myLicensesApi(_ view: UIView, completion: @escaping(_ : ActiveMemeberPendindCombimeModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(MyLicensesApi.baseApi, .get, nil, authHeaders) { (result: ActiveMemeberPendindCombimeModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - MEMBER LICENSES API
    func memberLicensesApi(_ view: UIView, completion: @escaping(_ : ActiveMemeberPendindCombimeModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(MemberLicensesApi.baseApi, .get, nil, authHeaders) { (result: ActiveMemeberPendindCombimeModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - PENDING LICENSES API
    func pendingLicensesApi(_ view: UIView, completion: @escaping(_ : ActiveMemeberPendindCombimeModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(PendingLicensesApi.baseApi, .get, nil, authHeaders) { (result: ActiveMemeberPendindCombimeModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - EXPIRED LICENSES API
    func expiredLicensesApi(_ view: UIView, completion: @escaping(_ : ExpiredLicensesModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(ExpiredLicensesApi.baseApi, .get, nil, authHeaders) { (result: ExpiredLicensesModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - ACCEPT MANUAL PAYMENT API
    func acceptManualPaymentApi(_ view: UIView, _ licenseContractID: Int, completion: @escaping(_ : AcceptManualPaymentModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            AcceptManualPaymentApi.licenseContractID            : licenseContractID,
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AcceptManualPaymentApi.baseApi, .post, params, authHeaders) { (result: AcceptManualPaymentModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - ACCEPT LICENSES REQUEST API
    func acceptLicensesReqApi(_ view: UIView, _ licenseContractID: Int, _ userAccountID: Int, completion: @escaping(_ : AcceptLicensesReqModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            AcceptLicensesReqApi.licenseContractID            : licenseContractID,
            AcceptLicensesReqApi.userAccountID                : userAccountID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AcceptLicensesReqApi.baseApi, .post, params, authHeaders) { (result: AcceptLicensesReqModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - PRE APPROVAL REQUEST API
    func preApprovalReqApi(_ view: UIView, completion: @escaping(_ : PreApprovalReqModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(PreApprovalReqApi.baseApi, .get, nil, authHeaders) { (result: PreApprovalReqModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - SUBMIT PRE APPROVAL REQUEST API
    func submitPreApprovalReqApi(_ view: UIView, _ userAccountID: Int, _ licenseActivityID: Int, _ requestComments: String, _ productID: Int, completion: @escaping(_ : SubmitPreApprovalReqModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        print("authHeaders", authHeaders)
        let params: [String: Any] = [
            SubmitPreApprovalReqApi.userAccountID       : userAccountID,
            SubmitPreApprovalReqApi.licenseActivityID   : licenseActivityID,
            SubmitPreApprovalReqApi.requestComments     : requestComments,
            SubmitPreApprovalReqApi.productID           : productID
        ]
        print(params)
        baseRequestApi(SubmitPreApprovalReqApi.baseApi, .post, params, authHeaders) { (result: SubmitPreApprovalReqModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - CANCEL PRE APPROVAL REQUEST API
    func cancelPreApprovalReqApi(_ view: UIView, cancelReqId: Int, completion: @escaping(_ : CancelPreApprovalReqModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            CancelPreApprovalReqApi.preApprRequestID : cancelReqId
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(CancelPreApprovalReqApi.baseApi, .post, params, authHeaders) { (result: CancelPreApprovalReqModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - LICENSE DETAIL API
    func licenseDetailApi(_ view: UIView, publicKey: String, completion: @escaping(_ : LicenseDetailModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            LicenseDetailApi.publicKey : publicKey
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(LicenseDetailApi.baseApi, .post, params, authHeaders) { (result: LicenseDetailModel?) in
            print("dfhgkjdhfsjkghdfjshgkjdfhgkahdkghdkghdfhg",result!)
            completion(result!)
        }
    }
    
    // MARK: - ADD MEMBER API
    func addMemberApi(_ view: UIView, _ licenseContractID: Int, _ firstName : String, _ lastName : String, _ email : String, _ phone : String, _ address : String, _ state : String, _ city : String, _ zip : String,  completion: @escaping(_ : AddMemberModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            AddMemberApi.licenseContractID      : licenseContractID,
            AddMemberApi.firstName              : firstName,
            AddMemberApi.lastName               : lastName,
            AddMemberApi.email                  : email,
            AddMemberApi.phone                  : phone,
            AddMemberApi.address                : address,
            AddMemberApi.state                  : state,
            AddMemberApi.city                   : city,
            AddMemberApi.zip                    : zip
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AddMemberApi.baseApi, .post, params, authHeaders) { (result: AddMemberModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - INVITE MEMBER API
    func inviteMemberApi(_ view: UIView, _ licenseContractID: Int, _ userEmail : String, completion: @escaping(_ : InviteMembersModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            InviteMemberApi.licenseContractID   : licenseContractID,
            InviteMemberApi.userEmail           : userEmail
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(InviteMemberApi.baseApi, .post, params, authHeaders) { (result: InviteMembersModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - REMOVE MEMBER API
    func removeMemberApi(_ view: UIView, _ licenseContractMemberID: Int, completion: @escaping(_ : RemoveMembersModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            RemoveMemberApi.licenseContractMemberID   : licenseContractMemberID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(RemoveMemberApi.baseApi, .post, params, authHeaders) { (result: RemoveMembersModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - ADD VEHICLE INFO API
    func addVehicleInfoApi(_ view: UIView, _ licenseContractID: Int, _ vehicleDetailID: Int, _ vehicleMake: String, _ vehicleModel: String, _ vehicleColor: String, _ vehicleLicensePlate: String, _ vehicleState: String, _ vehicleType: String, completion: @escaping(_ : AddVehicleModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            AddVehicleApi.licenseContractID     : licenseContractID,
            AddVehicleApi.vehicleDetailID       : vehicleDetailID,
            AddVehicleApi.vehicleMake           : vehicleMake,
            AddVehicleApi.vehicleModel          : vehicleModel,
            AddVehicleApi.vehicleColor          : vehicleColor,
            AddVehicleApi.vehicleLicensePlate   : vehicleLicensePlate,
            AddVehicleApi.vehicleState          : vehicleState,
            AddVehicleApi.vehicleType           : vehicleType
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(AddVehicleApi.baseApi, .post, params, authHeaders) { (result: AddVehicleModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - DELETE VEHICLE API
    func deleteVehicleApi(_ view: UIView, _ vehicleDetailID: Int, completion: @escaping(_ : DeleteVehicleModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            DeleteVehicleApi.vehicleDetailID   : vehicleDetailID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(DeleteVehicleApi.baseApi, .post, params, authHeaders) { (result: DeleteVehicleModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - PROPERTY LICENSE AGREEMENT API
    func generateContractApi(_ view: UIView, _ licenseContractID: Int, completion: @escaping(_ : GenerateContractModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GenerateContractApi.licenseContractID   : licenseContractID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GenerateContractApi.baseApi, .post, params, authHeaders) { (result: GenerateContractModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - CLUB MEMBERSHIP CARD API
    func generateClubMembershipCardApi(_ view: UIView, _ licenseContractID: Int, completion: @escaping(_ : ClubMembershipCardModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            GenerateClubMembershipCardApi.licenseContractID   : licenseContractID
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(GenerateClubMembershipCardApi.baseApi, .post, params, authHeaders) { (result: ClubMembershipCardModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - LIST YOUR PROPERTY API
    func listYourPropertyApi(_ view: UIView, _ email: String, _ landownerType : String, _ firstName: String, _ lastName: String, _ phone: String, _ address: String, _ city: String, _ state: String, _ zip: String, _ subscriptionType: String, completion: @escaping(_ : ListYourPropertyModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            ListYourPropertyApi.email               :   email,
            ListYourPropertyApi.landownerType       :   landownerType,
            ListYourPropertyApi.firstName           :   firstName,
            ListYourPropertyApi.lastName            :   lastName,
            ListYourPropertyApi.phone               :   phone,
            ListYourPropertyApi.address             :   address,
            ListYourPropertyApi.city                :   city,
            ListYourPropertyApi.state               :   state,
            ListYourPropertyApi.zip                 :   zip,
            ListYourPropertyApi.subscriptionType    :   subscriptionType
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(ListYourPropertyApi.baseApi, .post, params, authHeaders) { (result: ListYourPropertyModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - CONTACT US API
    func contactUsApi(_ view: UIView, _ name: String, _ email : String, _ body: String, _ Purpose: String, completion: @escaping(_ : ContactUsModel) -> Void) {
        HUD.show(.progress, onView: view)
        
        let params: [String: Any] = [
            ContactUsApi.name   :   name,
            ContactUsApi.email  :   email,
            ContactUsApi.body   :   body,
            ContactUsApi.Purpose :  Purpose
        ]
        
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        
        baseRequestApi(ContactUsApi.baseApi, .post, params, authHeaders) { (result: ContactUsModel?) in
            print(result!)
            completion(result!)
        }
    }
    
    // MARK: - MAPS APIS
    // MARK: - POINT LAYER API
    func pointLayerApi(_ view: UIView, completion: @escaping(_ : PointModel) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: PointLayerApi.baseApi)!
        url.queryItems = [
            URLQueryItem(name: PointLayerApi.Where, value: "1=1"),
            URLQueryItem(name: PointLayerApi.outFields, value: "*"),
            URLQueryItem(name: PointLayerApi.returnGeometry, value: "true"),
            URLQueryItem(name: PointLayerApi.f, value: "geojson")
        ]
        
        baseRequestApi(url, .get, nil, nil) { (result: PointModel?) in
          //  print(result!)
            completion(result!)
        }
    }
    
    // MARK: - POLY LAYER API
    func polyLayerApi(_ view: UIView, completion: @escaping(_ : PolyModel) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: PolyLayerApi.baseApi)!
        url.queryItems = [
            URLQueryItem(name: PolyLayerApi.Where, value: "1=1"),
            URLQueryItem(name: PolyLayerApi.outFields, value: "*"),
            URLQueryItem(name: PolyLayerApi.returnGeometry, value: "true"),
            URLQueryItem(name: PolyLayerApi.f, value: "geojson")
        ]
        
        baseRequestApi(url, .get, nil, nil) { (result: PolyModel?) in
            //print(result!)
            completion(result!)
        }
    }
    
    // MARK: -  MULTI POLYGON API 1
    func multiPolygonApi(_ view: UIView, rluName: String, completion: @escaping(_ : MultipolygonModel) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: MultiPolygonApi.baseApi)!
        print("rluName",rluName)
        url.queryItems = [
            URLQueryItem(name: MultiPolygonApi.f, value: "geojson"),
            URLQueryItem(name: MultiPolygonApi.outFields, value: "*"),
            URLQueryItem(name: MultiPolygonApi.spatialRel, value: "esriSpatialRelIntersects"),
            URLQueryItem(name: MultiPolygonApi.Where, value: "RLUNo='\(rluName)'")
        ]
        print(url ,rluName)
        
        baseRequestApi(url, .get, nil, nil) { (result: MultipolygonModel?) in
          //  print(result!)
            completion(result!)
        }
    }
    // MARK: - MULTI POLYGON API 2
    func multiPolygonApi2(_ view: UIView, rluName: String, completion: @escaping(_ : MultiPolygonModel2) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: MultiPolygonApi2.baseApi)!
        print("rluName",rluName)
        url.queryItems = [
            URLQueryItem(name: MultiPolygonApi2.f, value: "geojson"),
            URLQueryItem(name: MultiPolygonApi2.outFields, value: "*"),
            URLQueryItem(name: MultiPolygonApi2.spatialRel, value: "esriSpatialRelIntersects"),
            URLQueryItem(name: MultiPolygonApi2.Where, value: "RLUNo='\(rluName)'")
        ]
        print(url ,rluName)
        
        baseRequestApi(url, .get, nil, nil) { (result: MultiPolygonModel2?) in
          //  print(result!)
            completion(result!)
        }
    }
    // MARK: - SELECTED STATE MAP API
    func selectedStateMap(_ view: UIView, rluName: String, completion: @escaping(_ : SelectStateMapModel) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: SelectedStateMap.baseApi)!
        print("rluName",rluName)
        url.queryItems = [
            URLQueryItem(name: SelectedStateMap.f, value: "geojson"),
            URLQueryItem(name: SelectedStateMap.outFields, value: "STATE_ABBR"),
            URLQueryItem(name: SelectedStateMap.spatialRel, value: "esriSpatialRelIntersects"),
            URLQueryItem(name: SelectedStateMap.Where, value: "STATE_ABBR='\(rluName)'")
        ]
        print(url ,rluName)
        
        baseRequestApi(url, .get, nil, nil) { (result: SelectStateMapModel?) in
          //  print(result!)
            completion(result!)
        }
    }
    // MARK: - NON MOTORIZED MAP API
    func nonMotorizedApi(_ view: UIView, completion: @escaping(_ : NonMotorizedModel) -> Void) {
        HUD.show(.progress, onView: view)
        var url = URLComponents(string: NonMotorized.baseApi)!
        url.queryItems = [
            URLQueryItem(name: NonMotorized.Where, value: "ProductType='Non-Motorized'"),
            URLQueryItem(name: NonMotorized.outFields, value: "*"),
            URLQueryItem(name: NonMotorized.returnGeometry, value: "true"),
            URLQueryItem(name: NonMotorized.f, value: "geojson")
        ]
        print(url)
        
        baseRequestApi(url, .get, nil, nil) { (result: NonMotorizedModel?) in
          //  print(result!)
            completion(result!)
        }
    }
    // MARK: - ACCESS POINT API
    func accessPointApi(_ view: UIView,completion: @escaping(_ : AcessPointModel) -> Void) {
         HUD.show(.progress, onView: view)
        
        
        var url = URLComponents(string: AccessPointApi.baseApi)!
        url.queryItems = [
            URLQueryItem(name: AccessPointApi.Where, value: "1=1"),
            URLQueryItem(name: AccessPointApi.outFields, value: "*"),
            URLQueryItem(name: AccessPointApi.returnGeometry, value: "true"),
            URLQueryItem(name: AccessPointApi.f, value: "geojson")
        ]
        print("url",url)
        baseRequestApi(url, .get, nil, nil) { (result: AcessPointModel?) in
            //  print(result!)
            completion(result!)
        }
    }
        // MARK: - PERMIT SHAPES API
        func permitShapesApi(_ view: UIView,completion: @escaping(_ : PermitShapesModel) -> Void) {
            HUD.show(.progress, onView: view)
          
            var url = URLComponents(string: PermitShapesApi.baseApi)!
            url.queryItems = [
                URLQueryItem(name: PermitShapesApi.Where, value: "1=1"),
                URLQueryItem(name: PermitShapesApi.outFields, value: "*"),
                URLQueryItem(name: PermitShapesApi.returnGeometry, value: "true"),
                URLQueryItem(name: PermitShapesApi.f, value: "geojson")
            ]
            print("url",url)
            baseRequestApi(url, .get, nil, nil) { (result: PermitShapesModel?) in
              print("result",result)
                completion(result!)
            }
    }
    
    // MARK: - RLU DETAIL API
    func rluDetailApi(_ view: UIView, productNo: String, completion: @escaping(_ : RLUDetailModel) -> Void) {
        HUD.show(.progress, onView: view)
        let params: [String: Any] = [
            MapDetailApi.productNo   :   productNo
        ]
        authHeaders = [
            Headers.content_Type    : Headers.content_Type_Value,
            Headers.client_site     : Headers.client_site_Value,
            Headers.authorization   : LocalStore.shared.userId
        ]
        baseRequestApi(MapDetailApi.baseApi, .post, params, authHeaders) { (result: RLUDetailModel?) in
            //print(result!)
            completion(result!)
        }
    }
}

// MARK: - Dictionary Extension
extension Dictionary where Key == String, Value == String {
    func toHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        for (key, value) in self {
            headers.add(name: key, value: value)
        }
        return headers
    }
}
