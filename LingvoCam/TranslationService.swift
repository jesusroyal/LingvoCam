//
//  TranslationService.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 17.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import Foundation


final class TranslationService {
    
    static let instance = TranslationService()
    
    private var timer: Timer?
    private var requestIsAllowed = true
    
     private func blockRequests(){
        requestIsAllowed = false
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0,
                                              target: self,
                                              selector: #selector(self.allowRequests),
                                              userInfo: nil,
                                              repeats: false)
        }
        
    }
    
    @objc private func allowRequests(){
        requestIsAllowed = true
        timer?.invalidate()
    }
    

    func translate(text: String, completion: @escaping (String?) -> Void){
        let sourceLang = "en"
        let targetLang = "ru"
        let convertedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )!
        
        let rawUrl = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=\(sourceLang)&tl=\(targetLang)&dt=t&q=\(convertedText)";
        
        let url = URL(string: rawUrl)
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url!) {data , response, error in
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [Any] else {
                completion(nil)
                return
            }
            
            let translatedWord = ((jsonData[0] as! [Any])[0] as! [Any])[0] as! String
            
       
            
            completion(translatedWord)
        }
        if requestIsAllowed {
            blockRequests()
            dataTask.resume()
        } else {
            return
        }
    }
}
