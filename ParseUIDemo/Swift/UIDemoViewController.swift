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
import ParseUI

public struct UIDemoTypeAndRank {
    public var name: String
    public var order: Int
    public var handle: String
    init?(name: String, order: Int, handle: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.order = order
        self.handle = handle
    }
}

let SimpleTable: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Simple Table", order: 1, handle: "SimpleTable")!
let PaginatedTable: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Paginated Table", order: 2, handle: "PaginatedTable")!
let SectionedTable: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sectioned Table", order: 3, handle: "SectionedTable")!
let StoryboardTable: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Simple Storyboard Table", order: 4, handle: "StoryboardTable")!
let DeletionTable: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Deletion Table", order: 5, handle: "DeletionTable")!
let SimpleCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Simple Collection", order: 6, handle: "SimpleCollection")!
let PaginatedCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Paginated Collection", order: 7, handle: "PaginatedCollection")!
let SectionedCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sectioned Collection", order: 8, handle: "SectionedCollection")!
let StoryboardCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Simple Storyboard Collection", order: 9, handle: "StoryboardCollection")!
let DeletionCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Deletion Collection", order: 10, handle: "DeletionCollection")!
let LogInDefault: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Default", order: 11, handle: "LogInDefault")!
let LogInUsernamePassword: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Username and Password", order: 12, handle: "LogInUsernamePassword")!
let LogInPasswordForgotten: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Password Forgotten", order: 13, handle: "LogInPasswordForgotten")!
let LogInDone: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Done Button", order: 14, handle: "LogInDone")!
let LogInEmailAsUsername: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Email as Username", order: 15, handle: "LogInEmailAsUsername")!
let LogInFacebook: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Facebook", order: 16, handle: "LogInFacebook")!
let LogInFacebookAndTwitter: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Facebook and Twitter", order: 17, handle: "LogInFacebookAndTwitter")!
let LogInAll: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In All", order: 18, handle: "LogInAll")!
let LogInAllNavigation: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In All as Navigation", order: 19, handle: "LogInAllNavigation")!
let LogInCustomizedLogoAndBackground: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Log In Customized Background", order: 20, handle: "LogInCustomizedLogoAndBackground")!
let SignUpDefault: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Default", order: 21, handle: "SignUpDefault")!
let SignUpUsernamePassword: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Username and Password", order: 22, handle: "SignUpUsernamePassword")!
let SignUpUsernamePasswordEmail: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Email", order: 23, handle: "SignUpUsernamePasswordEmail")!
let SignUpUsernamePasswordEmailSignUp: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Email And SignUp", order: 24, handle: "SignUpUsernamePasswordEmailSignUp")!
let SignUpAll: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up All", order: 25, handle: "SignUpAll")!
let SignUpEmailAsUsername: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Email as Username", order: 26, handle: "SignUpEmailAsUsername")!
let SignUpMinPasswordLength: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Sign Up Minimum Password Length", order: 27, handle: "SignUpMinPasswordLength")!
let ImageTableDefaultStyle: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Remote Image Table Default Style", order: 28, handle: "ImageTableDefaultStyle")!
let ImageTableSubtitleStyle: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Remote Image Table Subtitle Style", order: 29, handle: "ImageTableSubtitleStyle")!
let ImageCollection: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Remote Image Collection", order: 30, handle: "ImageCollection")!
let Product: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Purchase", order: 31, handle: "Product")!
let CustomizedProduct: UIDemoTypeAndRank = UIDemoTypeAndRank.init(name: "Custom Purchase", order: 32, handle: "CustomizedProduct")!

class UIDemoViewController: UITableViewController {
    
