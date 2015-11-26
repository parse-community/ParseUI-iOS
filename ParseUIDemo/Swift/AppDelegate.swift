/*
*  Copyright (c) 2015, Parse, LLC. All rights reserved.
*
*  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
*  copy, modify, and distribute this software in source code or binary form for use
*  in connection with the web services and APIs provided by Parse.
*
*  As with any software that integrates with the Parse platform, your use of
*  this software is subject to the Parse Terms of Service
*  [https://www.parse.com/about/terms]. This copyright notice shall be
*  included in all copies or substantial portions of the software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
*  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
*  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
*  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
*  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.setApplicationId("UdNpOP2XFoEiXLZEBDl6xONmCMH8VjETmnEsl0xJ", clientKey: "wNJFho0fQaQFQ2Fe1x9b67lVBakJiAtFj1Uz30A9")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        PFTwitterUtils.initializeWithConsumerKey("3Q9hMEKqqSg4ie2pibZ2sVJuv", consumerSecret: "IEZ9wv2d1EpXNGFKGp7sAGdxRtyqtPwygyciFZwTHTGhPp4FMj")

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: UIDemoViewController())
        window?.makeKeyAndVisible()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.setupTestData()
        }

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    // MARK: Test Data

    private func setupTestData() {
        let todoTitles = [
            "Build Parse",
            "Make everything awesome",
            "Go out for the longest run",
            "Do more stuff",
            "Conquer the world",
            "Build a house",
            "Grow a tree",
            "Be awesome",
            "Setup an app",
            "Do stuff",
            "Buy groceries",
            "Wash clothes"
        ];

        var objects: [PFObject] = Array()

        do {
            let todos = try PFQuery(className: "Todo").findObjects()
            if todos.count == 0 {
                for (index, title) in todoTitles.enumerate() {
                    let todo = PFObject(className: "Todo")
                    todo["title"] = title
                    todo["priority"] = index % 3
                    objects.append(todo)
                }
            }
        } catch {}

        let appNames = [ "Anypic", "Anywall", "f8" ]
        do {
            let apps = try PFQuery(className: "App").findObjects()
            if apps.count == 0 {
                for (index, appName) in appNames.enumerate() {
                    let bundle = NSBundle.mainBundle()
                    if let fileURL = bundle.URLForResource(String(index), withExtension: "png") {
                        if let data = NSData(contentsOfURL: fileURL) {
                            let file = PFFile(name: fileURL.lastPathComponent, data: data)
                            let object = PFObject(className: "App")
                            object["icon"] = file
                            object["name"] = appName
                            objects.append(object)
                        }
                    }
                }
            }
        } catch {}
        
        let cityNames = [
            "Kabul",
            "Tirana",
            "Andorra la Vella",
            "Luanda",
            "St. John’s",
            "Buenos Aires",
            "Yerevan",
            "Canberra",
            "Vienna",
            "Baku",
            "Nassau",
            "Manama",
            "Dhaka",
            "Bridgetown",
            "Minsk",
            "Brussels",
            "Belmopan",
            "Cotonou",
            "Thimphu",
            "La Paz and Sucre",
            "Sarajevo",
            "Gaborone",
            "Brasília",
            "Bandar Seri Begawan",
            "Sofia",
            "Ouagadougou",
            "Bujumbura",
            "Phnom Penh",
            "Yaoundé",
            "Ottawa",
            "Praia",
            "George Town",
            "Bangui",
            "N’Djamena",
            "Santiago",
            "Beijing",
            "Bogotá",
            "Moroni",
            "San José",
            "Yamoussoukro",
            "Zagreb",
            "Havana",
            "Nicosia",
            "Prague",
            "Kinshasa",
            "Copenhagen",
            "Djibouti",
            "Roseau",
            "Santo Domingo",
            "Dili"]
        
        do {
            let cities = try PFQuery(className: "City").findObjects()
            if cities.count == 0 {
                for cityName in cityNames {
                    let city = PFObject(className: "City")
                    city["name"] = cityName
                    objects.append(city)
                }
            }
        } catch {}
        
        if objects.count != 0 {
            do {
                try PFObject.saveAll(objects)
            } catch {}
        }
        
    }

}
