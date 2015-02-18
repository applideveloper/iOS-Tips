// ViewController.swift
//
// Copyright (c) 2015 Shintaro Kaneko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var invisibleScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstCollectionView.dataSource = self
        self.secondCollectionView.dataSource = self

        self.invisibleScrollView.userInteractionEnabled = false
        self.secondCollectionView.addGestureRecognizer(
            self.invisibleScrollView.panGestureRecognizer)
        self.invisibleScrollView.delegate = self

        dispatch_after(1, dispatch_get_main_queue()) {
            let size = self.secondCollectionView.contentSize
            self.invisibleScrollView.contentSize = CGSize(width: size.width, height: size.height)
            return
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.secondCollectionView.contentOffset = self.invisibleScrollView.contentOffset
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }

    @IBAction func handleSwitch(sender: UISwitch) {
        var backgroundColor: UIColor = UIColor.clearColor()
        if sender.on {
            backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }
        self.invisibleScrollView.backgroundColor = backgroundColor
    }

}