    var descriptions: [UIDemoTypeAndRank]? = [SimpleTable, PaginatedTable, SectionedTable, StoryboardTable, DeletionTable, SimpleCollection, PaginatedCollection, SectionedCollection, StoryboardCollection, DeletionCollection, LogInDefault, LogInUsernamePassword, LogInPasswordForgotten, LogInDone, LogInEmailAsUsername, LogInFacebook, LogInFacebookAndTwitter, LogInAll, LogInAllNavigation, LogInCustomizedLogoAndBackground, SignUpDefault, SignUpUsernamePassword, SignUpUsernamePasswordEmail, SignUpUsernamePasswordEmailSignUp, SignUpAll, SignUpEmailAsUsername, SignUpMinPasswordLength, ImageTableDefaultStyle, ImageTableSubtitleStyle, ImageCollection, Product, CustomizedProduct]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ParseUI Demo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension UIDemoViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        cell.textLabel?.text = descriptions![indexPath.row].name
        return cell
    }
}

extension UIDemoViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let demoType = descriptions?[indexPath.row].handle {
            switch (demoType) {
            // -----
            // PFLogInViewController
            // -----
            case "LogInDefault":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                present(logInViewController, animated: true, completion: nil)
            case "LogInUsernamePassword":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .dismissButton]
                present(logInViewController, animated: true, completion: nil)
            case "LogInPasswordForgotten":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .passwordForgotten, .dismissButton]
                present(logInViewController, animated: true, completion: nil)
            case "LogInDone":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .logInButton, .dismissButton]
                present(logInViewController, animated: true, completion: nil)
            case "LogInEmailAsUsername":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .logInButton, .signUpButton, .dismissButton]
                logInViewController.emailAsUsername = true
                present(logInViewController, animated: true, completion: nil)
            case "LogInFacebook":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .facebook, .dismissButton]
                present(logInViewController, animated: true, completion: nil)
            case "LogInFacebookAndTwitter":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.facebook, .twitter, .dismissButton]
                present(logInViewController, animated: true, completion: nil)
            case "LogInAll":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .passwordForgotten, .logInButton, .facebook, .twitter, .signUpButton, .dismissButton]
                if let signUpController = logInViewController.signUpController {
                    signUpController.delegate = self
                    //signUpController.fields = [.usernameAndPassword, .email, .additional, .signUpButton, .dismissButton]
                    signUpController.fields = [.email, .additional, .signUpButton, .dismissButton]
                }
                present(logInViewController, animated: true, completion: nil)
            case "LogInAllNavigation":
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.usernameAndPassword, .passwordForgotten, .logInButton, .facebook, .twitter, .signUpButton, .dismissButton]
                if let signUpViewController = logInViewController.signUpController {
                    signUpViewController.delegate = self
                    //signUpViewController.fields = [.usernameAndPassword, .email, .additional, .signUpButton, .dismissButton]
                    signUpViewController.fields = [.email, .additional, .signUpButton, .dismissButton]
                }
                navigationController?.pushViewController(logInViewController, animated: true)
            case "LogInCustomizedLogoAndBackground":
                let logInViewController = CustomLogInViewController()
                logInViewController.delegate = self
                logInViewController.fields = [.default, .facebook, .twitter]
                
                let signUpViewController = CustomSignUpViewController()
                signUpViewController.delegate = self
                signUpViewController.fields = .default
                
                logInViewController.signUpController = signUpViewController
                present(logInViewController, animated: true, completion: nil)
                // -----
                // PFSignUpViewController
            // -----
            case "SignUpDefault":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpUsernamePassword":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.usernameAndPassword, .dismissButton]
                signUpViewController.fields = [.email, .dismissButton]
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpUsernamePasswordEmail":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.usernameAndPassword, .email, .dismissButton]
                signUpViewController.fields = [.email, .dismissButton]
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpUsernamePasswordEmailSignUp":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.usernameAndPassword, .email, .signUpButton, .dismissButton]
                signUpViewController.fields = [.email, .signUpButton, .dismissButton]
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpAll":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.usernameAndPassword, .email, .additional, .signUpButton, .dismissButton]
                signUpViewController.fields = [.email, .additional, .signUpButton, .dismissButton]
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpEmailAsUsername":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.UsernameAndPassword, .signUpButton, .dismissButton]
                signUpViewController.fields = [.email, .signUpButton, .dismissButton]
                signUpViewController.emailAsUsername = true
                present(signUpViewController, animated: true, completion: nil)
            case "SignUpMinPasswordLength":
                let signUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                //signUpViewController.fields = [.UsernameAndPassword, .signUpButton, .dismissButton]
                signUpViewController.fields = [.email, .signUpButton, .dismissButton]
                signUpViewController.minPasswordLength = 6
                present(signUpViewController, animated: true, completion: nil)
            // -----
            // PFQueryTableViewController
            // -----
            case "SimpleTable":
                let tableViewController = SimpleTableViewController(className: "Todo")
                navigationController?.pushViewController(tableViewController, animated: true)
            case "PaginatedTable":
                let tableViewController = PaginatedTableViewController(className: "Todo")
                navigationController?.pushViewController(tableViewController, animated: true)
            case "SectionedTable":
                let tableViewController = SectionedTableViewController(className: "Todo")
                navigationController?.pushViewController(tableViewController, animated: true)
            case "StoryboardTable":
                let storyboard = UIStoryboard(name: "SimpleQueryTableStoryboard-Swift", bundle: nil)
                let tableViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardTableViewController") as? StoryboardTableViewController
                navigationController?.pushViewController(tableViewController!, animated: true)
            case "DeletionTable":
                let tableViewController = DeletionTableViewController(className: "PublicTodo");
                navigationController?.pushViewController(tableViewController, animated: true);
            case "ImageTableDefaultStyle":
                let tableViewController = PFQueryTableViewController(className: "App")
                tableViewController.imageKey = "icon"
                tableViewController.textKey = "name"
                tableViewController.paginationEnabled = false
                tableViewController.placeholderImage = UIImage(named: "Icon.png")
                navigationController?.pushViewController(tableViewController, animated: true)
            case "ImageTableSubtitleStyle":
                let tableViewController = SubtitleImageTableViewController(className: "App")
                tableViewController.imageKey = "icon"
                tableViewController.textKey = "name"
                tableViewController.paginationEnabled = false
                tableViewController.placeholderImage = UIImage(named: "Icon.png")
                navigationController?.pushViewController(tableViewController, animated: true)
            // -----
            // PFQueryCollectionViewController
            // -----
            case "SimpleCollection":
                let collectionViewController = SimpleCollectionViewController(className: "Todo")
                navigationController?.pushViewController(collectionViewController, animated: true)
            case "PaginatedCollection":
                let collectionViewController = PaginatedCollectionViewController(className: "Todo")
                navigationController?.pushViewController(collectionViewController, animated: true)
            case "SectionedCollection":
                let collectionViewController = SectionedCollectionViewController(className: "Todo")
                navigationController?.pushViewController(collectionViewController, animated: true)
            case "StoryboardCollection":
                let storyboard = UIStoryboard(name: "SimpleQueryCollectionStoryboard-Swift", bundle: nil)
                let collectionViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardCollectionViewController") as? StoryboardCollectionViewController
                navigationController?.pushViewController(collectionViewController!, animated: true)
            case "DeletionCollection":
                let collectionViewController = DeletionCollectionViewController(className: "PublicTodo");
                navigationController?.pushViewController(collectionViewController, animated: true)
            case "ImageCollection":
                let collectionViewController = SubtitleImageCollectionViewController(className: "App")
                navigationController?.pushViewController(collectionViewController, animated: true)
            // -----
            // PFProductTableViewController
            // -----
            case "Product":
                let productTableViewController = PFProductTableViewController()
                navigationController?.pushViewController(productTableViewController, animated: true)
            case "CustomizedProduct":
                let productTableViewController = CustomProductTableViewController()
                navigationController?.pushViewController(productTableViewController, animated: true)
            default:
                let productTableViewController = PFProductTableViewController()
                navigationController?.pushViewController(productTableViewController, animated: true)
            }
        }
    }
    
}

extension UIDemoViewController : PFLogInViewControllerDelegate {
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIDemoViewController : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        dismiss(animated: true, completion: nil)
    }
    
}
