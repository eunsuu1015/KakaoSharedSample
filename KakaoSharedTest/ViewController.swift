//
//  ViewController.swift
//  KakaoSharedTest
//
//  Created by Eunsuu1015 on 2021/12/13.
//

import UIKit
import KakaoSDKLink
import KakaoSDKTemplate
import KakaoSDKCommon

class ViewController: UIViewController {
    
    let templateId = 66813
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func shared1(_ sender: Any) {
        sharedTemplateId(templateId: Int64(templateId))
    }
    
    @IBAction func shared2(_ sender: Any) {
        sharedTextTemplate()
    }
    
    @IBAction func shared3(_ sender: Any) {
        sharedFeedTemplate()
    }
    
    // 사용자 정의 템플릿으로 메시지 보내기
    func sharedTemplateId(templateId: Int64) {
        // 카카오톡으로 카카오링크 공유 가능
        // templatable은 메시지 만들기 항목 참고
        LinkApi.shared.customLink(templateId: templateId) { (linkResult, error) in
            if let error = error {
                print(error)
            }
            else {
                print("customLink() success.")
                if let linkResult = linkResult {
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    // 기본 텍스트 템플릿으로 메시지 보내기
    func sharedTextTemplate() {
        if LinkApi.isKakaoLinkAvailable() {
            let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
                            mobileWebUrl: URL(string:"https://developers.kakao.com"))
            let appLink = Link(androidExecutionParams: ["key1": "value1", "key2": "value2"],
                               iosExecutionParams: ["key1": "value1", "key2": "value2"])
            let button1 = Button(title: "웹에서 보기", link: link)
            let button2 = Button(title: "앱에서 보기", link: appLink)
            
            let template = TextTemplate(text: "타이틀 문구", link: link, buttonTitle: "버튼", buttons: [button1, button2])
            
            //메시지 템플릿 encode
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                
                //생성한 메시지 템플릿 객체를 jsonObject로 변환
                if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                    LinkApi.shared.defaultLink(templateObject:templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                        }
                        else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        else {
            print("카카오톡 미설치")
            // 카카오톡 미설치: 웹 공유 사용 권장
            showAlert(msg: "카카오톡 미설치 디바이스")
        }
    }
    
    // 기본 피드 템플릿으로 메시지 보내기
    func sharedFeedTemplate() {
        if LinkApi.isKakaoLinkAvailable() {
            
            let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
                            mobileWebUrl: URL(string:"https://developers.kakao.com"))
            let appLink = Link(androidExecutionParams: ["key3": "value3", "key4": "value4"],
                               iosExecutionParams: ["key3": "value3", "key4": "value4"])
            let button1 = Button(title: "웹에서 보기", link: link)
            let button2 = Button(title: "앱에서 보기", link: appLink)
            
            let social = Social(likeCount: 286,
                                commentCount: 45,
                                sharedCount: 845)
            let content = Content(title: "타이틀문구",
                                  imageUrl: URL(string:"http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!,
                                  description: "#케익 #딸기 #삼평동 #카페 #분위기 #소개팅",
                                  link: link)
            
            let template = FeedTemplate(content: content, social: social, buttons: [button1, button2])
            
            //메시지 템플릿 encode
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                
                //생성한 메시지 템플릿 객체를 jsonObject로 변환
                if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                    LinkApi.shared.defaultLink(templateObject:templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                        }
                        else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        else {
            print("카카오톡 미설치")
            // 카카오톡 미설치: 웹 공유 사용 권장
            showAlert(msg: "카카오톡 미설치 디바이스")
        }
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: UIAlertController.Style.alert)
        let defaultAction =  UIAlertAction(title: "default", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        self.present(alert, animated: false)
    }
    
}

