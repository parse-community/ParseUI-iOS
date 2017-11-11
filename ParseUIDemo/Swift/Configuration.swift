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

open class Configuration {
    
    public struct parseParameters {
        static let kParseApplicationId = "ParseUIDemo"
        static let kParseMasterKey     = ""
        static let kParseClientKey     = "unset"
        static let kParseApiKey        = "unset"
        static let kParseServer        = "http://localhost:1337/parse"
        static let kParseAdminUserName = ""
        static let kParseAdminPassword = ""
    }
    
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
