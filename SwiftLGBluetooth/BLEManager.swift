//
//  BLEManager.swift
//  SwiftLGBluetooth
//
//  Created by 本間和弘 on 2015/10/26.
//  Copyright © 2015年 Kazuhiro Homma. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let serviceUUID        = CBUUID(string: "82AA4839-A04D-758E-1247-5B32CD8784E2")
    let characteristicUUID = CBUUID(string: "029EF1BE-5F86-EAA2-AE4E-7935D7C7EF29")
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    
    class var sharedInstance : BLEManager {
        struct Static {
            static let instance : BLEManager = BLEManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    internal func scanBeacon() {
        let services : [CBUUID]? = [self.serviceUUID]
        self.centralManager.scanForPeripheralsWithServices(services, options: nil)
    }
    
    internal func centralManagerDidUpdateState(central: CBCentralManager) {
        
    }
    
    internal func centralManager(central: CBCentralManager,
        didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String : AnyObject],
        RSSI: NSNumber)
    {
        print("peripheral: \(peripheral)")
        self.peripheral = peripheral
        self.centralManager.connectPeripheral(self.peripheral, options: nil)
    }
    
    internal func centralManager(central: CBCentralManager,
        didConnectPeripheral peripheral: CBPeripheral)
    {
        print("connected!")
        let services : [CBUUID]? = [self.serviceUUID]
        
        self.peripheral.delegate = self
        self.peripheral.discoverServices(services)
    }
    
    internal func centralManager(central: CBCentralManager,
        didFailToConnectPeripheral peripheral: CBPeripheral,
        error: NSError?)
    {
        print("failed...")
    }
    
    internal func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        if (error != nil) {
            print("error: \(error)")
            return
        }
        
        if !(peripheral.services?.count > 0) {
            print("no services")
            return
        }
        
        let services = peripheral.services!
        print("Found \(services.count) services! :\(services)")
        
        let characteristices : [CBUUID]? = [self.characteristicUUID]
        peripheral.discoverCharacteristics(characteristices, forService: services[0])
    }
    
    internal func peripheral(peripheral: CBPeripheral,
        didDiscoverCharacteristicsForService service: CBService,
        error: NSError?)
    {
        if (error != nil) {
            print("error: \(error)")
            return
        }
        
        if !(service.characteristics?.count > 0) {
            print("no characteristics")
            return
        }
        
        let characteristics = service.characteristics!
        self.characteristic = characteristics[0]
        print("Found \(characteristics.count) characteristics! : \(characteristics)")
        
        // 購読開始
        self.peripheral.setNotifyValue(true, forCharacteristic: self.characteristic)
    }
    
    internal func peripheral(peripheral: CBPeripheral,
        didUpdateValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?)
    {
        if error != nil {
            print("データ更新通知エラー: \(error)")
            return
        }
        
        print("データ更新！ characteristic UUID: \(characteristic.UUID), value: \(characteristic.value)")
    }
}
