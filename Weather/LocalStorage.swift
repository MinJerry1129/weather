import Foundation

struct Defaults {
    static let COUNTRY_KEY = "COUNTRY_ARRAY"
    static let CITY_KEY = "CITY_ARRAY"
    static let CITYID_KEY = "CITYID_ARRAY"
    static let DATE_KEY = "DATE_ARRAY"
    static let MAINDES_KEY = "MAINDES_ARRAY"
    static let TEMP_KEY = "TEMP_ARRAY"
    static let TEMPMAX_KEY = "TEMPMAX_ARRAY"
    static let TEMPMIN_KEY = "TEMPMIN_ARRAY"
    static let DES_KEY = "DES_ARRAY"
    static let LAT_KEY = "LAT_ARRAY"
    static let LONG_KEY = "LONG_ARRAY"
    
    
    
    static func save(_ value: String, with key: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getNameAndValue(_ key: String)-> String {
        return (UserDefaults.standard.value(forKey: key) as? String) ?? ""
    }
    static func clearUserData(_ key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}
