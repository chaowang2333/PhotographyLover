//
//  PhotographyLoverTests.swift
//  PhotographyLoverTests
//
//  Created by wc on 19/03/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import XCTest
import CoreData
@testable import PhotographyLover

class PhotographyLoverTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // test main cell
    func testMainCell() {
        let photoModel = PhotoModel()
        photoModel.uname = "Frank"
        photoModel.aperture = "4.8"
        photoModel.iso = "200"
        photoModel.shutter = "0.02"
        photoModel.uploaddate = "2017-05-17 03:50:43+0000"
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let mainCell = viewController.tableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainCell?
        mainCell??.setData(data: photoModel)
        XCTAssert(mainCell??.lblApeture.text == " Aperture: 4.8 ")
        XCTAssert(mainCell??.lblIso.text == " ISO: 200 ")
        XCTAssert(mainCell??.lblShutter.text == " Shutter: 0.02 ")
        XCTAssert(mainCell??.lblDate.text == "2017-05-17 03:50:43")
        XCTAssert(mainCell??.lblName.text == "Frank")
    }
    
    // test download detail
    func testDownloadDetail() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        let photo = Photo.init(entity: NSEntityDescription.entity(forEntityName: "Photo", in: managedObjectContext)!, insertInto: managedObjectContext)
        photo.uname = "Frank"
        photo.aperture = "4.8"
        photo.iso = "200"
        photo.shutter = "0.02"
        photo.uploaddate = "2017-05-17 03:50:43+0000"
        photo.device = "Canon 700D"
        photo.desc = "Hello ~~~~~~~"
        photo.tags = []
        
        let detailVC : DetailViewController
        detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.setDownloadData(downloadData: photo)
        detailVC.loadView()
        detailVC.viewDidLoad()
        XCTAssert(detailVC.lblApeture.text == " Aperture: 4.8 ")
        XCTAssert(detailVC.lblIso.text == " ISO: 200 ")
        XCTAssert(detailVC.lblShutter.text == " Shutter: 0.02 ")
        XCTAssert(detailVC.lblDate.text == "2017-05-17 03:50:43")
        XCTAssert(detailVC.lblName.text == "Frank")
        XCTAssert(detailVC.lblDevice.text == "Canon 700D")
        XCTAssert(detailVC.lblDesc.text == "Hello ~~~~~~~")
    }
    
    // test download detail (blank value)
    func testDownloadDetailBlank() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        let photo = Photo.init(entity: NSEntityDescription.entity(forEntityName: "Photo", in: managedObjectContext)!, insertInto: managedObjectContext)
        photo.uname = "Frank"
        photo.aperture = "4.8"
        photo.iso = "200"
        photo.shutter = "0.02"
        photo.uploaddate = "2017-05-17 03:50:43+0000"
        photo.device = ""
        photo.desc = ""
        photo.tags = []
        
        let detailVC : DetailViewController
        detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.setDownloadData(downloadData: photo)
        detailVC.loadView()
        detailVC.viewDidLoad()
        XCTAssert(detailVC.lblApeture.text == " Aperture: 4.8 ")
        XCTAssert(detailVC.lblIso.text == " ISO: 200 ")
        XCTAssert(detailVC.lblShutter.text == " Shutter: 0.02 ")
        XCTAssert(detailVC.lblDate.text == "2017-05-17 03:50:43")
        XCTAssert(detailVC.lblName.text == "Frank")
        XCTAssert(detailVC.lblDevice.text == "")
        XCTAssert(detailVC.lblDesc.text == "")
    }
    
    // test main detail
    func testMainDetail() {
        let photoModel = PhotoModel()
        photoModel.uname = "Frank"
        photoModel.aperture = "4.8"
        photoModel.iso = "200"
        photoModel.shutter = "0.02"
        photoModel.uploaddate = "2017-05-17 03:50:43+0000"
        photoModel.device = "Canon 700D"
        photoModel.desc = "Hello ~~~~~~~"
        photoModel.tags = []
        
        let detailVC : DetailViewController
        detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.setData(data: photoModel)
        detailVC.loadView()
        detailVC.viewDidLoad()
        XCTAssert(detailVC.lblApeture.text == " Aperture: 4.8 ")
        XCTAssert(detailVC.lblIso.text == " ISO: 200 ")
        XCTAssert(detailVC.lblShutter.text == " Shutter: 0.02 ")
        XCTAssert(detailVC.lblDate.text == "2017-05-17 03:50:43")
        XCTAssert(detailVC.lblName.text == "Frank")
        XCTAssert(detailVC.lblDevice.text == "Canon 700D")
        XCTAssert(detailVC.lblDesc.text == "Hello ~~~~~~~")
    }
    
    // test main detail (blank value)
    func testMainDetailBlank() {
        let photoModel = PhotoModel()
        photoModel.uname = "Frank"
        photoModel.aperture = "4.8"
        photoModel.iso = "200"
        photoModel.shutter = "0.02"
        photoModel.uploaddate = "2017-05-17 03:50:43+0000"
        photoModel.device = ""
        photoModel.desc = ""
        photoModel.tags = []
        
        let detailVC : DetailViewController
        detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.setData(data: photoModel)
        detailVC.loadView()
        detailVC.viewDidLoad()
        XCTAssert(detailVC.lblApeture.text == " Aperture: 4.8 ")
        XCTAssert(detailVC.lblIso.text == " ISO: 200 ")
        XCTAssert(detailVC.lblShutter.text == " Shutter: 0.02 ")
        XCTAssert(detailVC.lblDate.text == "2017-05-17 03:50:43")
        XCTAssert(detailVC.lblName.text == "Frank")
        XCTAssert(detailVC.lblDevice.text == "")
        XCTAssert(detailVC.lblDesc.text == "")
    }
}
