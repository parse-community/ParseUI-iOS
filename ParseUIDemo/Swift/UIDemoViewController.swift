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

enum UIDemoType : Int {
    case LogInDefault

    static var count: Int {
        var count = 0
        while let _ = self(rawValue: ++count) { }
        return count
    }
}

extension UIDemoType : Printable {

    var description: String {
        switch (self) {
        case LogInDefault:
            return "Log In Default"
        }
    }

}

class UIDemoViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ParseUI Demo"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension UIDemoViewController : UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIDemoType.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as UITableViewCell
        cell.textLabel?.text = UIDemoType(rawValue: indexPath.row)?.description
        return cell
    }
}

extension UIDemoViewController : UITableViewDelegate {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let demoType = UIDemoType(rawValue: indexPath.row) {
            switch (demoType) {
                // -----
                // PFLogInViewController
                // -----
            case .LogInDefault:
                let logInViewController = PFLogInViewController()
                logInViewController.delegate = self
                presentViewController(logInViewController, animated: true, completion: nil)
            }
        }
    }

}
