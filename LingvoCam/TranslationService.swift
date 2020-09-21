//
//  TranslationService.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 17.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import Foundation


final class TranslationService {
    
    
    static func translate(text: String, completion: @escaping (String) -> Void){
        let sourceLang = "en"
        let targetLang = "ru"
        let convertedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )!
        
        let rawUrl = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=\(sourceLang)&tl=\(targetLang)&dt=t&q=\(convertedText)";
        
        let url = URL(string: rawUrl)
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url!) {data , response, error in
            
            let jsonData = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [Any]
            
            let translatedWord = ((jsonData![0] as! [Any])[0] as! [Any])[0] as! String
            
            completion(translatedWord)
        }
        dataTask.resume()
    }
}
